Class {
	#name : #GtGQLResponseModelBuilder,
	#superclass : #Object,
	#instVars : [
		'result',
		'rootModel'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'api - building' }
GtGQLResponseModelBuilder >> build [
	rootModel := self buildType: self queryType data: self data
]

{ #category : #'private - building' }
GtGQLResponseModelBuilder >> buildModelChildren: aModel [

	self visitNode: aModel.
]

{ #category : #'private - building' }
GtGQLResponseModelBuilder >> buildType: aType data: aJson [
	| aModel |
	aType ifNil: [ self error: 'Type must be non-nil' ].

	aModel := aType newResponseModelInstanceUsing: self.
	aModel context: self context.
	aModel data: aJson.

	self buildModelChildren: aModel.

	^ aModel
]

{ #category : #accessing }
GtGQLResponseModelBuilder >> context [
	<return: #GtGQLContext>
	^ self result ifNotNil: #context
]

{ #category : #accessing }
GtGQLResponseModelBuilder >> data [
	<return: #GtJson>
	^ self result ifNotNil: #data
]

{ #category : #'gt - extensions' }
GtGQLResponseModelBuilder >> gtRootModelFor: aView [
	<gtView>
	rootModel ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Model';
		priority: 1;
		object: [ self model ];
		view: #gtFieldsFor:
]

{ #category : #'private - model creation' }
GtGQLResponseModelBuilder >> listTypeOfItemType: anItemType [
	| aList |
	aList := GtGQLList new type: anItemType.

	^ self schema
		typeNamed: aList name
		ifPresent: [ :anExistingList | anExistingList ]
		ifAbsentPut: [ aList ]
]

{ #category : #accessing }
GtGQLResponseModelBuilder >> model [
	^ rootModel
]

{ #category : #'double dispatch - types' }
GtGQLResponseModelBuilder >> newResponseModelListInstanceWithType: aType [
	^ GtGQLResponseList new type: aType
]

{ #category : #'double dispatch - types' }
GtGQLResponseModelBuilder >> newResponseModelNonNullableInstanceWithType: aType [
	| aModel |
	aModel := aType type newResponseModelInstanceUsing: self.

	self
		assert: [ aModel type = aType type ]
		description: [ 'Model has incorrect type' ].

	aModel type: aType.

	^ aModel
]

{ #category : #'double dispatch - types' }
GtGQLResponseModelBuilder >> newResponseModelObjectInstanceWithType: aType [
	^ (self schema connectionTypes includes: aType)
		ifFalse: [ GtGQLResponseObject new type: aType ]
		ifTrue: [ GtGQLResponseConnectionList new type: aType ]
]

{ #category : #'double dispatch - types' }
GtGQLResponseModelBuilder >> newResponseScalarModelInstanceWithType: aType [
	^ GtGQLResponseScalar new type: aType
]

{ #category : #accessing }
GtGQLResponseModelBuilder >> query [
	<return: #GtGQLQuery>
	^ self result ifNotNil: #query
]

{ #category : #accessing }
GtGQLResponseModelBuilder >> queryType [
	<return: #GtGQLType>
	^ self schema ifNotNil: #queryType
]

{ #category : #accessing }
GtGQLResponseModelBuilder >> result [
	^ result
]

{ #category : #accessing }
GtGQLResponseModelBuilder >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtGQLResponseModelBuilder >> schema [
	<return: #GtGQLSchema>
	^ self result ifNotNil: #schema
]

{ #category : #visiting }
GtGQLResponseModelBuilder >> visitGtGQLResponseConnectionObject: aModel [
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
				ifFalse: [ self error: 'What should we do?' ] ].

	aListType := self listTypeOfItemType: anItemType.

	aModel
		listData: aListData;
		listType: aListType;
		itemType: anItemType.

	self visitGtGQLResponseList: aModel
]

{ #category : #visiting }
GtGQLResponseModelBuilder >> visitGtGQLResponseList: aModel [
	| aType |
	aType := aModel itemType.
	aModel userData
		do: [ :aChildJson | 
			| aChildModel |
			aChildModel := self buildType: aType data: aChildJson.
			aModel addItem: aChildModel ]
]

{ #category : #visiting }
GtGQLResponseModelBuilder >> visitGtGQLResponseObject: aModel [
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
GtGQLResponseModelBuilder >> visitGtGQLResponseScalar: aModel [
	"nothing to do"

	
]

{ #category : #visiting }
GtGQLResponseModelBuilder >> visitNode: aModel [

	aModel acceptVisitor: self
]
