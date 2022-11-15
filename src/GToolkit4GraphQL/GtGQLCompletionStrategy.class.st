Class {
	#name : #GtGQLCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#instVars : [
		'schema',
		'typeNames'
	],
	#category : #'GToolkit4GraphQL-Completer'
}

{ #category : #accessing }
GtGQLCompletionStrategy >> completionActionStreamFor: aText at: positionInteger [
	| prefix ast node |
	prefix := self completionPrefixAt: positionInteger in: aText.
	(prefix isNil
		or: [ prefix size < self minimumPrefixLength
				or: [ (self hasCompletionEntryFor: prefix) not ] ])
		ifTrue: [ ^ #() asAsyncStream ].
	ast := GraphQLParser parseWithErrors: aText asString.
	node := ast nodeAt: positionInteger.
	^ (self completionStreamForNode: node startingWith: prefix)
		collect: [ :each | 
			GtInsertTextCompletionAction
				labeled: (self labelFor: each withSearch: prefix)
				completion: (each allButFirst: prefix size)
				position: positionInteger ]
]

{ #category : #accessing }
GtGQLCompletionStrategy >> completionStreamForErrorNode: aNode startingWith: prefix [
	(prefix = '$' and: [ aNode parent isKindOf: GraphQLArgumentNode ])
		ifTrue: [ ^ self completionStreamForVariable: aNode startingWith: prefix ].
	^ (aNode parent isKindOf: GraphQLFieldNode)
		ifTrue: [ (aNode parent arguments identityIncludes: aNode)
				ifTrue: [ (aNode parent fieldIn: self schema)
						ifNotNil: [ :field | 
							(field arguments asOrderedCollection asAsyncStream
								select: [ :each | each name beginsWith: prefix ])
								collect: [ :each | each name , ':' ] ] ] ]
]

{ #category : #accessing }
GtGQLCompletionStrategy >> completionStreamForNode: aNode startingWith: prefix [
	(aNode isKindOf: GraphQLNamedTypeNode)
		ifTrue: [ ^ self typeNames asyncStreamStartingWith: prefix ].
	aNode isErrorNode
		ifTrue: [ (self completionStreamForErrorNode: aNode startingWith: prefix)
				ifNotNil: [ :stream | ^ stream ] ].
	(aNode isKindOf: GraphQLVariableNode)
		ifTrue: [ (self completionStreamForVariable: aNode startingWith: prefix)
				ifNotNil: [ :stream | ^ stream ] ].
	^ ((aNode parentOfType: GraphQLFieldNode)
		ifNil: [ aNode isPartOfQuery
				ifTrue: [ self schema queryType ]
				ifFalse: [ aNode isPartOfMutation ifTrue: [ self schema mutationType ] ] ]
		ifNotNil: [ :node | node typeIn: self schema ])
		ifNil: [ #() asAsyncStream ]
		ifNotNil: [ :type | 
			(type fields asArray asAsyncStream
				select: [ :each | each name beginsWith: prefix ]) collect: #name ]
]

{ #category : #accessing }
GtGQLCompletionStrategy >> completionStreamForVariable: aNode startingWith: prefix [
	(aNode parent isKindOf: GraphQLVariableDefinitionNode) ifTrue: [ ^ nil ].
	^ (aNode parentOfType: GraphQLOperationDefinitionNode)
		ifNotNil: [ :operation | 
			(operation variableDefinitions asAsyncStream
				select: [ :each | each isErrorNode not and: [ each variable source beginsWith: prefix ] ])
				collect: [ :each | each variable source ] ]
]

{ #category : #testing }
GtGQLCompletionStrategy >> isSeparatorCharacter: aCharacter [
	^ (aCharacter isLetter
		or: [ aCharacter isDigit or: [ '_$' includes: aCharacter ] ]) not
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
