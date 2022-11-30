Class {
	#name : #GtGQLInputObject,
	#superclass : #GtGQLComposite,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInputObject class >> kindName [
	^ 'INPUT_OBJECT'
]

{ #category : #accessing }
GtGQLInputObject >> defaultValue [
	^ self propertyAt: #defaultValue
]

{ #category : #accessing }
GtGQLInputObject >> defaultValue: anObject [
	self propertyAt: #defaultValue put: anObject
]

{ #category : #accessing }
GtGQLInputObject >> deprecationReason [
	^ self propertyAt: #deprecationReason
]

{ #category : #accessing }
GtGQLInputObject >> deprecationReason: anObject [
	self propertyAt: #deprecationReason put: anObject
]

{ #category : #'gt - extensions' }
GtGQLInputObject >> gtRepricationReasonFor: aView [
	<gtView>
	self isDeprecated ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Deprecation Reason';
		priority: 50;
		stencil: [ LeCoderTextElement coderElementFor: (self deprecationReason ifNil: [ '' ]) ]
]

{ #category : #'api - initialization' }
GtGQLInputObject >> gtTypeFor: aView [
	<gtView>
	self type ifNil: [ ^ aView empty ].

	^ (GtGQLSchema gtTypesFor: aView items: [ {self type baseType} ])
		title: 'Type';
		expandUpTo: 1
]

{ #category : #'gt - extensions' }
GtGQLInputObject >> gtTypesNameText [
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
GtGQLInputObject >> inputFields [
	^ self fields
]

{ #category : #accessing }
GtGQLInputObject >> inputFields: aCollection [
	self fields: aCollection
]

{ #category : #accessing }
GtGQLInputObject >> isDeprecated [
	^ self propertyAt: #isDeprecated ifAbsent: [ false ]
]

{ #category : #accessing }
GtGQLInputObject >> isDeprecated: anObject [
	self propertyAt: #isDeprecated put: anObject
]

{ #category : #testing }
GtGQLInputObject >> isRequired [
	^ self type ifNotNil: #isRequired ifNil: [ false ]
]

{ #category : #printing }
GtGQLInputObject >> printTypeOn: aStream [
	self type
		ifNotNil: [ :aType | 
			aStream
				nextPutAll: ': ';
				nextPutAll: aType name asString ]
]

{ #category : #accessing }
GtGQLInputObject >> propertyFieldName [
	^ #inputFields
]

{ #category : #accessing }
GtGQLInputObject >> type [
	^ self propertyAt: #type
]

{ #category : #accessing }
GtGQLInputObject >> type: anObject [
	self propertyAt: #type put: anObject
]
