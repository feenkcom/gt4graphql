Class {
	#name : #GtGQLResult,
	#superclass : #GtGQLBasicResult,
	#traits : 'TGtOptions',
	#classTraits : 'TGtOptions classTrait',
	#instVars : [
		'result'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'gt - extensions' }
GtGQLResult >> data [
	^ self result at: #data
]

{ #category : #'api - results' }
GtGQLResult >> errors [
	<return: #GtJson or: nil>
	self hasErrors ifFalse: [ ^ nil ].

	^ self result at: #errors
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtErrorsFor: aView [
	<gtView>
	self hasErrors ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Errors';
		priority: 15;
		object: [ self errors ];
		view: #gtJsonObjectFor:context:
]

{ #category : #accessing }
GtGQLResult >> gtResponseModelFor: aView [
	<gtView>
	^ aView forward
		title: 'Model';
		priority: 50;
		object: [ GtGQLResponseModelBuilder new
				result: self;
				build;
				model ];
		view: #gtFieldsFor:
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtResultJsonObjectFor: aView context: aContext [
	<gtView>
	self result ifNil: [ ^ aView empty ].

	aContext at: #gtTreeExpansionLevel ifAbsentPut: [ 3 ].
	
	^ aView forward
		title: 'JSON Object';
		priority: 21;
		object: [ self data ];
		view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtResultJsonStringFor: aView [
	<gtView>
	self result ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'JSON String';
		priority: 20;
		object: [ self data ];
		view: #gtJsonStringFor:
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtResultSchemaFor: aView [
	<gtView>
	self hasResultSchema ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Schema';
		priority: 10;
		object: [ self resultSchema ];
		view: #gtTypesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Schema'
			tooltip: 'Inspect schema'
			action: [ :aButton | 
				self resultSchema
					ifNotNil: [ :theSchema | aButton phlow spawnObject: theSchema ] ]
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtResultTypeFor: aView [
	<gtView>
	self hasResultType ifFalse: [ ^ aView empty ].

	^ (GtGQLSchema gtTypesFor: aView items: [ {self resultType} ])
		expandUpTo: 1;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Type'
			tooltip: 'Inspect type'
			action: [ :aButton | self resultType ifNotNil: [ :aType | aButton phlow spawnObject: aType ] ]
]

{ #category : #testing }
GtGQLResult >> hasErrors [
	^ self result isNotNil and: [ (self result at: #errors) exists ]
]

{ #category : #'api - results' }
GtGQLResult >> hasResultSchema [
	^ self result isNotNil and: [ (self data at: #__schema) exists ]
]

{ #category : #'api - results' }
GtGQLResult >> hasResultType [
	^ self result isNotNil and: [ (self data at: #__type) exists ]
]

{ #category : #testing }
GtGQLResult >> isSuccess [
	^ true
]

{ #category : #accessing }
GtGQLResult >> paginator [
	self assertContext.
	^ GtGQLPaginatorStream new result: self
]

{ #category : #accessing }
GtGQLResult >> result [
	^ result
]

{ #category : #accessing }
GtGQLResult >> result: anObject [
	result := anObject
]

{ #category : #'api - results' }
GtGQLResult >> resultSchema [
	<return: #GtGQLSchema or: nil>
	self hasResultSchema ifFalse: [ ^ nil ].

	^ self
		optionAt: #resultSchema
		ifAbsentPut: [ GtGQLIntrospectionSchemaBuilder new
				context: self context;
				json: self result;
				build ]
]

{ #category : #'api - results' }
GtGQLResult >> resultType [
	<return: #GtGQLType or: nil>
	self hasResultType ifFalse: [ ^ nil ].

	^ self
		optionAt: #resultType
		ifAbsentPut: [ GtGQLIntrospectionSchemaBuilder new
				context: self context;
				json: self result;
				buildType ]
]
