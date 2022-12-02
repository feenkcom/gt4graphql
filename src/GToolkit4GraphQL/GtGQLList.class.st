Class {
	#name : #GtGQLList,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLList class >> kindName [
	^ 'LIST'
]

{ #category : #accessing }
GtGQLList >> baseType [
	^ self type ifNotNil: #baseType
]

{ #category : #'api - paths' }
GtGQLList >> defaultVariableValue [
	^ Array with: self type defaultVariableValue
]

{ #category : #testing }
GtGQLList >> isList [
	^ true
]

{ #category : #testing }
GtGQLList >> isPrimitive [
	^ self baseType isPrimitive
]

{ #category : #accessing }
GtGQLList >> name [
	^ '[' , (self type ifNotNil: #name ifNil: [ '?' ]) , ']'
]

{ #category : #'api - response' }
GtGQLList >> newValueUsing: aBuilder [
	^ aBuilder newValueListWithType: self
]

{ #category : #'api - response' }
GtGQLList >> responseItemType [
	^ self type
]

{ #category : #accessing }
GtGQLList >> type [
	^ self propertyAt: #type
]

{ #category : #accessing }
GtGQLList >> type: aGQLType [
	self propertyAt: #type put: aGQLType
]
