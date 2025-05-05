Class {
	#name : #GtGQLModifiedQueryExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #accessing }
GtGQLModifiedQueryExamples >> basicModifiedQuery [
	<gtExample>
	<return: #GtGQLModifiedQuery>
	| aModifiedQuery |
	aModifiedQuery := GtGQLModifiedQuery new.

	self
		assert: aModifiedQuery operation isNil
		description: [ 'Query operation must be nil' ].
	self
		assert: aModifiedQuery input isNil
		description: [ 'Query input must be nil' ].
	self
		assert: aModifiedQuery previousQuery isNil
		description: [ 'Previous query must be nil' ].

	^ aModifiedQuery
]

{ #category : #accessing }
GtGQLModifiedQueryExamples >> modifiedQueryWithOperation [
	<gtExample>
	<return: #GtGQLModifiedQuery>
	| aModifiedQuery anOperation aPreviousQuery |
	aModifiedQuery := self basicModifiedQuery.
	anOperation := 'query MyQuery { 
		fieldName
		anotherField }'.
	aPreviousQuery := GtGQLQueryExamples new queryWithOperation.

	aModifiedQuery operation: anOperation.
	aModifiedQuery previousQuery: aPreviousQuery.

	self assert: aModifiedQuery operation equals: anOperation.
	self assert: aModifiedQuery previousQuery equals: aPreviousQuery.

	self
		assert: aModifiedQuery input isNil
		description: [ 'Query input must be nil' ].

	^ aModifiedQuery
]
