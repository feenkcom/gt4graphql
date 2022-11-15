Extension { #name : #GraphQLOperationDefinitionNode }

{ #category : #'*GToolkit4GraphQL' }
GraphQLOperationDefinitionNode >> isPartOfMutation [
	^ type notNil and: [ type source = 'mutation' ]
]

{ #category : #'*GToolkit4GraphQL' }
GraphQLOperationDefinitionNode >> isPartOfQuery [
	^ type isNil or: [ type source = 'query' ]
]
