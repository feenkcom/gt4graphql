Class {
	#name : #GtGQLValueStepBuilder,
	#superclass : #Object,
	#instVars : [
		'parentStep',
		'step',
		'accessor'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'api - initialization' }
GtGQLValueStepBuilder >> aliasName: aName [
	accessor := GtGQLAliasNodeAccessor new aliasName: aName
]

{ #category : #'api - building' }
GtGQLValueStepBuilder >> build [
	self buildStepStartingNode: self parentAst
]

{ #category : #'api - building' }
GtGQLValueStepBuilder >> buildStepStartingNode: aParentNode [
	aParentNode selections
		do: [ :aNode | 
			((aNode isKindOf: GraphQLFieldNode) and: [ accessor isFieldNode: aNode ])
				ifTrue: [ step := self parentStep class new
							alias: (aNode alias ifNotNil: #source);
							name: (aNode name ifNotNil: #source);
							parent: self;
							ast: aNode.
					^ self ].

			(aNode isKindOf: GraphQLFragmentSpreadNode)
				ifTrue: [ self newStepInFragmentSpread: aNode.
					self hasStep ifTrue: [ ^ self ] ].

			(aNode isKindOf: GraphQLInlineFragmentNode)
				ifTrue: [ self newStepInInlineFragment: aNode.
					self hasStep ifTrue: [ ^ self ] ] ]
]

{ #category : #'api - initialization' }
GtGQLValueStepBuilder >> fieldName: aName [
	accessor := GtGQLNameNodeAccessor new fieldName: aName
]

{ #category : #testing }
GtGQLValueStepBuilder >> hasStep [
	^ step isNotNil
]

{ #category : #'private - building' }
GtGQLValueStepBuilder >> newStepInFragmentSpread: aSpreadNode [
	| aFragmentName |
	aFragmentName := aSpreadNode name ifNotNil: #source.
	aFragmentName ifNil: [ ^ self ].

	aSpreadNode topParent
		allNodesOfType: GraphQLFragmentDefinitionNode
		do: [ :aFragmentNode | 
			(aFragmentNode name ifNotNil: #source) = aFragmentName
				ifTrue: [ self buildStepStartingNode: aFragmentNode ] ]
]

{ #category : #'private - building' }
GtGQLValueStepBuilder >> newStepInInlineFragment: anInlineFragment [
	self buildStepStartingNode: anInlineFragment
]

{ #category : #accessing }
GtGQLValueStepBuilder >> parentAst [
	^ self parentStep ast
]

{ #category : #accessing }
GtGQLValueStepBuilder >> parentStep [
	^ parentStep
]

{ #category : #accessing }
GtGQLValueStepBuilder >> parentStep: anObject [
	parentStep := anObject
]

{ #category : #accessing }
GtGQLValueStepBuilder >> step [
	^ step
]
