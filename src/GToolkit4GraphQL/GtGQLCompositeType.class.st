Class {
	#name : #GtGQLCompositeType,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #testing }
GtGQLCompositeType class >> isAbstract [
	^ self name = #GtGQLCompositeType
]

{ #category : #accessing }
GtGQLCompositeType >> addField: aGQLField [
	self
		propertyAt: #fields
		ifPresent: [ :aDict | aDict at: aGQLField name put: aGQLField ]
		ifAbsentPut: [ Dictionary new
				at: aGQLField name put: aGQLField;
				yourself ]
]

{ #category : #accessing }
GtGQLCompositeType >> fields [
	^ self propertyAt: #fields ifAbsent: [ Dictionary new ]
]

{ #category : #accessing }
GtGQLCompositeType >> fields: aCollection [
	self propertyAt: #fields put: aCollection
]

{ #category : #accessing }
GtGQLCompositeType >> gtFieldsFor: aView [
	<gtView>
	^ (GtGQLSchema
		gtTypesFor: aView
		items: [ self fields
				asSortedCollection: [ :a :b | (a name ifNil: [ '?' ]) < (b name ifNil: [ '?' ]) ] ])
		title: 'Fields'
]

{ #category : #testing }
GtGQLCompositeType >> isComposite [
	^ true
]
