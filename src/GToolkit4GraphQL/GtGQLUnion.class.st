Class {
	#name : #GtGQLUnion,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLUnion class >> kindName [
	^ 'UNION'
]

{ #category : #'gt - extensions' }
GtGQLUnion >> gtPossibleTypesFor: aView [
	<gtView>
	^ (GtGQLSchema
		gtTypesFor: aView
		items: [ self possibleTypes asSortedCollection: [ :a :b | a name < b name ] ])
		title: 'Possible types';
		priority: 11
]

{ #category : #testing }
GtGQLUnion >> isUnion [
	^ true
]

{ #category : #'api - response' }
GtGQLUnion >> newValueUsing: aBuilder [ 
	^ aBuilder newValueUnionWithType: self
]

{ #category : #accessing }
GtGQLUnion >> possibleTypes [
	^ self types
]

{ #category : #accessing }
GtGQLUnion >> possibleTypes: aCollection [
	self types: aCollection
]

{ #category : #accessing }
GtGQLUnion >> types [
	^ self propertyAt: #possibleTypes ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLUnion >> types: aCollection [
	self propertyAt: #possibleTypes put: aCollection
]
