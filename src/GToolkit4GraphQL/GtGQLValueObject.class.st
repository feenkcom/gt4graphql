Class {
	#name : #GtGQLValueObject,
	#superclass : #GtGQLValue,
	#instVars : [
		'fields'
	],
	#category : #'GToolkit4GraphQL-Report'
}

{ #category : #visiting }
GtGQLValueObject >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLValueObject: self
]

{ #category : #'api - initialization' }
GtGQLValueObject >> atFieldNamed: aName put: aModel [
	self
		assert: [ (fields includesKey: aName) not ]
		description: [ 'Cannot add twice a same field value' ].

	aModel parent: self.

	fields at: aName put: aModel
]

{ #category : #'reflective operations' }
GtGQLValueObject >> doesNotUnderstand: message [
	"Overwritten so that 'self foo' becomes 'self at: #foo' except that self is returned"

	| key |
	key := message selector.
	(key isUnary and: [ fields includesKey: key ])
		ifTrue: [ ^ self fieldNamed: key ].
	^ super doesNotUnderstand: message
]

{ #category : #accessing }
GtGQLValueObject >> fieldNamed: aName [
	^ self fieldNamed: aName ifAbsent: [ nil ]
]

{ #category : #accessing }
GtGQLValueObject >> fieldNamed: aName ifAbsent: anAbsentBlock [
	^ fields at: aName ifAbsent: anAbsentBlock
]

{ #category : #accessing }
GtGQLValueObject >> fieldNamed: aName ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ fields
		at: aName
		ifPresent: aPresentBlock
		ifAbsent: anAbsentBlock
]

{ #category : #accessing }
GtGQLValueObject >> fields [
	^ fields
]

{ #category : #'gt - extensions' }
GtGQLValueObject >> gtFieldsFor: aView [
	<gtView>
	fields ifNil: [ ^ aView empty ].

	^ self class gtFieldsFor: aView items: [ fields associations ]
]

{ #category : #'gt - extensions' }
GtGQLValueObject >> gtFieldsViewChildren [
	^ fields associations
]

{ #category : #'gt - extensions' }
GtGQLValueObject >> gtFieldsViewValueText [
	^ self type name
]

{ #category : #accessing }
GtGQLValueObject >> id [
	^ self
		fieldNamed: #id
		ifPresent: #value
		ifAbsent: [ nil ]
]

{ #category : #initialization }
GtGQLValueObject >> initialize [
	super initialize.
	fields := OrderedDictionary new
]

{ #category : #testing }
GtGQLValueObject >> isValueObject [
	^ true
]

{ #category : #accessing }
GtGQLValueObject >> magritteDescription [
	| basicDescription |
	basicDescription := GtGQLMagritteBuilder for: self.

	^ basicDescription
]

{ #category : #accessing }
GtGQLValueObject >> magritteNullDescription [
	<magritteDescription>
	^ nil
]

{ #category : #printing }
GtGQLValueObject >> printOn: aStream [
	super printOn: aStream.

	self type ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self type name asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLValueObject >> userData [
	"Return data that is meaningful to users"

	^ self data
]

{ #category : #accessing }
GtGQLValueObject >> userType [
	"Return type that is meaningful to users"

	^ self baseType
]
