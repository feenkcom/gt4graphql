Class {
	#name : #GtGQLEnumeration,
	#superclass : #GtGQLType,
	#instVars : [
		'values'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLEnumeration >> gtEnumValuesFor: aView [
	<gtView>
	^ aView list
		title: 'Values';
		priority: 10;
		items: [ values ]
]

{ #category : #accessing }
GtGQLEnumeration >> values [
	^ values
]

{ #category : #accessing }
GtGQLEnumeration >> values: aCollection [
	values := aCollection
]
