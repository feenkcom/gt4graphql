Extension { #name : #GraphQLInlineFragmentNode }

{ #category : #'*GToolkit4GraphQL' }
GraphQLInlineFragmentNode >> typeIn: schema [
	| nameToken name |
	nameToken := self type ifNotNil: #name.
	name := nameToken ifNotNil: #source.
	name ifNil: [ ^ nil ].

	^ schema typeNamed: name
]
