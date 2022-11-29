Class {
	#name : #GtGQLValueStepBuilder,
	#superclass : #Object,
	#instVars : [
		'parentStep',
		'fieldName',
		'step'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'api - building' }
GtGQLValueStepBuilder >> build [
	self buildStepStartingNode: self parentAst
]

{ #category : #'api - building' }
GtGQLValueStepBuilder >> buildStepStartingNode: aParentNode [
	aParentNode selections
		do: [ :aNode | 
			((aNode isKindOf: GraphQLFieldNode)
				and: [ (aNode name ifNotNil: #source) = self fieldName ])
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

{ #category : #accessing }
GtGQLValueStepBuilder >> fieldName [
	^ fieldName
]

{ #category : #accessing }
GtGQLValueStepBuilder >> fieldName: anObject [
	fieldName := anObject
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
