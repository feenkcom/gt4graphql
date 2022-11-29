"
I build {{gtClass:GtGQLPath}} for a given {{gtClass:GraphQLFieldNode}}. 

##Examples
##One Path
For a given GraphQL query: {{gtExample: GtGQLPathBuilderExamples >> #gitHubQueryWithFragmentPageInfoField | noCode | previewShow=#gtQueryFor: | previewHeight=300}} 
I compute one possible path: {{gtExample: GtGQLPathBuilderExamples >> #builderWithGitHubQueryWithFragmentPageInfoField | noCode | previewHeight=50 | previewShow=#gtPathsFor:}}
##Multiple Paths
For a given GraphQL query: {{gtExample: GtGQLPathBuilderExamples >> #gitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues | noCode | previewShow=#gtQueryFor: | previewHeight=300}}


I compute two possible paths: {{gtExample: GtGQLPathBuilderExamples >> #builderWithGitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues | noCode | previewHeight=100 | previewShow=#gtPathsFor:}} 
See {{gtClass:GtGQLPath}} class comment for further information.
"
Class {
	#name : #GtGQLPathBuilder,
	#superclass : #GraphQLProgramNodeVisitor,
	#instVars : [
		'ast',
		'paths',
		'currentPath'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #accessing }
GtGQLPathBuilder >> ast [
	^ ast
]

{ #category : #accessing }
GtGQLPathBuilder >> ast: anObject [
	ast := anObject
]

{ #category : #'api - building' }
GtGQLPathBuilder >> build [
	paths := OrderedCollection new.
	currentPath := OrderedCollection new.

	self acceptNode: self ast
]

{ #category : #'gt - extensions' }
GtGQLPathBuilder >> gtPathsFor: aView [
	<gtView>
	paths ifNil: [ ^ aView empty ].

	^ aView list
		title: 'Paths';
		priority: 1;
		items: [ self paths ifNil: [ #() ] ];
		itemText: [ :aStep | aStep resultPathText ]
]

{ #category : #accessing }
GtGQLPathBuilder >> paths [
	^ paths
]

{ #category : #visiting }
GtGQLPathBuilder >> visitDocument: aNode [
	"do nothing"
]

{ #category : #visiting }
GtGQLPathBuilder >> visitField: aNode [
	| aName anAlias |
	anAlias := aNode alias ifNotNil: #source.
	aName := aNode name ifNotNil: #source.
	currentPath
		add: (GtGQLPathStep new
				alias: anAlias;
				name: aName;
				ast: aNode).

	self acceptNode: aNode parent
]

{ #category : #visiting }
GtGQLPathBuilder >> visitFragmentDefinition: aNode [
	| aFragmentName partialPath |
	aFragmentName := aNode name source.

	partialPath := currentPath copy.

	aNode topParent
		allNodesOfType: GraphQLFragmentSpreadNode
		do: [ :aSpread | 
			aSpread name source = aFragmentName
				ifTrue: [ self acceptNode: aSpread.
					currentPath := partialPath copy ] ]
]

{ #category : #visiting }
GtGQLPathBuilder >> visitFragmentSpread: aNode [
	self acceptNode: aNode parent
]

{ #category : #visiting }
GtGQLPathBuilder >> visitInlineFragment: aNode [
	self acceptNode: aNode parent
]

{ #category : #visiting }
GtGQLPathBuilder >> visitOperationDefinition: aNode [
	"do nothing"

	| aPath |
	aPath := GtGQLPath new
			steps: currentPath reversed asArray;
			ast: aNode.

	paths add: aPath
]
