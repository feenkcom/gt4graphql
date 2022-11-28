Class {
	#name : #GtGQLConnectionPathBuilderExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - builder' }
GtGQLConnectionPathBuilderExamples >> basicBuilder [
	<gtExample>
	| aBuilder |
	aBuilder := GtGQLConnectionPathBuilder new.

	self assert: aBuilder paths isNil.
	self assert: aBuilder ast isNil.

	^ aBuilder
]

{ #category : #'examples - builder' }
GtGQLConnectionPathBuilderExamples >> builderWithGitHubQueryWithFragmentPageInfoField [
	<gtExample>
	| aBuilder aRootNode anAuthorNode |
	aBuilder := self basicBuilder.
	aRootNode := self gitHubQueryWithFragmentPageInfoField graphqlNode.

	aRootNode
		withAllNodesOfType: GraphQLFieldNode
		do: [ :aNode | (aNode name ifNotNil: #source) = 'author' ifTrue: [ anAuthorNode := aNode ] ].

	self
		assert: anAuthorNode isNotNil
		description: [ 'Author node must be non-nil' ].

	aBuilder ast: anAuthorNode.

	self assert: aBuilder paths isNil.
	self assert: aBuilder ast equals: anAuthorNode.

	aBuilder build.

	self assert: aBuilder paths size equals: 1.
	self
		assert: aBuilder paths anyOne resultPathString
		equals: 'repository.defaultBranchRef.target.history.edges.node.author'.

	^ aBuilder
]

{ #category : #'examples - queries' }
GtGQLConnectionPathBuilderExamples >> gitHubQueryWithFragmentPageInfoField [
	<gtExample>
	^ GtGQLDataExamples new gitHubQueryWithFragmentPageInfoField
]
