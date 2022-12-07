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

	aText
		append: ((': ' , self targetType name) asRopedText
				foreground: BrGlamorousColors disabledButtonTextColor).

	^ aText
]

{ #category : #printing }
GtGQLTypeReference >> printOn: aStream [
	super printOn: aStream.

	self sourceType ifNil: [ ^ self ].
	self sourceField ifNil: [ ^ self ].
	self targetType ifNil: [ ^ self ].

	aStream nextPut: $(.
	self printSourceNameOn: aStream.
	aStream
		nextPutAll: ': ';
		nextPutAll: self targetType name asString;
		nextPut: $)
]

{ #category : #printing }
GtGQLTypeReference >> printSourceNameOn: aStream [
	self sourceType ifNil: [ ^ self ].
	self sourceField ifNil: [ ^ self ].

	aStream
		nextPutAll: self sourceType name asString;
		nextPutAll: ' ';
		nextPutAll: self sourceField name asString
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
GtGQLTypeReference >> sourceName [
	^ String streamContents: [ :aStream | self printSourceNameOn: aStream ]
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
GtGQLTypeReference >> sourceTypeReferences [
	^ self sourceType typeReferences
]

{ #category : #accessing }
GtGQLTypeReference >> targetType [
	^ targetType
]

{ #category : #accessing }
GtGQLTypeReference >> targetType: anObject [
	targetType := anObject
]
