Class {
	#name : #GtGQLCompositeType,
	#superclass : #GtGQLType,
	#instVars : [
		'fields'
	],
	#category : #'GToolkit4GraphQL-Schema'
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
	^ (GtGQLSchema
		gtTypesFor: aView
		items: [ fields
				asSortedCollection: [ :a :b | (a name ifNil: [ '?' ]) < (b name ifNil: [ '?' ]) ] ])
		title: 'Fields'
]

{ #category : #accessing }
GtGQLCompositeType >> initialize [
	super initialize.
	fields := Dictionary new
]

{ #category : #testing }
GtGQLCompositeType >> isComposite [
	^ true
]
