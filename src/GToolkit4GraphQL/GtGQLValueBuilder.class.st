Class {
	#name : #GtGQLValueBuilder,
	#superclass : #Object,
	#instVars : [
		'context',
		'query',
		'data',
		'queryValue',
		'value',
		'dataPath'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'api - building' }
GtGQLValueBuilder >> build [
	dataPath
		ifNil: [ self buildStartingAtQuery ]
		ifNotNil: [ self buildStartingAtDataPath ]
]

{ #category : #'private - building' }
GtGQLValueBuilder >> buildModelChildren: aModel [

	self visitNode: aModel.
]

{ #category : #'private - building' }
GtGQLValueBuilder >> buildStartingAtDataPath [
	| aCurrentStep aCurrentType |
	aCurrentStep := self operationStep.
	aCurrentType := self operationType.

	dataPath
		do: [ :anAlias | 
			aCurrentStep := aCurrentStep newStepForResultName: anAlias.
			aCurrentType := (aCurrentType baseType fieldNamed: aCurrentStep fieldName) type ].

	value := self
			buildType: aCurrentType
			data: self data
			step: aCurrentStep
]

{ #category : #'private - building' }
GtGQLValueBuilder >> buildStartingAtQuery [
	queryValue := self
			buildType: self operationType
			data: self data
			step: self operationStep.
	self skipQueryTypeIfOnlyOneFieldRequested
]

{ #category : #'private - building' }
GtGQLValueBuilder >> buildType: aType data: aJson step: aStep [
	| aValue aNonInterfaceType |
	aNonInterfaceType := self nonInterfaceType: aType data: aJson.
	
	aValue := aNonInterfaceType newValueUsing: self.
	aValue context: self context.
	aValue data: aJson.
	aValue step: aStep.
	
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

{ #category : #accessing }
GtGQLValueBuilder >> dataPath [
	^ dataPath
]

{ #category : #accessing }
GtGQLValueBuilder >> dataPath: anObject [
	dataPath := anObject
]

{ #category : #'gt - extensions' }
GtGQLValueBuilder >> gtRootModelFor: aView [
	<gtView>
	value ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Value';
		priority: 1;
		object: [ self value ];
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

{ #category : #accessing }
GtGQLValueBuilder >> mutationType [
	<return: #GtGQLType>
	^ self schema ifNotNil: #mutationType
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

{ #category : #'double dispatch - types' }
GtGQLValueBuilder >> newValueUnionWithType: aType [
	^ GtGQLValueUnion new type: aType
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

{ #category : #'private - model creation' }
GtGQLValueBuilder >> operationNode [
	| aDocumentNode |
	aDocumentNode := self query graphqlNode.
	aDocumentNode
		allNodesOfType: GraphQLOperationDefinitionNode
		do: [ :aNode | (aNode isPartOfQuery or: [ aNode isPartOfMutation ]) ifTrue: [ ^ aNode ] ].

	self error: 'An operation definition node must exist'
]

{ #category : #'private - building' }
GtGQLValueBuilder >> operationStep [
	| aNode |
	^ GtGQLValueStep new
		ast: (aNode := self operationNode);
		name: (aNode type ifNotNil: #source)
]

{ #category : #'private - building' }
GtGQLValueBuilder >> operationType [
	self query isQueryOperation ifTrue: [ ^ self queryType ].
	self query isMutationOperation ifTrue: [ ^ self mutationType ].

	^ nil
]

{ #category : #'private - model creation' }
GtGQLValueBuilder >> prepareGtGQLValueConnectionObject: aValue withEdges: aListStep [
	"Return true if there edge items exists, false otherwise"

	<return: #Boolean>
	| aNodeStep aListData anEdgesType anItemType anItemStep aListType |
	aNodeStep := aListStep newStepForResultName: #node.

	aNodeStep ifNil: [ ^ false ].

	aListData := GtJsonMap
			forJson: aValue data
			at: aListStep resultName
			collect: aNodeStep resultName asSymbol.

	aListData exists ifFalse: [ ^ false ].

	anEdgesType := (aValue baseType fieldNamed: aListStep fieldName) type.
	anItemType := (anEdgesType baseType fieldNamed: aNodeStep fieldName) type.
	anItemStep := aNodeStep.

	aListType := self listTypeOfItemType: anItemType.

	aValue
		listData: aListData;
		listType: aListType;
		itemType: anItemType;
		listStep: aListStep;
		itemStep: anItemStep.

	^ true
]

{ #category : #'private - model creation' }
GtGQLValueBuilder >> prepareGtGQLValueConnectionObject: aValue withNodes: aListStep [
	"Return true if there edge items exists, false otherwise"

	<return: #Boolean>
	| aListData aNodesType anItemType aListType |
	aListData := aValue data at: aListStep resultName.

	aListData exists ifFalse: [ ^ false ].

	aNodesType := (aValue baseType fieldNamed: aListStep fieldName) type.
	anItemType := aNodesType baseType.

	aListType := self listTypeOfItemType: anItemType.

	aValue
		listData: aListData;
		listType: aListType;
		itemType: anItemType;
		listStep: aListStep;
		itemStep: aListStep.

	^ true
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
		ifTrue: [ value := queryValue fields anyOne ]
		ifFalse: [ value := queryValue ]
]

{ #category : #accessing }
GtGQLValueBuilder >> value [
	^ value
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueConnectionObject: aValue [
	| aTotalCount aListStep aTotalCountStep hasData |
	aTotalCountStep := aValue step newStepForFieldName: #totalCount.
	aTotalCountStep
		ifNotNil: [ aTotalCount := aValue data at: aTotalCountStep resultName.
			aTotalCount exists ifTrue: [ aValue totalCount: aTotalCount jsonObject ] ].

	hasData := false.

	aListStep := aValue step newStepForFieldName: #edges.
	aListStep
		ifNotNil: [ hasData := self prepareGtGQLValueConnectionObject: aValue withEdges: aListStep ]
		ifNil: [ aListStep := aValue step newStepForFieldName: #nodes.
			aListStep
				ifNotNil: [ hasData := self prepareGtGQLValueConnectionObject: aValue withNodes: aListStep ]
				ifNil: [ aValue listData: (GtJson forJsonObject: #()) ] ].

	hasData ifFalse: [ ^ self ].
	self visitGtGQLValueList: aValue
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueEnumeration: aModel [
	"nothing to do"

	
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueList: aValue [
	| aType anItemStep |
	aValue userData jsonObject ifNil: [ ^ self ].
	aType := aValue itemType.
	anItemStep := aValue itemStep.

	aValue userData
		do: [ :aChildJson :anIndex | 
			| aChildModel |
			aChildModel := self
					buildType: aType
					data: aChildJson
					step: anItemStep.
			aValue addItem: aChildModel ]
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueObject: aValue [
	aValue userData jsonObject ifNil: [ ^ self ].

	aValue userData
		do: [ :aJson :anAlias | 
			| aStep aField aType |
			aStep := aValue step newStepForResultName: anAlias.
			aField := aValue userType fieldNamed: aStep fieldName.

			self
				assert: [ aField isNotNil ]
				description: [ 'Schema type {1} is missing field named {1}'
						format: {aValue userType name.
								aStep fieldName} ].

			aType := aField type.

			aField isMetaField
				ifFalse: [ aValue
						atFieldNamed: aStep resultName
						put: (self
								buildType: aType
								data: aJson
								step: aStep) ] ]
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueScalar: aModel [
	"nothing to do"

	
]

{ #category : #visiting }
GtGQLValueBuilder >> visitGtGQLValueUnion: aValue [
	| anActualType anActualModel |
	aValue data jsonObject ifNil: [ ^ self ].
	anActualType := aValue data
			at: '__typename'
			ifPresent: [ :aJson | self schema typeNamed: aJson jsonObject ]
			ifAbsent: [ ^ self ].

	anActualModel := self
			buildType: anActualType
			data: aValue data
			step: aValue step.
	aValue actualItem: anActualModel
]

{ #category : #visiting }
GtGQLValueBuilder >> visitNode: aType [
	^ aType acceptVisitor: self
]
