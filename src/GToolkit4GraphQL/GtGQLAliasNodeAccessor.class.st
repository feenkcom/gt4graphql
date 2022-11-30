Class {
	#name : #GtGQLAliasNodeAccessor,
	#superclass : #GtGQLNodeAccessor,
	#instVars : [
		'aliasName'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLAliasNodeAccessor >> aliasName [
	^ aliasName
]

{ #category : #accessing }
GtGQLAliasNodeAccessor >> aliasName: anObject [
	aliasName := anObject
]

{ #category : #'api - testing' }
GtGQLAliasNodeAccessor >> isFieldNode: aNode [
	<return: #Boolean>
	^ aNode alias
		ifNotNil: [ :aToken | aToken source = self aliasName ]
		ifNil: [ (aNode name ifNotNil: #source) = self aliasName ]
]

{ #category : #printing }
GtGQLAliasNodeAccessor >> printOn: aStream [
	super printOn: aStream.

	self aliasName ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self aliasName asString;
		nextPut: $)
]
