Class {
	#name : #GtGQLEnumerationValue,
	#superclass : #GtGQLModel,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLEnumerationValue >> baseType [
	^ self
]

{ #category : #accessing }
GtGQLEnumerationValue >> deprecationReason [
	^ self propertyAt: #deprecationReason
]

{ #category : #accessing }
GtGQLEnumerationValue >> deprecationReason: anObject [
	self propertyAt: #deprecationReason put: anObject
]

{ #category : #accessing }
GtGQLEnumerationValue >> description [
	^ self propertyAt: #description
]

{ #category : #accessing }
GtGQLEnumerationValue >> description: anObject [
	self propertyAt: #description put: anObject
]

{ #category : #accessing }
GtGQLEnumerationValue >> fields [
	^ #()
]

{ #category : #'gt - extensions' }
GtGQLEnumerationValue >> gtDescriptionFor: aView [
	<gtView>
	self description ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Description';
		priority: 40;
		stencil: [ LeCoderTextElement coderElementFor: (self description ifNil: [ '' ]) ]
]

{ #category : #'gt - extensions' }
GtGQLEnumerationValue >> gtTypesNameText [
	^ self name
]

{ #category : #accessing }
GtGQLEnumerationValue >> isDeprecated [
	^ self propertyAt: #isDeprecated ifAbsent: [ false ]
]

{ #category : #accessing }
GtGQLEnumerationValue >> isDeprecated: anObject [
	self propertyAt: #isDeprecated put: anObject
]

{ #category : #accessing }
GtGQLEnumerationValue >> name [
	^ self propertyAt: #name
]

{ #category : #accessing }
GtGQLEnumerationValue >> name: anObject [
	self propertyAt: #name put: anObject
]

{ #category : #printing }
GtGQLEnumerationValue >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLEnumerationValue >> typeName [
	^ self class name asString allButFirst: 5
]
