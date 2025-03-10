Class {
	#name : #GtGQLSnippetElement,
	#superclass : #LeSnippetElement,
	#instVars : [
		'gqlElement',
		'completionStrategy',
		'dropDownLook'
	],
	#category : #'GToolkit4GraphQL-Snippet-Element'
}

{ #category : #'private - event handling' }
GtGQLSnippetElement >> browseSchema [
	| schema |
	schema := self context ifNotNil: [ :context | context schema ].
	schema ifNil: [ ^ self ].
	self operationNodeAtCursor
		ifNotNil: [ :node | 
			| obj |
			(node isKindOf: GraphQLOperationDefinitionNode)
				ifTrue: [ node isPartOfQuery ifTrue: [ obj := schema queryType ].
					node isPartOfMutation ifTrue: [ obj := schema mutationType ] ].

			(node isKindOf: GraphQLFieldNode) ifTrue: [ obj := node fieldIn: schema ].

			(node isKindOf: GraphQLNamedTypeNode)
				ifTrue: [ obj := (schema typeNamed: node source) ifNotNil: [ :t | t baseType ] ].

			((node isKindOf: GraphQLArgumentNode)
				and: [ (node name sourceInterval includes: self operationCursor)
						and: [ node parent isKindOf: GraphQLFieldNode ] ])
				ifTrue: [ obj := (node parent fieldIn: schema)
							ifNotNil: [ :field | field arguments detect: [ :each | each name = node name source ] ifNone: [  ] ] ].

			obj ifNotNil: [ gqlElement phlow spawnObject: obj ] ]
]

{ #category : #private }
GtGQLSnippetElement >> clearPreviousErrors [
	| text |
	text := self operationEditor editor text.
	text
		clearAttributes: 0
		to: text size
		if: [ :each | each class == GtSourceCoderErrorAttribute ]
]

{ #category : #accessing }
GtGQLSnippetElement >> context [
	<return: #GtGQLContext>
	^ self snippetViewModel context
]

{ #category : #accessing }
GtGQLSnippetElement >> contextDropDown [
	| element button |
	element := BrHorizontalGrid new.
	element fitContent.
	element margin: (BlInsets all: 3).
	element
		addAptitude: (BrStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle geometry: (BlRoundedRectangleGeometry cornerRadius: 4).
					aStyle background: self theme status neutralBackgroundColor.
					aStyle border: BlBorder empty ];
				hovered: [ :aStyle | aStyle background: self theme status neutralBackgroundColor darker ]).
	button := self createDropDownButton.

	dropDownLook := BrGlamorousWithExplicitDropdownAptitude
			handle: [ self createDropDownButton ]
			content: [ | aContextVariables hasVariables aListItems |
				aContextVariables := self contextVariables.
				hasVariables := aContextVariables isNotNil
						and: [ aContextVariables isNotEmpty ].
				aListItems := aContextVariables
						ifNil: [ #('cannot select variables due to missing context') ]
						ifNotNil: [ aContextVariables
								ifEmpty: [ #('there are no available variables') ]
								ifNotEmpty: [ aContextVariables ] ].

				BrSimpleList new
					fitContent;
					stencil: [ :each | 
						BrHorizontalPane new
							hMatchParent;
							vFitContent;
							padding: (BlInsets all: 5);
							aptitude: (BrStyleCommonAptitude new
									default: [ :s | s background: Color transparent ];
									hovered: [ :s | s background: self theme button defaultBorderColor ];
									yourself);
							when: BlClickEvent
								do: [ :anEvent | 
									anEvent consumed: true.
									anEvent currentTarget fireEvent: BrDropdownHideWish new.
									hasVariables
										ifTrue: [ button label: each.
											self snippet context: each ] ];
							addChild: (BrLabel new
									aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize;
									text: each;
									yourself);
							yourself ];
					items: aListItems;
					yourself ].
	dropDownLook doNotHideWidget.
	button addAptitude: dropDownLook.
	button
		addAptitude: (BrStyleCommonAptitude new
				default: [ :s | s background: Color transparent ];
				hovered: [ :s | s background: self theme status neutralBackgroundColor darker ]).
	element addChild: button as: #contextButton.
	^ element
]

{ #category : #accessing }
GtGQLSnippetElement >> contextVariable [
	^ (snippetViewModel ifNotNil: [ self snippet context ]) ifNil: [ ' ' ]
]

{ #category : #accessing }
GtGQLSnippetElement >> contextVariables [
	"Return a collection of variable names.
	- empty collection indicates that there is an existing snippet context, but there are not variables.
	- nil indicates that there is no snippet context (and therefore there is not way to select variables)"

	<return: #Collection or: nil>
	| aSnippetContext |
	aSnippetContext := self snippetContext ifNil: [ ^ nil ].
	^ self snippet contextVariablesUsing: aSnippetContext
]

{ #category : #accessing }
GtGQLSnippetElement >> createDropDownButton [
	| button |
	button := BrButton new.
	button
		aptitude: BrTextLabelAptitude new glamorousRegularFont glamorousCodeSmallSize
				+ BrGlamorousButtonIconAptitude + BrGlamorousButtonLayoutAptitude.
	button vExact: 20.
	button padding: (BlInsets left: 4 right: 2).
	button label: self contextVariable.
	button icon: BrGlamorousVectorIcons downwards.
	button beSmallSize.
	^ button
]

{ #category : #accessing }
GtGQLSnippetElement >> createLabel: aString [
	^ BrLabel new
		text: aString asRopedText;
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
				foreground: Color gray;
				fontSize: 12);
		yourself
]

{ #category : #accessing }
GtGQLSnippetElement >> createNewSnippet [
	| snippet |
	snippet := self snippet class empty.
	snippet context: self snippet context.
	self snippet addSnippetAfterSelf: snippet.
	self snippetViewModel focusNextSnippet
]

{ #category : #accessing }
GtGQLSnippetElement >> createSourceEditor: anUpdateSymbol [
	| element |
	element := BrEditor new.
	element vFitContent.
	element hMatchParent.
	element padding: (BlInsets all: 10).
	element
		aptitude: (BrGlamorousEditableLabelAptitude new) + (BrGlamorousCodeEditorAptitude new) .
	element editor
		when: BrTextEditorInsertedEvent do: [ :event | self perform: anUpdateSymbol ];
		when: BrTextEditorDeletedEvent do: [ :event | self perform: anUpdateSymbol ];
		when: BlInfiniteDataSourceChanged
			do: [ :event | self perform: anUpdateSymbol ].
	element
		addShortcut: (BrEditorShortcut loseFocus
				combination: (self class keyboardShortcut: #LoseFocus));
		addShortcut: (LeSnippetIndentSnippetShortcut new
				combination: (self class keyboardShortcut: #IndentSnippet));
		addShortcut: (LeSnippetUnindentSnippetShortcut new
				combination: (self class keyboardShortcut: #UnindentSnippet));
		addShortcut: (LeSnippetMoveSnippetUpShortcut new
				combination: (self class keyboardShortcut: #MoveSnippetUp));
		addShortcut: (LeSnippetMoveSnippetDownShortcut new
				combination: (self class keyboardShortcut: #MoveSnippetDown));
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder primary return build;
				action: [ :anEvent :aShortcut | self createNewSnippet ]).

	^ element
]

{ #category : #accessing }
GtGQLSnippetElement >> executeQuery: aButton [
	| aContext aFuture |
	aContext := self context.
	aContext ifNil: [ ^ self ].
	self clearPreviousErrors.
	aButton disable.

	aFuture := [ aContext client query: self snippetViewModel query ].

	aButton
		withAsyncFutureDo: [ :anElementFuture | anElementFuture future: aFuture asAsyncFuture ]
]

{ #category : #'focus accessing' }
GtGQLSnippetElement >> exitInputEditorWith: event [
	self
		inUIProcessDo: [ event isTop
				ifTrue: [ gqlElement
						childNamed: #operationEditor
						ifFound: [ :editor | editor requestFocus ] ]
				ifFalse: [ gqlElement
						childNamed: #variableEditor
						ifFound: [ :editor | editor requestFocus ] ] ].
	event consumed: true
]

{ #category : #'focus accessing' }
GtGQLSnippetElement >> exitOperationEditorWith: event [
	event isTop
		ifTrue: [ self contextVariable trim isEmpty
				ifTrue: [ dropDownLook show ]
				ifFalse: [ self snippetViewModel focusPreviousSnippet ] ]
		ifFalse: [ self
				inUIProcessDo: [ gqlElement
						childNamed: #inputEditor
						ifFound: [ :editor | editor requestFocus ] ] ].
	event consumed: true
]

{ #category : #'focus accessing' }
GtGQLSnippetElement >> exitVariableEditorWith: event [
	event isTop
		ifTrue: [ self
				inUIProcessDo: [ gqlElement
						childNamed: #inputEditor
						ifFound: [ :editor | editor requestFocus ] ] ]
		ifFalse: [ self snippetViewModel focusNextSnippet ].
	event consumed: true
]

{ #category : #accessing }
GtGQLSnippetElement >> initialize [
	| contextElement operationEditor completionController inputEditor toolbar variableEditor |
	super initialize.
	gqlElement := BrVerticalPane new.
	gqlElement padding: (BlInsets all: 5).
	gqlElement vFitContent.
	gqlElement hMatchParent.
	contextElement := BrHorizontalPane new.
	contextElement hMatchParent.
	contextElement vFitContent.
	contextElement margin: (BlInsets bottom: 2).
	contextElement
		addChild: ((self createLabel: 'GraphQL:') margin: (BlInsets top: 5)).
	contextElement addChild: self contextDropDown as: #contextDropDown.
	gqlElement addChild: contextElement.
	operationEditor := self createSourceEditor: #updateOperation.
	operationEditor when: BlFocusInEvent do: [ :event | self updateCompletion ].
	operationEditor
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryR;
				repeatable: false;
				action: [ :element | self renameInOperation ]);
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryB;
				repeatable: false;
				action: [ :element | self browseSchema ]).
	operationEditor editor
		when: BrTextEditorCursorReachedBoundaryEvent
		do: [ :event | self exitOperationEditorWith: event ].
	operationEditor editor styler: GraphQLParser gtStyler.
	completionStrategy := GtGQLCompletionStrategy new.
	completionController := GtCompletionController
			on: operationEditor
			strategy: completionStrategy.
	completionController install.
	gqlElement addChild: operationEditor as: #operationEditor.
	gqlElement addChild: (self createLabel: 'Variables:').
	inputEditor := self createSourceEditor: #updateInput.
	inputEditor
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryR;
				repeatable: false;
				action: [ :element | self renameInInput ]).
	inputEditor editor
		when: BrTextEditorCursorReachedBoundaryEvent
		do: [ :event | self exitInputEditorWith: event ].
	inputEditor editor styler: JSONParser gtStyler.
	gqlElement addChild: inputEditor as: #inputEditor.
	toolbar := BrHorizontalPane new
			vFitContent;
			hFitContentLimited;
			margin: (BlInsets top: 5).
	gqlElement addChild: toolbar as: #toolbar.
	toolbar
		addChild: (BrButton new
				beSmallSize;
				constraintsDo: [ :c | c linear vertical alignCenter ];
				aptitude: BrGlamorousButtonWithIconAptitude;
				icon: BrGlamorousIcons playinspect asElement;
				label: 'Execute' asString;
				action: [ :aButton | self executeQuery: aButton ];
				withAsyncFutureDo: [ :anElementFuture | 
					anElementFuture
						whenPending: [ :theButton | theButton disable ];
						whenError: [ :theButton :anError | self onExecutionError: anError from: theButton ];
						whenSuccess: [ :theButton :aResult | self onExecutionSuccess: aResult from: theButton ] ])
		as: #executeButton.
	variableEditor := self createSourceEditor: #updateVariable.
	variableEditor editor
		when: BrTextEditorCursorReachedBoundaryEvent
		do: [ :event | self exitVariableEditorWith: event ].
	toolbar
		addChild: ((self createLabel: 'Result:')
				constraintsDo: [ :c | c linear vertical alignCenter ];
				margin: (BlInsets
						top: 0
						left: 10
						bottom: 0
						right: 3));
		addChild: (variableEditor
					hFitContentLimited;
					styler: GtSelectorStyler new forUnary;
					inputFilter: GtSelectorInputFilter forUnaryMessage;
					constraintsDo: [ :c | c linear vertical alignCenter ];
					padding: (BlInsets all: 3))
			as: #variableEditor
]

{ #category : #refactoring }
GtGQLSnippetElement >> inputAst [
	^ self inputSource ifNotNil: [ :string | JSONParser parseWithErrors: string ]
]

{ #category : #refactoring }
GtGQLSnippetElement >> inputCursor [
	| cursors |
	^ self inputEditor
		ifNotNil: [ :editor | 
			cursors := editor cursors.
			cursors isSingle ifTrue: [ cursors first position ] ]
]

{ #category : #accessing }
GtGQLSnippetElement >> inputEditor [
	^ gqlElement
		childNamed: #inputEditor
		ifFound: [ :editor | editor ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtGQLSnippetElement >> inputSource [
	^ gqlElement
		childNamed: #inputEditor
		ifFound: [ :editor | editor editor text asString ]
		ifNone: [ nil ]
]

{ #category : #'private - event handling' }
GtGQLSnippetElement >> onExecutionError: anError from: theButton [
	[ | aResult |
	aResult := GtGQLPreparationProblem new
			context: self context;
			operation: self snippet operation input: self snippet input;
			exception: anError;
			messageText: ('Problem during execution: {1}' format: {anError}).
	self snippetViewModel resultValue: aResult.
	theButton phlow spawnObject: aResult ] ensure: [ theButton enable ]
]

{ #category : #'private - event handling' }
GtGQLSnippetElement >> onExecutionSuccess: aResult from: theButton [
	[ self snippetViewModel resultValue: aResult.
	(aResult isQueryProblem or: [ aResult isSuccess and: [ aResult hasErrors ] ])
		ifTrue: [ (self showInlineError: aResult)
				ifFalse: [ theButton phlow spawnObject: aResult report ] ]
		ifFalse: [ theButton phlow spawnObject: aResult report ] ]
		ensure: [ theButton enable ]
]

{ #category : #accessing }
GtGQLSnippetElement >> onSnippetViewModelChanged [
	super onSnippetViewModelChanged.
	self setDefaultContextVariable.
	self updateInputEditor.
	self updateOperationEditor.
	self updateContext.
	self updateVariableEditor
]

{ #category : #accessing }
GtGQLSnippetElement >> onSnippetViewModelFocused: aBoolean [
	super onSnippetViewModelFocused: aBoolean.
	aBoolean
		ifTrue: [ self contextVariable trim isEmpty
				ifTrue: [ dropDownLook canShow ifTrue: [ dropDownLook show ] ]
				ifFalse: [ gqlElement
						childNamed: #operationEditor
						ifFound: [ :editor | editor inUIProcessDo: [ editor requestFocus ] ]
						ifNone: [ nil ] ] ]
]

{ #category : #refactoring }
GtGQLSnippetElement >> operationAst [
	^ self operationSource
		ifNotNil: [ :string | GraphQLParser parseWithErrors: string ]
]

{ #category : #refactoring }
GtGQLSnippetElement >> operationCursor [
	| cursors |
	^ self operationEditor
		ifNotNil: [ :editor | 
			cursors := editor cursors.
			cursors isSingle ifTrue: [ cursors first position ] ]
]

{ #category : #accessing }
GtGQLSnippetElement >> operationEditor [
	^ gqlElement
		childNamed: #operationEditor
		ifFound: [ :editor | editor ]
		ifNone: [ nil ]
]

{ #category : #refactoring }
GtGQLSnippetElement >> operationNodeAtCursor [
	| gqlAst |
	^ self operationCursor
		ifNotNil: [ :position | 
			self operationEditor
				ifNotNil: [ :editor | 
					gqlAst := self operationAst.
					gqlAst nodeAt: position ] ]
]

{ #category : #accessing }
GtGQLSnippetElement >> operationSource [
	^ gqlElement
		childNamed: #operationEditor
		ifFound: [ :editor | editor editor text asString ]
		ifNone: [ nil ]
]

{ #category : #refactoring }
GtGQLSnippetElement >> renameInInput [
	| jsonAst cursor jsonInterval name intervals action |
	jsonAst := self inputAst.
	(jsonAst isKindOf: JSONObjectNode) ifFalse: [ ^ self ].
	cursor := self inputCursor.
	jsonAst members
		detect: [ :each | 
			(each isKindOf: JSONMemberNode)
				and: [ cursor between: each name startPosition + 1 and: each name stopPosition - 1 ] ]
		ifFound: [ :each | 
			name := '$' , each name source allButFirst allButLast.
			jsonInterval := each name startPosition + 1 to: each name stopPosition - 1 ]
		ifNone: [ ^ self ].
	intervals := OrderedCollection new.
	self operationAst
		withAllNodesDo: [ :each | 
			((each isKindOf: GraphQLVariableNode) and: [ each source = name ])
				ifTrue: [ intervals add: (each startPosition + 1 to: each stopPosition) ] ].
	action := GtCompositeRenameAction
			locations: {jsonInterval}
			element: self inputEditor.
	action forVariableOrUnaryMessage.
	action addLocations: intervals to: self operationEditor editor.
	action install
]

{ #category : #refactoring }
GtGQLSnippetElement >> renameInOperation [
	| jsonAst nodeToRename intervals jsonInterval name action |
	nodeToRename := self operationNodeAtCursor.
	(nodeToRename isKindOf: GraphQLVariableNode) ifFalse: [ ^ self ].
	intervals := OrderedCollection new.
	intervals add: (nodeToRename startPosition + 1 to: nodeToRename stopPosition).
	nodeToRename topParent
		withAllNodesDo: [ :each | 
			(each ~~ nodeToRename and: [ each = nodeToRename ])
				ifTrue: [ intervals add: (each startPosition + 1 to: each stopPosition) ] ].
	jsonAst := self inputAst.
	(jsonAst isKindOf: JSONObjectNode)
		ifTrue: [ name := '"' , nodeToRename source allButFirst , '"'.
			jsonAst members
				detect: [ :each | each name source = name ]
				ifFound: [ :each | jsonInterval := each name startPosition + 1 to: each name stopPosition - 1 ] ].
	action := GtCompositeRenameAction
			locations: intervals
			element: self operationEditor.
	action forVariableOrUnaryMessage.
	jsonInterval
		ifNotNil: [ action addLocations: {jsonInterval} to: self inputEditor editor ].
	action install
]

{ #category : #accessing }
GtGQLSnippetElement >> setDefaultContextVariable [
	self contextVariable trim notEmpty ifTrue: [ ^ self ].
	(self snippet defaultContextUsing: self snippetContext)
		ifNotNil: [ :each | self snippet context: each ]
]

{ #category : #'private - event handling' }
GtGQLSnippetElement >> showInlineError: aResult [
	"Return false if it is not possible to display errors."

	<return: #Boolean>
	| editor text first errorShownInline |
	first := true.
	errorShownInline := false.
	editor := self operationEditor editor.
	text := editor text asString.
	text = aResult query operation ifFalse: [ ^ false ].
	aResult
		errorMessagesAndLocationsDo: [ :message :line :column | 
			(message isNil or: [ line isNil or: [ column isNil ] ])
				ifFalse: [ (text gtIndexOfLineNumber: line)
						ifNotNil: [ :location | 
							editor text
								attributes: {(GtSourceCoderErrorAttribute for: message)
											openOnFirstShow: first;
											clickAction: [ :element | element phlow spawnObject: aResult ];
											beOverwritableByStyler}
								from: location key + column - 2
								to: location key + column - 2.
							errorShownInline := true.
							first := false ] ] ].

	^ errorShownInline
]

{ #category : #'api - view' }
GtGQLSnippetElement >> snippetContent [
	^ gqlElement
]

{ #category : #accessing }
GtGQLSnippetElement >> snippetContext [
	snippetViewModel snippetsCollectionDo: [ :each | ^ each sharedSnippetContext ].
	^ nil
]

{ #category : #'api - view' }
GtGQLSnippetElement >> snippetToolbar [
	^ nil
]

{ #category : #accessing }
GtGQLSnippetElement >> subscribeToSnippetViewModel [
	super subscribeToSnippetViewModel.
	self snippetViewModel weak
		when: GtGQLSnippetContextChanged
		send: #updateContext
		to: self.
	self snippetViewModel weak
		when: GtGQLSnippetInputChanged
		send: #updateInputEditor
		to: self.
	self snippetViewModel weak
		when: GtGQLSnippetOperationChanged
		send: #updateOperationEditor
		to: self.
	self snippetViewModel weak
		when: GtGQLSnippetResultVariableNameChanged
		send: #updateVariableEditor
		to: self
]

{ #category : #accessing }
GtGQLSnippetElement >> unsubscribeFromSnippetViewModel [
	super unsubscribeFromSnippetViewModel.
	self snippetViewModel unsubscribe: self
]

{ #category : #accessing }
GtGQLSnippetElement >> updateCompletion [
	self context ifNotNil: [ :context | completionStrategy schema: context schema ]
]

{ #category : #accessing }
GtGQLSnippetElement >> updateContext [
	gqlElement
		childNamed: #contextButton
		ifFound: [ :button | button label: self contextVariable ].
	self updateCompletion
]

{ #category : #updating }
GtGQLSnippetElement >> updateInput [
	gqlElement
		childNamed: #inputEditor
		ifFound: [ :editor | 
			| searchString |
			searchString := editor editor text asString.
			searchString ~= self snippet input
				ifTrue: [ self snippet input: searchString ] ]
]

{ #category : #updating }
GtGQLSnippetElement >> updateInputEditor [
	gqlElement
		childNamed: #inputEditor
		ifFound: [ :editor | 
			editor editor text asString ~= self snippet input
				ifTrue: [ editor editor text: (self snippet input ifNil: [ '' ]) asRopedText ] ]
]

{ #category : #updating }
GtGQLSnippetElement >> updateOperation [
	self operationSource
		ifNotNil: [ :searchString | 
			searchString ~= self snippet operation
				ifTrue: [ self snippet operation: searchString ] ]
]

{ #category : #updating }
GtGQLSnippetElement >> updateOperationEditor [
	gqlElement
		childNamed: #operationEditor
		ifFound: [ :editor | 
			editor editor text asString ~= self snippet operation
				ifTrue: [ editor editor text: self snippet operation asRopedText ] ]
]

{ #category : #updating }
GtGQLSnippetElement >> updateVariable [
	self variableSource
		ifNotNil: [ :searchString | 
			searchString ~= self snippet resultVariableName
				ifTrue: [ self snippet resultVariableName: searchString  ] ]
]

{ #category : #updating }
GtGQLSnippetElement >> updateVariableEditor [
	gqlElement
		childNamed: #variableEditor
		ifFound: [ :editor | 
			editor editor text asString ~= self snippet resultVariableName
				ifTrue: [ editor editor
						text: (self snippet resultVariableName ifNil: [ '' ]) asRopedText ] ]
]

{ #category : #accessing }
GtGQLSnippetElement >> variableSource [
	^ gqlElement
		childNamed: #variableEditor
		ifFound: [ :editor | editor editor text asString ]
		ifNone: [ nil ]
]
