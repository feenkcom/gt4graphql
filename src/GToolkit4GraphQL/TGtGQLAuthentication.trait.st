Trait {
	#name : #TGtGQLAuthentication,
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'api - configuration' }
TGtGQLAuthentication >> configureZnClient: aZnClient [
	self explicitRequirement
]

{ #category : #copying }
TGtGQLAuthentication >> copyWithAuthentication: anAuthentication [
	^ GtGQLCompositeAuthentication new authentication: anAuthentication
]
