Extension { #name : #GraphQLFragmentDefinitionNode }

{ #category : #'*GToolkit4GraphQL' }
GraphQLFragmentDefinitionNode >> typeIn: schema [
	| nameToken typeName |
	nameToken := self type ifNotNil: [ :v | v name ].
	typeName := nameToken ifNotNil: [ :v | v source ].
	typeName ifNil: [ ^ nil ].

	^ schema typeNamed: typeName
]
