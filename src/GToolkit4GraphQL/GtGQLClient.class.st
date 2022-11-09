Class {
	#name : #GtGQLClient,
	#superclass : #Object,
	#traits : 'TGtGQLClient',
	#classTraits : 'TGtGQLClient classTrait',
	#instVars : [
		'configuration'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLClient >> configuration [

	^ configuration
]

{ #category : #'as yet unclassified' }
GtGQLClient >> configuration: anObject [

	configuration := anObject
]
