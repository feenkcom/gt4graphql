"
I exemplify {{gtClass:GtGQLPathBuilder}}. 
"
Class {
	#name : #GtGQLPathBuilderExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - builder' }
GtGQLPathBuilderExamples >> basicBuilder [
	<gtExample>
	<return: #GtGQLPathBuilder>
	| aBuilder |
	aBuilder := GtGQLPathBuilder new.

	self assert: aBuilder paths isNil.
	self assert: aBuilder ast isNil.

	^ aBuilder
]

{ #category : #'examples - builder' }
GtGQLPathBuilderExamples >> builderWithGitHubQueryWithFragmentPageInfoField [
	<gtExample>
	<return: #GtGQLPathBuilder>
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

{ #category : #'examples - builder' }
GtGQLPathBuilderExamples >> builderWithGitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues [
	<gtExample>
	<return: #GtGQLPathBuilder>
	| aBuilder aRootNode aTotalCountNode |
	aBuilder := self basicBuilder.
	aRootNode := self gitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues
			graphqlNode.

	aRootNode
		withAllNodesOfType: GraphQLFieldNode
		do: [ :aNode | 
			((aNode name ifNotNil: #source) = 'totalCount'
				and: [ aNode parent isKindOf: GraphQLFragmentDefinitionNode ])
				ifTrue: [ aTotalCountNode := aNode ] ].

	self
		assert: aTotalCountNode isNotNil
		description: [ 'Author node must be non-nil' ].

	aBuilder ast: aTotalCountNode.

	self assert: aBuilder paths isNil.
	self assert: aBuilder ast equals: aTotalCountNode.

	aBuilder build.

	self assert: aBuilder paths size equals: 2.
	self
		assert: aBuilder paths first resultPathString
		equals: 'organization.repositories.edges.node.openIssues.totalCount'.
	self
		assert: aBuilder paths second resultPathString
		equals: 'organization.repositories.edges.node.closedIssues.totalCount'.

	^ aBuilder
]

{ #category : #'examples - builder' }
GtGQLPathBuilderExamples >> closedIssuesPath [
	<gtExample>
	<return: #GtGQLPath>
	| aBuilder aPath |
	aBuilder := self
			builderWithGitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues.

	aPath := aBuilder paths second.

	self
		assert: aPath resultPathString
		equals: 'organization.repositories.edges.node.closedIssues.totalCount'.

	^ aPath
]

{ #category : #'examples - queries' }
GtGQLPathBuilderExamples >> gitHubQueryWithFragmentPageInfoField [
	<gtExample>
	<return: #GtGQLQuery>
	^ GtGQLDataExamples new gitHubQueryWithFragmentPageInfoField
]

{ #category : #'examples - queries' }
GtGQLPathBuilderExamples >> gitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues [
	<gtExample>
	<return: #GtGQLQuery>
	^ GtGQLDataExamples new
		gitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues
]

{ #category : #'examples - builder' }
GtGQLPathBuilderExamples >> openIssuesPath [
	<gtExample>
	<return: #GtGQLPath>
	| aBuilder aPath |
	aBuilder := self
			builderWithGitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues.

	aPath := aBuilder paths first.

	self
		assert: aPath resultPathString
		equals: 'organization.repositories.edges.node.openIssues.totalCount'.

	^ aPath
]
