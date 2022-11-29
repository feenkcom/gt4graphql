Class {
	#name : #GtGQLConnectionPathBuilder,
	#superclass : #GraphQLProgramNodeVisitor,
	#instVars : [
		'ast',
		'paths',
		'currentPath'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #accessing }
GtGQLConnectionPathBuilder >> ast [
	^ ast
]

{ #category : #accessing }
GtGQLConnectionPathBuilder >> ast: anObject [
	ast := anObject
]

{ #category : #'api - building' }
GtGQLConnectionPathBuilder >> build [
	paths := OrderedCollection new.
	currentPath := OrderedCollection new.

	self acceptNode: self ast
]

{ #category : #'gt - extensions' }
GtGQLConnectionPathBuilder >> gtPathsFor: aView [
	<gtView>
	paths ifNil: [ ^ aView empty ].

	^ aView list
		title: 'Paths';
		priority: 1;
		items: [ self paths ifNil: [ #() ] ];
		itemText: [ :aStep | aStep resultPathText ]
]

{ #category : #accessing }
GtGQLConnectionPathBuilder >> paths [
	^ paths
]

{ #category : #visiting }
GtGQLConnectionPathBuilder >> visitDocument: aNode [
	"do nothing"
]

{ #category : #visiting }
GtGQLConnectionPathBuilder >> visitField: aNode [
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
GtGQLConnectionPathBuilder >> visitFragmentDefinition: aNode [
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
GtGQLConnectionPathBuilder >> visitFragmentSpread: aNode [
	self acceptNode: aNode parent
]

{ #category : #visiting }
GtGQLConnectionPathBuilder >> visitInlineFragment: aNode [
	self acceptNode: aNode parent
]

{ #category : #visiting }
GtGQLConnectionPathBuilder >> visitOperationDefinition: aNode [
	"do nothing"

	| aPath |
	aPath := GtGQLPath new
			steps: currentPath reversed asArray;
			ast: aNode.

	paths add: aPath
]
