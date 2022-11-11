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
	| aSchema |
	self hasSchema ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Schema';
		priority: 10;
		object: [ aSchema := GtGQLIntrospectionSchemaBuilder new
					configuration: self configuration;
					json: self result;
					build ];
		view: #gtTypesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Schema'
			tooltip: 'Inspect schema'
			action: [ :aButton | aSchema ifNotNil: [ :theSchema | aButton phlow spawnObject: theSchema ] ]
]

{ #category : #'api - results' }
GtGQLResult >> hasSchema [
	^ self result isNotNil and: [ (self data at: #__schema) exists ]
]

{ #category : #testing }
GtGQLResult >> isSuccess [
	^ true
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
				configuration: self configuration;
				json: self result;
				build ]
]
