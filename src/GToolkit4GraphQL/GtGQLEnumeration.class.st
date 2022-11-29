Class {
	#name : #GtGQLEnumeration,
	#superclass : #GtGQLType,
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
		items: [ self values ifNil: [ #() ] ];
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
GtGQLEnumeration >> isPrimitive [
	^ true
]

{ #category : #'api - response' }
GtGQLEnumeration >> newValueUsing: aBuilder [
	^ aBuilder newValueEnumerationWithType: self
]

{ #category : #accessing }
GtGQLEnumeration >> values [
	^ self propertyAt: #values ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLEnumeration >> values: aCollection [
	self propertyAt: #values put: aCollection
]
