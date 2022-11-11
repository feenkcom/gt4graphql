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
	operationEditor editor styler: GraphQLParser gtStyler.
	completionStrategy := GtGQLCompletionStrategy new.
	completionController := GtCompletionController
			on: operationEditor
			strategy: completionStrategy.
	completionController install.
	gqlElement addChild: operationEditor as: #operationEditor.
	gqlElement addChild: (self createLabel: 'Input:').
	inputEditor := self createSourceEditor: #updateInput.
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

{ #category : #accessing }
GtGQLSnippetElement >> onSnippetViewModelChanged [
	super onSnippetViewModelChanged.
	self setDefaultContextVariable.
	self updateInputEditor.
	self updateOperationEditor.
	self updateContext
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
	gqlElement
		childNamed: #operationEditor
		ifFound: [ :editor | 
			| searchString |
			searchString := editor editor text asString.
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
