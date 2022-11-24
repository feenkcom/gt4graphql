Extension { #name : #GraphQLFieldNode }

{ #category : #'*GToolkit4GraphQL' }
GraphQLFieldNode >> fieldIn: schema [
	| type |
	type := (self
			parentOfType: {self class.
					GraphQLInlineFragmentNode.
					GraphQLFragmentDefinitionNode})
			ifNil: [ (self parentOfType: GraphQLOperationDefinitionNode)
					ifNotNil: [ :node | 
						node isPartOfQuery
							ifTrue: [ schema queryType ]
							ifFalse: [ node isPartOfMutation ifTrue: [ schema mutationType ] ] ] ]
			ifNotNil: [ :node | node typeIn: schema ].
	^ type
		ifNotNil: [ type baseType fields
				detect: [ :each | each name = self name source ]
				ifNone: [  ] ]
]

{ #category : #'*GToolkit4GraphQL' }
GraphQLFieldNode >> typeIn: schema [
	| stack type operation index nameNode |
	stack := self allParents reversed.
	stack addLast: self.
	(stack size >= 2
		and: [ ((operation := stack second) isKindOf: GraphQLOperationDefinitionNode)
				or: [ (operation := stack second) isKindOf: GraphQLFragmentDefinitionNode ] ])
		ifFalse: [ ^ nil ].

	type := operation typeIn: schema.
	index := 3.

	[ type notNil and: [ index <= stack size ] ]
		whileTrue: [ nameNode := stack at: index.

			(nameNode isKindOf: GraphQLInlineFragmentNode)
				ifTrue: [ type := nameNode typeIn: schema ].

			(nameNode isKindOf: GraphQLFragmentDefinitionNode)
				ifTrue: [ type := nameNode typeIn: schema ].

			(nameNode isKindOf: self class)
				ifTrue: [ type fields
						detect: [ :each | each name = nameNode name source ]
						ifFound: [ :field | type := field type baseType ]
						ifNone: [ ^ nil ] ].

			index := index + 1 ].
	^ type
]
