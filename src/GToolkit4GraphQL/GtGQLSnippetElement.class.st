Class {
	#name : #GtGQLSnippetElement,
	#superclass : #LeSnippetElement,
	#instVars : [
		'gqlElement',
		'completionStrategy'
	],
	#category : #'GToolkit4GraphQL-Snippet-Element'
}

{ #category : #accessing }
GtGQLSnippetElement >> context [
	^ self snippet contextUsing: self snippetContext
]

{ #category : #accessing }
GtGQLSnippetElement >> contextDropDown [
	| element button dropDownLook |
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
	dropDownLook := BrGlamorousWithDropdownAptitude
			handle: [ self createDropDownButton ]
			content: [ BrSimpleList new
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
									button label: each.
									anEvent currentTarget fireEvent: BrDropdownHideWish new.
									self snippet context: each ];
							addChild: (BrLabel new
									aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize;
									text: each;
									yourself);
							yourself ];
					items: self contextVariables;
					yourself ].
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
	^ self snippet contextVariablesUsing: self snippetContext
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
GtGQLSnippetElement >> createSourceEditor: anUpdateSymbol [
	| element |
	element := BrEditor new.
	element vFitContent.
	element hMatchParent.
	element padding: (BlInsets all: 10).
	element
		aptitude: BrGlamorousCodeEditorAptitude + BrGlamorousEditableLabelAptitude.
	element editor
		when: BrTextEditorInsertedEvent do: [ :event | self perform: anUpdateSymbol ];
		when: BrTextEditorDeletedEvent do: [ :event | self perform: anUpdateSymbol ];
		when: BlInfiniteDataSourceChanged
			do: [ :event | self perform: anUpdateSymbol ].
	^ element
]

{ #category : #accessing }
GtGQLSnippetElement >> executeQuery [
	self context
		ifNotNil: [ :context | 
			[ | operation input |
			operation := (gqlElement childNamed: #operationEditor) text asString.
			input := (gqlElement childNamed: #inputEditor) text asString trim.
			input isEmpty
				ifTrue: [ context client query: operation ]
				ifFalse: [ context client query: operation variables: input ] ]
				asAsyncPromise
				then: [ :json | gqlElement inUIProcessDo: [ gqlElement phlow spawnObject: json ] ]
				otherwise: [ :ex | gqlElement inUIProcessDo: [ gqlElement phlow spawnObject: ex ] ] ]
]

{ #category : #accessing }
GtGQLSnippetElement >> initialize [
	| contextElement operationEditor completionController inputEditor |
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
				action: [ :element | self renameInOperation ]).
	operationEditor editor styler: GraphQLParser gtStyler.
	completionStrategy := GtGQLCompletionStrategy new.
	completionController := GtCompletionController
			on: operationEditor
			strategy: completionStrategy.
	completionController install.
	gqlElement addChild: operationEditor as: #operationEditor.
	gqlElement addChild: (self createLabel: 'Input:').
	inputEditor := self createSourceEditor: #updateInput.
	inputEditor
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryR;
				repeatable: false;
				action: [ :element | self renameInInput ]).
	inputEditor editor styler: JSONParser gtStyler.
	gqlElement addChild: inputEditor as: #inputEditor.
	gqlElement
		addChild: (BrButton new
				margin: (BlInsets top: 3 bottom: 3);
				beSmallSize;
				aptitude: BrGlamorousButtonWithIconAptitude;
				icon: BrGlamorousIcons playinspect asElement;
				label: 'Execute' asString;
				action: [ self executeQuery ])
		as: #executeButton
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

{ #category : #accessing }
GtGQLSnippetElement >> onSnippetViewModelChanged [
	super onSnippetViewModelChanged.
	self setDefaultContextVariable.
	self updateInputEditor.
	self updateOperationEditor.
	self updateContext
]

{ #category : #refactoring }
GtGQLSnippetElement >> operationAst [
	^ self operationSource
		ifNotNil: [ :string | GraphQLParser parseWithErrors: string ]
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
	| gqlAst cursors |
	^ self operationEditor
		ifNotNil: [ :editor | 
			cursors := editor cursors.
			cursors isSingle
				ifTrue: [ gqlAst := self operationAst.
					gqlAst nodeAt: cursors first position ] ]
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
				ifTrue: [ editor editor text: self snippet input asRopedText ] ]
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
