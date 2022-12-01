Class {
	#name : #GtGQLTypeReference,
	#superclass : #Object,
	#instVars : [
		'sourceType',
		'sourceField',
		'targetType'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #'gt - extensions' }
GtGQLTypeReference >> gtTypeReferencesViewReferencedTypeText [
	| aText |
	aText := '' asRopedText.

	aText append: self sourceType name asRopedText.
	aText
		append: (' >> #' asRopedText foreground: BrGlamorousColors disabledButtonTextColor).
	aText append: self sourceField name asRopedText bold.

	^ aText
]

{ #category : #printing }
GtGQLTypeReference >> printOn: aStream [
	super printOn: aStream.

	self sourceType ifNil: [ ^ self ].
	self sourceField ifNil: [ ^ self ].
	self targetType ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self sourceType name asString;
		nextPutAll: ' ';
		nextPutAll: self sourceField name asString;
		nextPutAll: ': ';
		nextPutAll: self targetType name asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLTypeReference >> sourceField [
	^ sourceField
]

{ #category : #accessing }
GtGQLTypeReference >> sourceField: anObject [
	sourceField := anObject
]

{ #category : #accessing }
GtGQLTypeReference >> sourceType [
	^ sourceType
]

{ #category : #accessing }
GtGQLTypeReference >> sourceType: anObject [
	sourceType := anObject
]

{ #category : #accessing }
GtGQLTypeReference >> targetType [
	^ targetType
]

{ #category : #accessing }
GtGQLTypeReference >> targetType: anObject [
	targetType := anObject
]
