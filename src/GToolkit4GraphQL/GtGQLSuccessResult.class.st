Class {
	#name : #GtGQLSuccessResult,
	#superclass : #GtGQLResult,
	#traits : 'TGtOptions',
	#classTraits : 'TGtOptions classTrait',
	#instVars : [
		'result',
		'value'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'gt - extensions' }
GtGQLSuccessResult >> data [
	^ self result at: #data
]

{ #category : #'api - results' }
GtGQLSuccessResult >> errors [
	<return: #GtJson or: nil>
	self hasErrors ifFalse: [ ^ nil ].

	^ self result at: #errors
]

{ #category : #'gt - extensions' }
GtGQLSuccessResult >> gtErrorsFor: aView [
	<gtView>
	self hasErrors ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Errors';
		priority: 15;
		object: [ self errors ];
		view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtGQLSuccessResult >> gtResultJsonObjectFor: aView context: aContext [
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
GtGQLSuccessResult >> gtResultJsonStringFor: aView [
	<gtView>
	self result ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'JSON String';
		priority: 20;
		object: [ self data ];
		view: #gtJsonStringFor:
]

{ #category : #'gt - extensions' }
GtGQLSuccessResult >> gtResultSchemaFor: aView [
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
GtGQLSuccessResult >> gtResultTypeFor: aView [
	<gtView>
	self hasResultType ifFalse: [ ^ aView empty ].

	^ (GtGQLSchema gtTypesFor: aView items: [ {self resultType} ])
		expandUpTo: 1;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Type'
			tooltip: 'Inspect type'
			action: [ :aButton | self resultType ifNotNil: [ :aType | aButton phlow spawnObject: aType ] ]
]

{ #category : #accessing }
GtGQLSuccessResult >> gtValueFor: aView [
	<gtView>
	^ aView forward
		title: 'Value';
		priority: 50;
		object: [ self value ];
		view: #gtFieldsFor:
]

{ #category : #testing }
GtGQLSuccessResult >> hasErrors [
	^ self result isNotNil and: [ (self result at: #errors) exists ]
]

{ #category : #'api - results' }
GtGQLSuccessResult >> hasResultSchema [
	^ self result isNotNil and: [ (self data at: #__schema) exists ]
]

{ #category : #'api - results' }
GtGQLSuccessResult >> hasResultType [
	^ self result isNotNil and: [ (self data at: #__type) exists ]
]

{ #category : #testing }
GtGQLSuccessResult >> isSuccess [
	^ true
]

{ #category : #accessing }
GtGQLSuccessResult >> paginator [
	self assertContext.
	^ GtGQLPaginatorStream new result: self
]

{ #category : #accessing }
GtGQLSuccessResult >> report [
	^ self context reportClass new result: self
]

{ #category : #accessing }
GtGQLSuccessResult >> result [
	^ result
]

{ #category : #accessing }
GtGQLSuccessResult >> result: anObject [
	result := anObject
]

{ #category : #'api - results' }
GtGQLSuccessResult >> resultSchema [
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
GtGQLSuccessResult >> resultType [
	<return: #GtGQLType or: nil>
	self hasResultType ifFalse: [ ^ nil ].

	^ self
		optionAt: #resultType
		ifAbsentPut: [ GtGQLIntrospectionSchemaBuilder new
				context: self context;
				json: self result;
				buildType ]
]

{ #category : #accessing }
GtGQLSuccessResult >> value [
	^ value
		ifNil: [ value := GtGQLValueBuilder new
					result: self;
					build;
					value ]
]
