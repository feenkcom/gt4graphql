Class {
	#name : #GtGQLInputObjectType,
	#superclass : #GtGQLCompositeType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInputObjectType class >> kindName [
	^ 'INPUT_OBJECT'
]

{ #category : #accessing }
GtGQLInputObjectType >> defaultValue [
	^ self propertyAt: #defaultValue
]

{ #category : #accessing }
GtGQLInputObjectType >> defaultValue: anObject [
	self propertyAt: #defaultValue put: anObject
]

{ #category : #accessing }
GtGQLInputObjectType >> deprecationReason [
	^ self propertyAt: #deprecationReason
]

{ #category : #accessing }
GtGQLInputObjectType >> deprecationReason: anObject [
	self propertyAt: #deprecationReason put: anObject
]

{ #category : #accessing }
GtGQLInputObjectType >> fields [
	^ self inputFields
]

{ #category : #'gt - extensions' }
GtGQLInputObjectType >> gtTypesNameText [
	| aText |
	aText := self name asRopedText.

	self isRequired
		ifTrue: [ aText
				append: '!' asRopedText;
				bold ].
	self isDeprecated
		ifTrue: [ aText
				lineThroughDo: [ :anAttribute |  ];
				italic ].

	^ aText
]

{ #category : #accessing }
GtGQLInputObjectType >> inputFields [
	^ self propertyAt: #inputFields ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLInputObjectType >> inputFields: aCollection [
	self propertyAt: #inputFields put: aCollection
]

{ #category : #accessing }
GtGQLInputObjectType >> isDeprecated [
	^ self propertyAt: #isDeprecated ifAbsent: [ false ]
]

{ #category : #accessing }
GtGQLInputObjectType >> isDeprecated: anObject [
	self propertyAt: #isDeprecated put: anObject
]

{ #category : #testing }
GtGQLInputObjectType >> isRequired [
	^ self type ifNotNil: #isRequired ifNil: [ false ]
]

{ #category : #accessing }
GtGQLInputObjectType >> type [
	^ self propertyAt: #type
]

{ #category : #accessing }
GtGQLInputObjectType >> type: anObject [
	self propertyAt: #type put: anObject
]
