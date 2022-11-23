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
	aModel acceptVisitor: self
]

{ #category : #'private - building' }
GtGQLResponseModelBuilder >> buildType: aType data: aJson [
	| aModel |
	aType ifNil: [ self error: 'Type must be non-nil' ].

	aModel := aType newResponseModelInstance.
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

{ #category : #accessing }
GtGQLResponseModelBuilder >> model [
	^ rootModel
]

{ #category : #'private - model creation' }
GtGQLResponseModelBuilder >> newRootModel [
	^ GtGQLResponseToRemove new
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
GtGQLResponseModelBuilder >> visitGtGQLResponseList: aModel [
	| aType |
	aType := aModel itemType.
	aModel data
		do: [ :aChildJson | 
			| aChildModel |
			aChildModel := self buildType: aType data: aChildJson.
			aModel addItem: aChildModel ]
]

{ #category : #visiting }
GtGQLResponseModelBuilder >> visitGtGQLResponseObject: aModel [
	aModel baseType fields
		do: [ :eachField | 
			| aType aJson |
			aType := eachField type.
			aJson := aModel data at: eachField name.
			self flag: 'FIXIT: we do not handle aliases'.

			aJson exists
				ifTrue: [ aModel atFieldNamed: eachField name put: (self buildType: aType data: aJson) ] ]
]

{ #category : #visiting }
GtGQLResponseModelBuilder >> visitGtGQLResponseScalar: aModel [
	"nothing to do"

	
]
