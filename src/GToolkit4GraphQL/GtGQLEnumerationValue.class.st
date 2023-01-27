Class {
	#name : #GtGQLEnumerationValue,
	#superclass : #GtGQLModel,
	#instVars : [
		'parentType'
	],
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
GtGQLEnumerationValue >> gtParentTypeFor: aView [
	<gtView>
	self parentType ifNil: [ ^ aView empty ].
	(self parentType baseType isKindOf: GtGQLEnumeration) ifFalse: [ ^ aView empty ].

	^ (GtGQLSchema gtTypesFor: aView items: [ {self parentType baseType} ])
		title: 'Parent Type';
		priority: 40;
		expandUpTo: 1;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Parent Type'
			tooltip: 'Inspect parent type'
			action: [ :aButton | aButton phlow spawnObject: self parentType baseType ]
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

{ #category : #'gt - extensions' }
GtGQLEnumerationValue >> parentType [
	^ parentType
]

{ #category : #accessing }
GtGQLEnumerationValue >> parentType: aType [
	self
		assert: [ parentType isNil ]
		description: [ 'Parent type can be set only once' ].
	self assert: [ aType isNotNil ] description: [ 'Parent type must be non-nil' ].

	parentType := aType
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
