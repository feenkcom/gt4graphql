Extension { #name : #GraphQLInlineFragmentNode }

{ #category : #'*GToolkit4GraphQL' }
GraphQLInlineFragmentNode >> typeIn: schema [
	| nameToken name |
	nameToken := self type ifNotNil: [ :v | v name ].
	name := nameToken ifNotNil: [ :v | v source ].
	name ifNil: [ ^ nil ].

	^ schema typeNamed: name
]
