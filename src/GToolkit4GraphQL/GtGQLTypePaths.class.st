Class {
	#name : #GtGQLTypePaths,
	#superclass : #Object,
	#traits : 'TGtGroup',
	#classTraits : 'TGtGroup classTrait',
	#instVars : [
		'paths'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLTypePaths >> items [
	^ self paths
]

{ #category : #accessing }
GtGQLTypePaths >> paths [
	^ paths
]

{ #category : #accessing }
GtGQLTypePaths >> paths: anObject [
	paths := anObject
]
