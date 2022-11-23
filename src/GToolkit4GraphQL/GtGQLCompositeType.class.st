Class {
	#name : #GtGQLCompositeType,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #testing }
GtGQLCompositeType class >> isAbstract [
	^ self name = #GtGQLCompositeType
]

{ #category : #'api - initialization' }
GtGQLCompositeType >> addField: aGQLField [
	self
		propertyAt: self propertyFieldName
		ifPresent: [ :aDict | aDict at: aGQLField name put: aGQLField ]
		ifAbsentPut: [ Dictionary new
				at: aGQLField name put: aGQLField;
				yourself ]
]

{ #category : #accessing }
GtGQLCompositeType >> fieldNamed: aName [
	^ self fields at: aName ifAbsent: [ nil ]
]

{ #category : #accessing }
GtGQLCompositeType >> fields [
	^ self propertyAt: self propertyFieldName ifAbsentPut: [ Dictionary new ]
]

{ #category : #'api - initialization' }
GtGQLCompositeType >> fields: aCollection [
	aCollection do: [ :eachField | self addField: eachField ]
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

{ #category : #'gt - extensions' }
GtGQLCompositeType >> gtSearchFieldTypesFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 20;
		title: 'Field Types';
		items: [ self fields asArray asAsyncStream
				collect: [ :eachField | eachField type ifNotNil: #baseType ] ];
		itemName: #name;
		filter: (GtSpotterSubstringFilter new itemString: #name);
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #'gt - extensions' }
GtGQLCompositeType >> gtSearchFieldsFor: aSearch [
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
GtGQLCompositeType >> initialize [
	super initialize.
	self fields
]

{ #category : #testing }
GtGQLCompositeType >> isComposite [
	^ true
]

{ #category : #'api - initialization' }
GtGQLCompositeType >> propertyFieldName [
	^ #fields
]
