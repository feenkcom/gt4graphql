Class {
	#name : #GtGQLUnion,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLUnion class >> kindName [
	^ 'UNION'
]

{ #category : #accessing }
GtGQLUnion >> gtTypesFor: aView [
	<gtView>
	^ GtGQLSchema gtTypesFor: aView items: [ self types ]
]

{ #category : #accessing }
GtGQLUnion >> possibleTypes: aCollection [
	self types: aCollection
]

{ #category : #accessing }
GtGQLUnion >> types [
	^ self propertyAt: #types ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLUnion >> types: aCollection [
	self propertyAt: #types put: aCollection
]
