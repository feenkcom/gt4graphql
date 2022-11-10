Class {
	#name : #GtGQLCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#instVars : [
		'schema'
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
GtGQLCompletionStrategy >> completionStreamForNode: node startingWith: prefix [
	| parents type operation index nameNode |
	parents := node allParents reversed.
	((node isKindOf: GraphQLFieldNode)
		and: [ parents size >= 2
				and: [ (operation := parents second) isKindOf: GraphQLOperationDefinitionNode ] ])
		ifFalse: [ ^ #() asAsyncStream ].
	type := (operation type isNil or: [ operation type source = 'query' ])
			ifTrue: [ self schema queryType ]
			ifFalse: [ operation type source = 'mutation' ifTrue: [ self schema mutationType ] ].
	index := 3.
	[ type notNil and: [ index <= parents size ] ]
		whileTrue: [ nameNode := parents at: index.
			(nameNode isKindOf: GraphQLFieldNode)
				ifTrue: [ type fields
						detect: [ :each | each name = nameNode name source ]
						ifFound: [ :field | type := field type baseType ]
						ifNone: [ ^ #() asAsyncStream ] ].
			index := index + 1 ].
	type ifNil: [ ^ #() asAsyncStream ].
	^ (type fields asArray asAsyncStream
		select: [ :each | each name beginsWith: prefix ]) collect: #name
]

{ #category : #testing }
GtGQLCompletionStrategy >> isSeparatorCharacter: aCharacter [
	^ aCharacter isLetter not
]

{ #category : #accessing }
GtGQLCompletionStrategy >> schema [
	^ schema ifNil: [ schema := GtGQLSchema new ]
]

{ #category : #accessing }
GtGQLCompletionStrategy >> schema: aGQLSchema [
	schema := aGQLSchema
]
