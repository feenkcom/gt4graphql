"
I take a {{gtClass:GtGQLTypePath}} and build {{gtClass:GtGQLQuery}} with a query operation text.

"
Class {
	#name : #GtGQLPathToQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'path',
		'query',
		'indentation',
		'stream',
		'currentStep'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> build [
	self buildQuery
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> buildClosingPath [
	self path steps
		reverseDo: [ :eachStep | 
			self decreaseIndentation.
			self nextPutIndentationTabs.

			eachStep = self path leafStep
				ifTrue: [ (self hasFieldTypeWithSelections: eachStep) ifTrue: [ stream nextPutAll: '}' ] ]
				ifFalse: [ stream nextPutAll: '}' ].
			stream cr ]
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> buildCurrentStep [
	| aFieldName |
	self nextPutIndentationTabs.

	aFieldName := currentStep field name.
	stream nextPutAll: aFieldName.
	self isCurrentStepLeaf
		ifTrue: [ (self hasFieldTypeWithSelections: currentStep)
				ifTrue: [ stream nextPutAll: ' {' ] ]
		ifFalse: [ stream nextPutAll: ' {' ].

	self increaseIndentation.

	(self isTypeWithSelections: currentStep type baseType)
		ifTrue: [ | shouldDecreaseIndentation |
			shouldDecreaseIndentation := false.

			self isCurrentStepLeaf
				ifTrue: [ self path stopType = currentStep fieldBaseType
						ifFalse: [ stream cr.
							self nextPutIndentationTabs.
							stream nextPutAll: '...on '.
							stream nextPutAll: self path stopType name.

							(self hasFieldTypeWithSelections: currentStep)
								ifTrue: [ stream nextPutAll: ' {' ] ].

					self increaseIndentation.
					shouldDecreaseIndentation := true ].

			stream cr.
			self nextPutIndentationTabs.
			stream nextPutAll: GtGQLIntrospectionConstants metaMetaTypeName.

			shouldDecreaseIndentation
				ifTrue: [ self decreaseIndentation.
					stream cr.
					self nextPutIndentationTabs.
					stream nextPut: $} ] ].

	stream cr
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> buildOpeningPath [
	self path steps
		do: [ :eachStep | 
			currentStep := eachStep.
			self buildCurrentStep.
			currentStep := nil ]
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> buildOperation [
	^ String
		streamContents: [ :aStream | 
			indentation := 0.
			stream := aStream.

			stream
				nextPutAll: 'query {';
				cr.
				
			self increaseIndentation.

			self buildOpeningPath.
			self buildClosingPath.
			
			self decreaseIndentation.

			self
				assert: [ indentation isZero ]
				description: [ 'Indentation must be zero at the end of operation building process' ].

			stream
				nextPut: $};
				cr ]
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> buildQuery [
	query := GtGQLQuery new operation: self buildOperation
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> decreaseIndentation [
	indentation := indentation - 1
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> hasFieldTypeWithSelections: eachStep [
	^ self isTypeWithSelections: eachStep fieldBaseType
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> increaseIndentation [
	indentation := indentation + 1
]

{ #category : #'private - testing' }
GtGQLPathToQueryBuilder >> isCurrentStepLeaf [
	^ currentStep = self path leafStep
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> isTypeWithSelections: aBaseType [
	^ aBaseType isComposite or: [ aBaseType isUnion ]
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> nextPutIndentationTabs [
	indentation timesRepeat: [ stream tab ]
]

{ #category : #accessing }
GtGQLPathToQueryBuilder >> path [
	^ path
]

{ #category : #accessing }
GtGQLPathToQueryBuilder >> path: anObject [
	path := anObject
]

{ #category : #accessing }
GtGQLPathToQueryBuilder >> query [
	^ query
]

{ #category : #accessing }
GtGQLPathToQueryBuilder >> query: anObject [
	query := anObject
]
