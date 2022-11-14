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
GtGQLCompletionStrategy >> completionStreamForNode: aNode startingWith: prefix [
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
