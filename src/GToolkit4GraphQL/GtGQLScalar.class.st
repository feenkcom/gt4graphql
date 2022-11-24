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

{ #category : #testing }
GtGQLScalar >> isBoolean [
	^ self name = 'Boolean'
]

{ #category : #testing }
GtGQLScalar >> isPrimitive [
	^ true
]

{ #category : #testing }
GtGQLScalar >> isScalar [
	^ true
]

{ #category : #accessing }
GtGQLScalar >> newResponseModelInstance [
	^ GtGQLResponseScalar new type: self
]
