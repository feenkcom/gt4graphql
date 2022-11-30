Class {
	#name : #GtGQLNameNodeAccessor,
	#superclass : #GtGQLNodeAccessor,
	#instVars : [
		'fieldName'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLNameNodeAccessor >> fieldName [
	^ fieldName
]

{ #category : #accessing }
GtGQLNameNodeAccessor >> fieldName: anObject [
	fieldName := anObject
]

{ #category : #'api - testing' }
GtGQLNameNodeAccessor >> isFieldNode: aNode [
	<return: #Boolean>
	^ (aNode name ifNotNil: #source) = self fieldName
]

{ #category : #printing }
GtGQLNameNodeAccessor >> printOn: aStream [
	super printOn: aStream.

	self fieldName ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self fieldName asString;
		nextPut: $)
]
