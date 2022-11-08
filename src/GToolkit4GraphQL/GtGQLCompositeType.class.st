Class {
	#name : #GtGQLCompositeType,
	#superclass : #GtGQLType,
	#instVars : [
		'fields'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLCompositeType >> addField: aGQLField [
	fields at: aGQLField name put: aGQLField
]

{ #category : #accessing }
GtGQLCompositeType >> fields [
	^ fields
]

{ #category : #accessing }
GtGQLCompositeType >> fields: aCollection [
	fields := aCollection
]

{ #category : #accessing }
GtGQLCompositeType >> gtFieldsFor: aView [
	<gtView>
	^ (GtGQLSchema
		gtTypesFor: aView
		items: [ fields asSortedCollection: [ :a :b | a name < b name ] ])
		title: 'Fields'
]

{ #category : #accessing }
GtGQLCompositeType >> initialize [
	super initialize.
	fields := Dictionary new
]
