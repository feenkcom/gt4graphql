Class {
	#name : #GtGQLEnumeration,
	#superclass : #GtGQLType,
	#instVars : [
		'values'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLEnumeration class >> kindName [
	^ 'ENUM'
]

{ #category : #accessing }
GtGQLEnumeration >> fields [
	^ self values
]

{ #category : #accessing }
GtGQLEnumeration >> gtEnumValuesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Values';
		priority: 10;
		items: [ values ifNil: [ #() ] ];
		column: 'Name'
			text: [ :aValue | 
				aValue isDeprecated
					ifTrue: [ aValue name asRopedText
							append: (' (deprecated)' asRopedText
									foreground: BrGlamorousColors disabledButtonTextColor) ]
					ifFalse: [ aValue name ] ];
		column: 'Description'
			text: #description
			weight: 3
]

{ #category : #testing }
GtGQLEnumeration >> isDeprecated [
	^ false
]

{ #category : #accessing }
GtGQLEnumeration >> values [
	^ values
]

{ #category : #accessing }
GtGQLEnumeration >> values: aCollection [
	values := aCollection
]
