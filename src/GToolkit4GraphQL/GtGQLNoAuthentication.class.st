Class {
	#name : #GtGQLNoAuthentication,
	#superclass : #Object,
	#traits : 'TGtGQLAuthentication',
	#classTraits : 'TGtGQLAuthentication classTrait',
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'api - configuration' }
GtGQLNoAuthentication >> configureZnClient: aZnClient [
	"do nothing"

	
]

{ #category : #copying }
GtGQLNoAuthentication >> copyWithAuthentication: anAuthentication [
	^ anAuthentication
]
