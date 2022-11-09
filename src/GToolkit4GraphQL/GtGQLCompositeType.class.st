Class {
	#name : #GtGQLCompositeType,
	#superclass : #GtGQLType,
	#instVars : [
		'fields'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #testing }
GtGQLCompositeType class >> isAbstract [
	^ self name = #GtGQLCompositeType
]

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
	^ aView columnedList
		title: 'Fields';
		column: 'Name' text: [ :each | each name ];
		column: 'Type' text: [ :each | each type name ];
		items: [ fields asSortedCollection: [ :a :b | a name < b name ] ]
]

{ #category : #accessing }
GtGQLCompositeType >> initialize [
	super initialize.
	fields := Dictionary new
]
