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
	| aModel |
	aType ifNil: [ self error: 'Type must be non-nil' ].

	aModel := aType newValueUsing: self.
	aModel context: self context.
	aModel data: aJson.

	self buildModelChildren: aModel.

	^ aModel
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
GtGQLValueBuilder >> newValueListWithType: aType [
	^ GtGQLValueList new type: aType
]

{ #category : #'double dispatch - types' }
GtGQLValueBuilder >> newValueNonNullableWithType: aType [
	| aModel |
	aModel := aType type newValueUsing: self.

	self
		assert: [ aModel type = aType type ]
		description: [ 'Model has incorrect type' ].

	aModel type: aType.

	^ aModel
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
	| aListData anItemType aListType |
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

	self visitGtGQLValueList: aModel
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
GtGQLValueBuilder >> visitNode: aModel [

	aModel acceptVisitor: self
]
