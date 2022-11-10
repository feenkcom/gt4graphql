Class {
	#name : #GtGQLResult,
	#superclass : #GtGQLBasicResult,
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
		priority: 40;
		object: [ self data ];
		view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtResultJsonStringFor: aView [
	<gtView>
	self result ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'JSON String';
		priority: 41;
		object: [ self data ];
		view: #gtJsonStringFor:
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
