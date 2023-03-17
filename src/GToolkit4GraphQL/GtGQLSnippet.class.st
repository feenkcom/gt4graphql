Class {
	#name : #GtGQLSnippet,
	#superclass : #LeSnippet,
	#instVars : [
		'operation',
		'context',
		'input',
		'resultVariableName'
	],
	#category : #'GToolkit4GraphQL-Snippet-Model'
}

{ #category : #'api - accessing menu' }
GtGQLSnippet class >> contextMenuItemSpecification [
	<leSnippetSpecification>
	^ LeContextMenuItemSpecification new
		snippetClass: self;
		title: 'GraphQL'
]

{ #category : #'instance creation' }
GtGQLSnippet class >> empty [
	^ self new
		operation: '';
		input: '';
		context: nil;
		resultVariableName: '';
		yourself
]

{ #category : #'mapping - model' }
GtGQLSnippet class >> leJsonV3AttributeMapping [
	^ super leJsonV3AttributeMapping
		add: #operation -> #operation;
		add: #input -> #input;
		add: #context -> #context;
		add: #resultVariableName -> #resultVariableName;
		yourself
]

{ #category : #'lepiter-store' }
GtGQLSnippet class >> leJsonV3Name [
	^ 'GraphQL'
]

{ #category : #'mapping - model' }
GtGQLSnippet class >> leJsonV4AttributeMapping [
	^ super leJsonV3AttributeMapping
		add: #operation -> #operation;
		add: #input -> #input;
		add: #context -> #context;
		add: #resultVariableName -> #resultVariableName;
		yourself
]

{ #category : #'lepiter-store' }
GtGQLSnippet class >> leJsonV4Name [
	^ 'GraphQL'
]

{ #category : #accessing }
GtGQLSnippet >> asSnippetViewModel [
	^ GtGQLSnippetViewModel new snippetModel: self
]

{ #category : #accessing }
GtGQLSnippet >> contentAsString [
	^ String
		streamContents: [ :stream | 
			stream nextPutAll: 'GraphQL:'.
			stream
				nextPutAll: 'operation=';
				print: (operation ifNil: [ '' ]);
				nextPutAll: '|input=';
				print: (input ifNil: [ '' ]);
				nextPutAll: '|context=';
				print: (context ifNil: [ '' ]) ]
]

{ #category : #accessing }
GtGQLSnippet >> context [
	^ context
]

{ #category : #accessing }
GtGQLSnippet >> context: aString [
	context = aString ifTrue: [ ^ self ].

	context := aString.
	self
		notifyAnnouncement: (GtGQLSnippetContextChanged new
				source: self;
				snippet: self;
				context: aString)
]

{ #category : #accessing }
GtGQLSnippet >> contextUsing: snippetContext [
	| value variableBindings |
	self context = 'self'
		ifTrue: [ value := snippetContext selfObject ]
		ifFalse: [ snippetContext selfObject class allInstVarNames
				detect: [ :each | self isContext: (snippetContext selfObject instVarNamed: each) ]
				ifFound: [ :each | value := snippetContext selfObject instVarNamed: each ]
				ifNone: [ variableBindings := snippetContext sharedBindings.
					(variableBindings hasBindingOf: (self context ifNil: [ '' ]))
						ifTrue: [ value := (variableBindings bindingOf: self context) value ] ] ].
	(self isContext: value) ifFalse: [ value := nil ].
	^ value
]

{ #category : #accessing }
GtGQLSnippet >> contextVariablesUsing: snippetContext [
	| variableBindings variables selfObj |
	snippetContext ifNil: [ ^ #() ].

	variableBindings := snippetContext sharedBindings.
	variables := (self allSnippetVariables
			select: [ :each | 
				(variableBindings hasBindingOf: each asSymbol) not
					or: [ self isContext: (variableBindings bindingOf: each asSymbol) value ] ])
			asOrderedCollection.
	variables sort.
	selfObj := snippetContext selfObject.
	(self isContext: selfObj) ifTrue: [ variables addFirst: 'self' ].
	selfObj class allInstVarNames
		do: [ :each | 
			(self isContext: (selfObj instVarNamed: each))
				ifTrue: [ variables addFirst: each ] ].
	^ variables
]

{ #category : #accessing }
GtGQLSnippet >> defaultContextUsing: snippetContext [
	| obj |
	snippetContext ifNil: [ ^ nil ].
	obj := snippetContext selfObject.
	(self isContext: obj) ifTrue: [ ^ 'self' ].
	obj class allInstVarNames
		do: [ :each | (self isContext: (obj instVarNamed: each)) ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #accessing }
GtGQLSnippet >> input [
	^ input
]

{ #category : #accessing }
GtGQLSnippet >> input: aString [
	input = aString ifTrue: [ ^ self ].

	input := aString.
	self
		notifyAnnouncement: (GtGQLSnippetInputChanged new
				source: self;
				snippet: self;
				input: aString)
]

{ #category : #accessing }
GtGQLSnippet >> isContext: obj [
	^ obj isKindOf: GtGQLContext
]

{ #category : #accessing }
GtGQLSnippet >> operation [
	^ operation
]

{ #category : #accessing }
GtGQLSnippet >> operation: aString [
	operation = aString ifTrue: [ ^ self ].

	operation := aString.
	self
		notifyAnnouncement: (GtGQLSnippetOperationChanged new
				source: self;
				snippet: self;
				operation: aString)
]

{ #category : #accessing }
GtGQLSnippet >> resultVariableName [

	^ resultVariableName
]

{ #category : #accessing }
GtGQLSnippet >> resultVariableName: aString [
	| anOldName |
	resultVariableName = aString ifTrue: [ ^ self ].

	anOldName := resultVariableName.
	resultVariableName := aString.

	self
		notifyAnnouncement: (GtGQLSnippetResultVariableNameChanged new
				source: self;
				snippet: self;
				oldName: anOldName;
				resultVariableName: aString)
]

{ #category : #printing }
GtGQLSnippet >> storeOn: aStream [
	aStream nextPutAll: '(GtGQLSnippet new input: '.
	self input storeOn: aStream.
	aStream nextPutAll: '; operation: '.
	self operation storeOn: aStream.
	aStream nextPutAll: '; yourself)'
]
