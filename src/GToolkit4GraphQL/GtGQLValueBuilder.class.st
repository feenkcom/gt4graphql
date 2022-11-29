Class {
	#name : #GtGQLValueBuilder,
	#superclass : #Object,
	#instVars : [
		'context',
		'query',
		'data',
		'rootValue',
		'queryValue'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'api - building' }
GtGQLValueBuilder >> build [
	queryValue := self buildType: self queryType data: self data.
	self skipQueryTypeIfOnlyOneFieldRequested
]

{ #category : #'private - building' }
GtGQLValueBuilder >> buildModelChildren: aModel [

	self visitNode: aModel.
]

{ #category : #'private - building' }
GtGQLValueBuilder >> buildType: aType data: aJson [
	| aValue aNonInterfaceType |
	aNonInterfaceType := self nonInterfaceType: aType data: aJson.
	aValue := aNonInterfaceType newValueUsing: self.
	aValue context: self context.
	aValue data: aJson.
	self buildModelChildren: aValue.
	^ aValue
]

{ #category : #accessing }
GtGQLValueBuilder >> context [
	^ context
]

{ #category : #accessing }
GtGQLValueBuilder >> context: anObject [
	context := anObject
]

{ #category : #accessing }
GtGQLValueBuilder >> data [
	^ data
]

{ #category : #accessing }
GtGQLValueBuilder >> data: anObject [
	data := anObject
]

{ #category : #'gt - extensions' }
GtGQLValueBuilder >> gtRootModelFor: aView [
	<gtView>
	rootValue ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Model';
		priority: 1;
		object: [ self model ];
		view: #gtFieldsFor:
]

{ #category : #'private - model creation' }
GtGQLValueBuilder >> listTypeOfItemType: anItemType [
	| aList |
	aList := GtGQLList new type: anItemType.

	^ self schema
		typeNamed: aList name
		ifPresent: [ :anExistingList | anExistingList ]
		ifAbsentPut: [ aList ]
]

{ #category : #'double dispatch - types' }
GtGQLValueBuilder >> newValueEnumerationWithType: aType [
	^ GtGQLValueEnumeration new type: aType
]

{ #category : #'double dispatch - types' }
GtGQLValueBuilder >> newValueInterfaceWithType: aType [
	^ self newValueObjectWithType: aType
]

{ #category : #'double dispatch - types' }
GtGQLValueBuilder >> newValueListWithType: aType [
	^ GtGQLValueList new type: aType
]

{ #category : #'double dispatch - types' }
GtGQLValueBuilder >> newValueNonNullableWithType: aType [
	| aValue |
	aValue := aType type newValueUsing: self.

	self
		assert: [ aValue type = aType type ]
		description: [ 'Value has incorrect type' ].

	aValue type: aType.

	^ aValue
]

{ #category : #'double dispatch - types' }
GtGQLValueBuilder >> newValueObjectWithType: aType [
	^ (self schema connectionTypes includes: aType)
		ifFalse: [ GtGQLValueObject new type: aType ]
		ifTrue: [ GtGQLValueConnectionList new type: aType ]
]

{ #category : #'double dispatch - types' }
GtGQLValueBuilder >> newValueScalarWithType: aType [
	^ GtGQLValueScalar new type: aType
]

{ #category : #'private - building' }
GtGQLValueBuilder >> nonInterfaceType: aType data: aJson [
	| aNonInterfaceType aSchemaType |
	aType ifNil: [ self error: 'Type must be non-nil' ].

	aNonInterfaceType := aType nonNullableType isInterface
			ifTrue: [ | aTypeName |
				aTypeName := aJson at: '__typename'.
				aTypeName exists
					ifFalse: [ aType ]
					ifTrue: [ self schema typeNamed: aTypeName jsonObject ] ]
			ifFalse: [ aType ].

	aNonInterfaceType ifNil: [ self error: 'Real type must be non-nil' ].

	aSchemaType := (aType isNonNullable
			and: [ aNonInterfaceType isNonNullable not ])
			ifTrue: [ self schema
					typeNamed: aNonInterfaceType name , '!'
					ifPresent: [ :anExistingType | anExistingType ]
					ifAbsentPut: [ GtGQLNonNullable new type: aNonInterfaceType ] ]
			ifFalse: [ aNonInterfaceType ].

	^ aSchemaType
]

{ #category : #accessing }
GtGQLValueBuilder >> query [
	^ query
]

{ #category : #accessing }
GtGQLValueBuilder >> query: anObject [
	query := anObject
]

{ #category : #accessing }
GtGQLValueBuilder >> queryType [
	<return: #GtGQLType>
	^ self schema ifNotNil: #queryType
]

{ #category : #accessing }
GtGQLValueBuilder >> queryValue [
	^ queryValue
]

{ #category : #'api - initialization' }
GtGQLValueBuilder >> result: aResult [
	self context: aResult context.
	self data: aResult data.
	self query: aResult query
]

{ #category : #accessing }
GtGQLValueBuilder >> schema [
	<return: #GtGQLSchema>
	^ self context ifNotNil: #schema
]

{ #category : #'private - building' }
GtGQLValueBuilder >> skipQueryTypeIfOnlyOneFieldRequested [
	queryValue fields size = 1
		ifTrue: [ rootValue := queryValue fields anyOne ]
		ifFalse: [ rootValue := queryValue ]
]

{ #category : #accessing }
GtGQLValueBuilder >> value [
	^ rootValue
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueConnectionObject: aModel [
	| aListData anItemType aListType aTotalCount |
	aListData := GtJsonMap
			forJson: aModel data
			at: #edges
			collect: #node.

	aListData exists
		ifTrue: [ | anEdgesType |
			anEdgesType := (aModel baseType fieldNamed: #edges) type.
			anItemType := (anEdgesType baseType fieldNamed: #node) type ]
		ifFalse: [ aListData := aModel data at: #nodes.
			aListData exists
				ifTrue: [ | aNodesType |
					aNodesType := (aModel baseType fieldNamed: #nodes) type.
					anItemType := aNodesType baseType ]
				ifFalse: [ ^ self ] ].

	aListType := self listTypeOfItemType: anItemType.

	aModel
		listData: aListData;
		listType: aListType;
		itemType: anItemType.

	aTotalCount := aModel data at: #totalCount.
	aTotalCount exists ifTrue: [ aModel totalCount: aTotalCount jsonObject ].

	self visitGtGQLValueList: aModel
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueEnumeration: aModel [
	"nothing to do"

	
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueList: aModel [
	| aType |
	aType := aModel itemType.
	aModel userData
		do: [ :aChildJson | 
			| aChildModel |
			aChildModel := self buildType: aType data: aChildJson.
			aModel addItem: aChildModel ]
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueObject: aModel [
	aModel userType fields
		do: [ :eachField | 
			| aType aJson |
			aType := eachField type.
			aJson := aModel userData at: eachField name.
			self flag: 'FIXIT: we do not handle aliases'.

			aJson exists
				ifTrue: [ aModel atFieldNamed: eachField name put: (self buildType: aType data: aJson) ] ]
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueScalar: aModel [
	"nothing to do"

	
]

{ #category : #visiting }
GtGQLValueBuilder >> visitNode: aType [
	^ aType acceptVisitor: self
]
