Class {
	#name : #GtGQLPathStep,
	#superclass : #Object,
	#instVars : [
		'alias',
		'name',
		'ast'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLPathStep >> alias [
	^ alias
]

{ #category : #accessing }
GtGQLPathStep >> alias: anObject [
	alias := anObject
]

{ #category : #accessing }
GtGQLPathStep >> ast [
	^ ast
]

{ #category : #accessing }
GtGQLPathStep >> ast: anObject [
	ast := anObject
]

{ #category : #convenience }
GtGQLPathStep >> fieldName [
	"Return step name used in a schema structure (type field name)."

	<return: #String>
	^ self name ifNil: [ '?' ]
]

{ #category : #convenience }
GtGQLPathStep >> fullName [
	"Return alias and name."

	<return: #String>
	^ String
		streamContents: [ :aStream | 
			self alias
				ifNotNil: [ :anAlias | 
					aStream
						nextPutAll: anAlias asString;
						nextPutAll: ': ' ].
			aStream nextPutAll: self fieldName ]
]

{ #category : #accessing }
GtGQLPathStep >> gtAstExploreFor: aView [
	<gtView>
	self ast ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'AST';
		priority: 1;
		object: [ self ast ];
		view: #gtExploreFor:
]

{ #category : #accessing }
GtGQLPathStep >> name [
	^ name
]

{ #category : #accessing }
GtGQLPathStep >> name: anObject [
	name := anObject
]

{ #category : #printing }
GtGQLPathStep >> printOn: aStream [
	super printOn: aStream.

	aStream nextPut: $(.
	
	self alias
		ifNotNil: [ :anAlias | 
			aStream
				nextPutAll: anAlias asString;
				nextPutAll: ': ' ].

	aStream
		nextPutAll: self fieldName;
		nextPut: $)
]

{ #category : #convenience }
GtGQLPathStep >> resultName [
	"Return step name used in a result JSON structure."

	<return: #String>
	^ self alias ifNil: [ self fieldName ]
]
