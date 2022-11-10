Class {
	#name : #GtGQLStringClient,
	#superclass : #Object,
	#traits : 'TGtGQLClient',
	#classTraits : 'TGtGQLClient classTrait',
	#instVars : [
		'string'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'api - communication' }
GtGQLStringClient >> introspectionSchema [
	<return: #String>
	^ self string
]

{ #category : #accessing }
GtGQLStringClient >> string [

	^ string
]

{ #category : #accessing }
GtGQLStringClient >> string: anObject [

	string := anObject
]
