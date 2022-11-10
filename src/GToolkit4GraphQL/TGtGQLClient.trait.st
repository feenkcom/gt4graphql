Trait {
	#name : #TGtGQLClient,
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'api - communication' }
TGtGQLClient >> introspectionSchema [
	<return: #String>
	^ self explicitRequirement
]
