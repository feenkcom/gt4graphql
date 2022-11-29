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

{ #category : #'gt - extensions' }
GtGQLInputObjectType >> gtRepricationReasonFor: aView [
	<gtView>
	self isDeprecated ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Deprecation Reason';
		priority: 50;
		stencil: [ LeCoderTextElement coderElementFor: (self deprecationReason ifNil: [ '' ]) ]
]

{ #category : #'api - initialization' }
GtGQLInputObjectType >> gtTypeFor: aView [
	<gtView>
	self type ifNil: [ ^ aView empty ].

	^ (GtGQLSchema gtTypesFor: aView items: [ {self type baseType} ])
		title: 'Type';
		expandUpTo: 1
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
	^ self fields
]

{ #category : #accessing }
GtGQLInputObjectType >> inputFields: aCollection [
	self fields: aCollection
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

{ #category : #printing }
GtGQLInputObjectType >> printTypeOn: aStream [
	self type
		ifNotNil: [ :aType | 
			aStream
				nextPutAll: ': ';
				nextPutAll: aType name asString ]
]

{ #category : #accessing }
GtGQLInputObjectType >> propertyFieldName [
	^ #inputFields
]

{ #category : #accessing }
GtGQLInputObjectType >> type [
	^ self propertyAt: #type
]

{ #category : #accessing }
GtGQLInputObjectType >> type: anObject [
	self propertyAt: #type put: anObject
]
