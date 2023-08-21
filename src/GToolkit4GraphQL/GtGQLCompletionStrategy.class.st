Class {
	#name : #GtGQLCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#instVars : [
		'schema',
		'typeNames',
		'minLength'
	],
	#category : #'GToolkit4GraphQL-Completer'
}

{ #category : #completing }
GtGQLCompletionStrategy >> completeArgument: aStream [
	^ aStream collect: [ :each | each name , ':' ]
]

{ #category : #completing }
GtGQLCompletionStrategy >> completeField: aStream [
	^ aStream
		collect: [ :each | 
			| name |
			name := each name.
			(each arguments anySatisfy: [ :arg | arg isRequired ])
				ifTrue: [ name := name , ' () {}' ]
				ifFalse: [ each type isPrimitive ifFalse: [ name := name , ' {}' ] ].
			name ]
]

{ #category : #completing }
GtGQLCompletionStrategy >> completeFieldOfType: aType andNode: aNode startingWith: prefix [
	| fragmentNames fieldNames |
	fragmentNames := Array
			streamContents: [ :aStream | 
				aStream nextPut: '...on _ { }'.
				aNode topParent
					allNodesOfType: GraphQLFragmentDefinitionNode
					do: [ :eachNode | 
						(eachNode name isNotNil and: [ eachNode name source isNotEmpty ])
							ifTrue: [ aStream nextPut: '...' , eachNode name source asString ] ] ].

	fragmentNames := fragmentNames asAsyncStream
			select: [ :each | self isString: each prefixedBy: prefix ].

	fieldNames := self
			completeField: (aType fields asArray asAsyncStream
					select: [ :each | self isString: each name prefixedBy: prefix ]).	"^ fragmentNames asAsyncStream merge: fieldNames asAsyncStream"
	^ fieldNames asAsyncStream merge: fragmentNames asAsyncStream
]

{ #category : #completing }
GtGQLCompletionStrategy >> completionActionStreamFor: aText at: positionInteger requested: aBoolean [
	| prefix ast node |
	prefix := self completionPrefixAt: positionInteger in: aText.
	(prefix isNil
		or: [ prefix size < self minimumPrefixLength
				or: [ (self hasCompletionEntryFor: prefix) not ] ])
		ifTrue: [ ^ #() asAsyncStream ].
	ast := GraphQLParser parseWithErrors: aText asString.
	node := ast nodeAt: positionInteger.
	^ (self
		completionStreamForNode: node
		startingWith: prefix
		at: positionInteger)
		collect: [ :each | 
			| label completion |
			completion := each allButFirst: prefix size.
			label := self labelFor: each withSearch: prefix.
			(each endsWith: '{}')
				ifTrue: [ | fromPosition newPosition |
					fromPosition := positionInteger - label size + completion size + 1.
					newPosition := fromPosition + label size - 2.
					(each endsWith: '() {}') ifTrue: [ newPosition := newPosition - 3 ].
					GtInsertTextAndPositionCursorCompletionAction
						labeled: label
						completion: completion
						position: positionInteger
						from: fromPosition
						newPosition: newPosition ]
				ifFalse: [ GtInsertTextCompletionAction
						labeled: label
						completion: completion
						position: positionInteger ] ]
]

{ #category : #completing }
GtGQLCompletionStrategy >> completionStreamForErrorNode: aNode startingWith: prefix [
	(prefix = '$' and: [ aNode parent isKindOf: GraphQLArgumentNode ])
		ifTrue: [ ^ self completionStreamForVariable: aNode startingWith: prefix ].

	(aNode parent isKindOf: GraphQLFieldNode)
		ifTrue: [ (aNode parent arguments identityIncludes: aNode)
				ifTrue: [ (aNode parent fieldIn: self schema)
						ifNotNil: [ :field | 
							^ self
								completeArgument: (field arguments asOrderedCollection asAsyncStream
										select: [ :each | each name beginsWith: prefix ]) ] ] ].

	(aNode parent isKindOf: GraphQLDocumentNode)
		ifTrue: [ ^ self documentFieldNames asAsyncStream
				select: [ :each | each beginsWith: prefix ] ].

	(aNode parent isKindOf: GraphQLFragmentDefinitionNode)
		ifTrue: [ (aNode parent selections identityIncludes: aNode)
				ifTrue: [ (aNode parent typeIn: self schema)
						ifNotNil: [ :type | 
							^ self
								completeFieldOfType: type
								andNode: aNode
								startingWith: prefix ] ] ].

	^ nil
]

{ #category : #completing }
GtGQLCompletionStrategy >> completionStreamForNode: aNode startingWith: prefix at: positionInteger [
	(aNode isKindOf: GraphQLNamedTypeNode)
		ifTrue: [ ^ self typeNames asyncStreamStartingWith: prefix ].

	aNode isErrorNode
		ifTrue: [ (self completionStreamForErrorNode: aNode startingWith: prefix)
				ifNotNil: [ :stream | ^ stream ] ].

	(aNode isKindOf: GraphQLVariableNode)
		ifTrue: [ (self completionStreamForVariable: aNode startingWith: prefix)
				ifNotNil: [ :stream | ^ stream ] ].

	prefix isEmpty
		ifTrue: [ ((aNode isKindOf: GraphQLFieldNode)
				or: [ (aNode isKindOf: GraphQLOperationDefinitionNode)
						or: [ (aNode isKindOf: GraphQLFragmentDefinitionNode)
								or: [ aNode isKindOf: GraphQLInlineFragmentNode ] ] ])
				ifTrue: [ (positionInteger
						between: aNode leftBrace startPosition
						and: aNode rightBrace stopPosition)
						ifTrue: [ (aNode typeIn: self schema)
								ifNotNil: [ :type | 
									^ self
										completeFieldOfType: type
										andNode: aNode
										startingWith: prefix ] ] ].

			(aNode isKindOf: GraphQLFieldNode)
				ifTrue: [ (positionInteger
						between: aNode leftParen startPosition
						and: aNode rightParen stopPosition)
						ifTrue: [ ^ (aNode fieldIn: self schema)
								ifNotNil: [ :field | self completeArgument: field arguments asArray asAsyncStream ] ] ] ].

	(aNode isKindOf: GraphQLFieldNode)
		ifTrue: [ | aParent aType |
			aParent := aNode
					parentOfType: {GraphQLFieldNode.
							GraphQLInlineFragmentNode.
							GraphQLFragmentDefinitionNode.
							GraphQLOperationDefinitionNode}.
			aParent ifNotNil: [ aType := aParent typeIn: self schema ].
			aType ifNil: [ ^ #() asAsyncStream ].
			^ self
				completeFieldOfType: aType
				andNode: aNode
				startingWith: prefix ].

	^ ((aNode parentOfType: GraphQLFieldNode)
		ifNil: [ aNode isPartOfQuery
				ifTrue: [ self schema queryType ]
				ifFalse: [ aNode isPartOfMutation ifTrue: [ self schema mutationType ] ] ]
		ifNotNil: [ :node | node typeIn: self schema ])
		ifNil: [ #() asAsyncStream ]
		ifNotNil: [ :type | 
			self
				completeFieldOfType: type
				andNode: aNode
				startingWith: prefix ]
]

{ #category : #completing }
GtGQLCompletionStrategy >> completionStreamForVariable: aNode startingWith: prefix [
	(aNode parent isKindOf: GraphQLVariableDefinitionNode) ifTrue: [ ^ nil ].
	^ (aNode parentOfType: GraphQLOperationDefinitionNode)
		ifNotNil: [ :operation | 
			(operation variableDefinitions asAsyncStream
				select: [ :each | each isErrorNode not and: [ each variable source beginsWith: prefix ] ])
				collect: [ :each | each variable source ] ]
]

{ #category : #completing }
GtGQLCompletionStrategy >> documentFieldNames [
	^ #('query { }' 'mutation { }' 'fragment _ on { }')
]

{ #category : #initialization }
GtGQLCompletionStrategy >> initialize [
	super initialize.
	minLength := 1
]

{ #category : #testing }
GtGQLCompletionStrategy >> isSeparatorCharacter: aCharacter [
	^ (aCharacter isLetter
		or: [ aCharacter isDigit or: [ '_$.' includes: aCharacter ] ]) not
]

{ #category : #private }
GtGQLCompletionStrategy >> isString: aString prefixedBy: prefix [
	prefix ifNil: [ ^ true ].
	prefix ifEmpty: [ ^ true ].
	^ aString beginsWith: prefix
]

{ #category : #accessing }
GtGQLCompletionStrategy >> minimumPrefixLength [
	^ minLength
]

{ #category : #accessing }
GtGQLCompletionStrategy >> schema [
	^ schema ifNil: [ schema := GtGQLSchema new ]
]

{ #category : #accessing }
GtGQLCompletionStrategy >> schema: aGQLSchema [
	aGQLSchema ~~ schema
		ifTrue: [ schema := aGQLSchema.
			typeNames := nil ]
]

{ #category : #accessing }
GtGQLCompletionStrategy >> typeNames [
	typeNames
		ifNil: [ typeNames := GtPrefixTree new.
			self schema types
				do: [ :each | each isList ifFalse: [ typeNames add: each name ] ] ].
	^ typeNames
]
