Class {
	#name : #GtGQLNonNullable,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLNonNullable class >> kindName [
	^ 'NON_NULL'
]

{ #category : #accessing }
GtGQLNonNullable >> baseType [
	^ self type ifNotNil: #baseType
]

{ #category : #'api - paths' }
GtGQLNonNullable >> defaultVariableValue [
	^ self type defaultVariableValue
]

{ #category : #'gt - extensions' }
GtGQLNonNullable >> gtTypeFor: aView [
	<gtView>
	^ (GtGQLSchema gtTypesFor: aView items: [ {self type} ])
		title: 'Type';
		expandUpTo: 1
]

{ #category : #testing }
GtGQLNonNullable >> isNonNullable [
	^ true
]

{ #category : #testing }
GtGQLNonNullable >> isPrimitive [
	^ self baseType isPrimitive
]

{ #category : #accessing }
GtGQLNonNullable >> isRequired [
	^ true
]

{ #category : #accessing }
GtGQLNonNullable >> name [
	^ (self type ifNotNil: #name ifNil: [ '?' ]) , '!'
]

{ #category : #'api - response' }
GtGQLNonNullable >> newValueUsing: aBuilder [
	^ aBuilder newValueNonNullableWithType: self
]

{ #category : #accessing }
GtGQLNonNullable >> nonNullableType [
	<return: #GtGQLType>
	^ self type nonNullableType
]

{ #category : #'api - response' }
GtGQLNonNullable >> responseItemType [
	^ self type responseItemType
]

{ #category : #accessing }
GtGQLNonNullable >> type [
	^ self propertyAt: #type
]

{ #category : #accessing }
GtGQLNonNullable >> type: aGQLType [
	self propertyAt: #type put: aGQLType
]
