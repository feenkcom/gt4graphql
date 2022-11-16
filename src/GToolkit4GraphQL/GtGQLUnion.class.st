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
	^ GtGQLSchema
		gtTypesFor: aView
		items: [ self types asSortedCollection: [ :a :b | a name < b name ] ]
]

{ #category : #'api - introspection' }
GtGQLUnion >> isTypenameIntrospection [
	"It should be possible to add __typename on unions too, but union does not have fields."

	^ false
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
