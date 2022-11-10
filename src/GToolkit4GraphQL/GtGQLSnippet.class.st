Class {
	#name : #GtGQLSnippet,
	#superclass : #LeSnippet,
	#instVars : [
		'operation',
		'context',
		'input'
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
		yourself
]

{ #category : #'mapping - model' }
GtGQLSnippet class >> leJsonV3AttributeMapping [
	^ super leJsonV3AttributeMapping
		add: #operation -> #operation;
		add: #input -> #input;
		add: #context -> #context;
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
	context := aString
]

{ #category : #accessing }
GtGQLSnippet >> contextUsing: snippetContext [
	| value variableBindings |
	self context = 'self'
		ifTrue: [ value := snippetContext selfObject ]
		ifFalse: [ variableBindings := snippetContext sharedBindings.
			(variableBindings hasBindingOf: (self context ifNil: [ '' ]))
				ifTrue: [ value := (variableBindings bindingOf: self context) value ] ].
	(value isKindOf: GtGQLContext) ifFalse: [ value := nil ].
	^ value
]

{ #category : #accessing }
GtGQLSnippet >> contextVariablesUsing: snippetContext [
	| variableBindings variables |
	variableBindings := snippetContext sharedBindings.
	variables := (self allSnippetVariables
			select: [ :each | 
				(variableBindings hasBindingOf: each asSymbol) not
					or: [ (variableBindings bindingOf: each asSymbol) value isKindOf: GtGQLContext ] ])
			asOrderedCollection.
	variables sort.
	(snippetContext selfObject isKindOf: GtGQLContext)
		ifTrue: [ variables addFirst: 'self' ].
	^ variables
]

{ #category : #accessing }
GtGQLSnippet >> input [
	^ input
]

{ #category : #accessing }
GtGQLSnippet >> input: aString [
	input := aString
]

{ #category : #accessing }
GtGQLSnippet >> operation [
	^ operation
]

{ #category : #accessing }
GtGQLSnippet >> operation: aString [
	operation := aString.
	self
		notifyAnnouncement: (GtGQLSnippetOperationChanged new
				source: self;
				snippet: self;
				operation: aString)
]
