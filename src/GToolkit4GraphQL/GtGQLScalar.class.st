Class {
	#name : #GtGQLScalar,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLScalar class >> boolean [
	^ self new
		name: 'Boolean';
		yourself
]

{ #category : #accessing }
GtGQLScalar class >> float [
	^ self new
		name: 'Float';
		yourself
]

{ #category : #accessing }
GtGQLScalar class >> id [
	^ self new
		name: 'ID';
		yourself
]

{ #category : #accessing }
GtGQLScalar class >> int [
	^ self new
		name: 'Int';
		yourself
]

{ #category : #accessing }
GtGQLScalar class >> kindName [
	^ 'SCALAR'
]

{ #category : #accessing }
GtGQLScalar class >> string [
	^ self new
		name: 'String';
		yourself
]

{ #category : #'api - paths' }
GtGQLScalar >> defaultVariableValue [
	self isStringType ifTrue: [ ^ '' ].
	self isIntType ifTrue: [ ^ 0 ].
	self isFloatType ifTrue: [ ^ 0.0 ].
	self isBooleanType ifTrue: [ ^ false ].
	self isIdType ifTrue: [ ^ 'id' ].

	^ ''
]

{ #category : #testing }
GtGQLScalar >> isBooleanType [
	^ self name = 'Boolean'
]

{ #category : #testing }
GtGQLScalar >> isCommonScalarType [
	^ self isBooleanType
		or: [ self isFloatType
				or: [ self isIntType or: [ self isStringType or: [ self isIdType ] ] ] ]
]

{ #category : #testing }
GtGQLScalar >> isFloatType [
	^ self name = 'Float'
]

{ #category : #testing }
GtGQLScalar >> isIdType [
	^ self name = 'ID'
]

{ #category : #testing }
GtGQLScalar >> isIntType [
	^ self name = 'Int'
]

{ #category : #testing }
GtGQLScalar >> isPrimitive [
	^ true
]

{ #category : #testing }
GtGQLScalar >> isScalar [
	^ true
]

{ #category : #testing }
GtGQLScalar >> isStringType [
	^ self name = 'String'
]

{ #category : #'api - response' }
GtGQLScalar >> newValueUsing: aBuilder [
	^ aBuilder newValueScalarWithType: self
]
