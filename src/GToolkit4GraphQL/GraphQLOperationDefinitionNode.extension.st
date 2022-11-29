Extension { #name : #GraphQLOperationDefinitionNode }

{ #category : #'*GToolkit4GraphQL' }
GraphQLOperationDefinitionNode >> isPartOfMutation [
	^ type notNil and: [ type source = 'mutation' ]
]

{ #category : #'*GToolkit4GraphQL' }
GraphQLOperationDefinitionNode >> isPartOfQuery [
	^ type isNil or: [ type source = 'query' ]
]

{ #category : #'*GToolkit4GraphQL' }
GraphQLOperationDefinitionNode >> typeIn: schema [
	^ self isPartOfQuery
		ifTrue: [ schema queryType ]
		ifFalse: [ self isPartOfMutation ifTrue: [ schema mutationType ] ifFalse: [ nil ] ]
]
