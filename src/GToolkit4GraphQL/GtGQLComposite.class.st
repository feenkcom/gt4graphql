Class {
	#name : #GtGQLComposite,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #testing }
GtGQLComposite class >> isAbstract [
	^ self name = #GtGQLComposite
]

{ #category : #'api - initialization' }
GtGQLComposite >> addField: aGQLField [
	aGQLField parentType: self.

	self
		propertyAt: self propertyFieldName
		ifPresent: [ :aDict | aDict at: aGQLField name put: aGQLField ]
		ifAbsentPut: [ Dictionary new
				at: aGQLField name put: aGQLField;
				yourself ]
]

{ #category : #accessing }
GtGQLComposite >> fieldNamed: aName [
	^ self fields at: aName ifAbsent: [ nil ]
]

{ #category : #accessing }
GtGQLComposite >> fields [
	^ self propertyAt: self propertyFieldName ifAbsentPut: [ Dictionary new ]
]

{ #category : #'api - initialization' }
GtGQLComposite >> fields: aCollection [
	aCollection do: [ :eachField | self addField: eachField ]
]

{ #category : #accessing }
GtGQLComposite >> gtFieldsFor: aView [
	<gtView>
	^ (GtGQLSchema
		gtTypesFor: aView
		items: [ self fields
				asSortedCollection: [ :a :b | (a name ifNil: [ '?' ]) < (b name ifNil: [ '?' ]) ] ])
		title: 'Fields'
]

{ #category : #'gt - extensions' }
GtGQLComposite >> gtSearchFieldTypesFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 20;
		title: 'Field Types';
		items: [ self fields asArray asAsyncStream
				collect: [ :eachField | eachField type ifNotNil: #baseType ] ];
		itemName: #name;
		filterBySubstring: #name;
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #'gt - extensions' }
GtGQLComposite >> gtSearchFieldsFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 10;
		title: 'Fields';
		items: [ self fields asArray asAsyncStream ];
		itemName: #name;
		filter: (GtSpotterSubstringFilter new itemString: #name);
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #accessing }
GtGQLComposite >> initialize [
	super initialize.
	self fields
]

{ #category : #testing }
GtGQLComposite >> isComposite [
	^ true
]

{ #category : #'api - initialization' }
GtGQLComposite >> propertyFieldName [
	^ #fields
]
