Class {
	#name : #GtGQLArgumentTypeReference,
	#superclass : #Object,
	#instVars : [
		'sourceType',
		'sourceField',
		'sourceArgument',
		'targetType'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLArgumentTypeReference >> gtTypeReferencesViewReferencedTypeText [
	| aText aFieldName anArgumentName |
	aText := '' asRopedText.

	aText append: self sourceType name asRopedText.
	aText
		append: (' >> #' asRopedText foreground: BrGlamorousColors disabledButtonTextColor).

	aFieldName := self sourceField name asRopedText bold.

	self sourceField isDeprecated
		ifTrue: [ aFieldName
				lineThroughDo: [ :anAttribute | anAttribute color: BrGlamorousColors errorBackgroundColor ] ].

	aText append: aFieldName.

	aText
		append: ('(' asRopedText foreground: BrGlamorousColors disabledButtonTextColor).
	anArgumentName := self sourceArgument name asRopedText bold.

	self sourceArgument isDeprecated
		ifTrue: [ anArgumentName
				lineThroughDo: [ :anAttribute | anAttribute color: BrGlamorousColors errorBackgroundColor ] ].

	aText append: anArgumentName.

	aText
		append: (': ' asRopedText foreground: BrGlamorousColors disabledButtonTextColor).

	aText
		append: (self sourceArgument type name asRopedText
				foreground: BrGlamorousColors disabledButtonTextColor).

	aText
		append: (')' asRopedText foreground: BrGlamorousColors disabledButtonTextColor).

	^ aText
]

{ #category : #printing }
GtGQLArgumentTypeReference >> printOn: aStream [
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
GtGQLArgumentTypeReference >> printSourceNameOn: aStream [
	self sourceType ifNil: [ ^ self ].
	self sourceField ifNil: [ ^ self ].

	aStream
		nextPutAll: self sourceType name asString;
		space;
		nextPutAll: self sourceField name asString;
		nextPut: $);
		nextPutAll: self sourceArgument name asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> sourceArgument [
	^ sourceArgument
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> sourceArgument: anObject [
	sourceArgument := anObject
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> sourceField [
	^ sourceField
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> sourceField: anObject [
	sourceField := anObject
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> sourceName [
	^ String streamContents: [ :aStream | self printSourceNameOn: aStream ]
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> sourceType [
	^ sourceType
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> sourceType: anObject [
	sourceType := anObject
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> sourceTypeReferences [
	^ self sourceType typeReferences
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> targetType [
	^ targetType
]

{ #category : #accessing }
GtGQLArgumentTypeReference >> targetType: anObject [
	targetType := anObject
]
