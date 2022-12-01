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
	^ (GtGQLSchema gtTypesFor: aView items: [ self possibleTypes ])
		title: 'Possible Types';
		priority: 11
]

{ #category : #accessing }
GtGQLUnion >> gtTypesFor: aView [
	<gtView>
	^ GtGQLSchema
		gtTypesFor: aView
		items: [ self types asSortedCollection: [ :a :b | a name < b name ] ]
]

{ #category : #testing }
GtGQLUnion >> isUnion [
	^ true
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
