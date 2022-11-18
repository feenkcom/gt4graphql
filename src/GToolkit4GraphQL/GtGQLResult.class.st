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
GtGQLResult >> gtSchemaFor: aView [
	<gtView>
	self hasSchema ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Schema';
		priority: 10;
		object: [ self schema ];
		view: #gtTypesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Schema'
			tooltip: 'Inspect schema'
			action: [ :aButton | self schema ifNotNil: [ :theSchema | aButton phlow spawnObject: theSchema ] ]
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtTypeFor: aView [
	<gtView>
	self hasType ifFalse: [ ^ aView empty ].

	^ (GtGQLSchema gtTypesFor: aView items: [ {self type} ])
		expandUpTo: 1;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Type'
			tooltip: 'Inspect type'
			action: [ :aButton | self type ifNotNil: [ :aType | aButton phlow spawnObject: aType ] ]
]

{ #category : #testing }
GtGQLResult >> hasErrors [
	^ self result isNotNil and: [ (self result at: #errors) exists ]
]

{ #category : #'api - results' }
GtGQLResult >> hasSchema [
	^ self result isNotNil and: [ (self data at: #__schema) exists ]
]

{ #category : #'api - results' }
GtGQLResult >> hasType [
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
GtGQLResult >> schema [
	<return: #GtGQLSchema or: nil>
	self hasSchema ifFalse: [ ^ nil ].

	^ self
		optionAt: #schema
		ifAbsentPut: [ GtGQLIntrospectionSchemaBuilder new
				context: self context;
				json: self result;
				build ]
]

{ #category : #'api - results' }
GtGQLResult >> type [
	<return: #GtGQLType or: nil>
	self hasType ifFalse: [ ^ nil ].

	^ self
		optionAt: #type
		ifAbsentPut: [ GtGQLIntrospectionSchemaBuilder new
				context: self context;
				json: self result;
				buildType ]
]
