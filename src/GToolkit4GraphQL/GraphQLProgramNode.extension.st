Extension { #name : #GraphQLProgramNode }

{ #category : #'*GToolkit4GraphQL' }
GraphQLProgramNode >> fieldIn: aSchema [
	^ nil
]

{ #category : #'*GToolkit4GraphQL' }
GraphQLProgramNode >> isPartOfMutation [
	^ parent notNil and: [ parent isPartOfMutation ]
]

{ #category : #'*GToolkit4GraphQL' }
GraphQLProgramNode >> isPartOfQuery [
	^ parent notNil and: [ parent isPartOfQuery ]
]

{ #category : #'*GToolkit4GraphQL' }
GraphQLProgramNode >> typeIn: aSchema [
	^ nil
]
