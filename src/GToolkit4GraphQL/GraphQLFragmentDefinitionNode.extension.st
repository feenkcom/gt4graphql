Extension { #name : #GraphQLFragmentDefinitionNode }

{ #category : #'*GToolkit4GraphQL' }
GraphQLFragmentDefinitionNode >> typeIn: schema [
	| nameToken typeName |
	nameToken := self type ifNotNil: #name.
	typeName := nameToken ifNotNil: #source.
	typeName ifNil: [ ^ nil ].

	^ schema typeNamed: typeName
]
