Class {
	#name : #GtGQLCompositeAuthentication,
	#superclass : #Object,
	#traits : 'TGtGQLAuthentication',
	#classTraits : 'TGtGQLAuthentication classTrait',
	#instVars : [
		'authentications'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'api - initialization' }
GtGQLCompositeAuthentication >> authentication: anAuthentication [
	authentications := authentications copyWith: anAuthentication
]

{ #category : #'api - configuration' }
GtGQLCompositeAuthentication >> configureZnClient: aZnClient [
	authentications
		do: [ :eachAuthentication | eachAuthentication configureZnClient: aZnClient ]
]

{ #category : #copying }
GtGQLCompositeAuthentication >> copyWithAuthentication: anAuthentication [
	self authentication: anAuthentication
]

{ #category : #initialization }
GtGQLCompositeAuthentication >> initialize [
	super initialize.

	authentications := #()
]
