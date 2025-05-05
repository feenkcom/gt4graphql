Class {
	#name : #GtGQLQueryExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #accessing }
GtGQLQueryExamples >> basicQuery [
	<gtExample>
	<return: #GtGQLQuery>
	| aQuery |
	aQuery := GtGQLQuery new.

	self
		assert: aQuery operation isNil
		description: [ 'Query operation must be nil' ].
	self assert: aQuery input isNil description: [ 'Query input must be nil' ].

	^ aQuery
]

{ #category : #accessing }
GtGQLQueryExamples >> queryWithInput_AsDictionary [
	<gtExample>
	<return: #GtGQLQuery>
	| aQuery anInput |
	aQuery := self basicQuery.
	anInput := Dictionary new
			at: #variable put: 42;
			yourself.

	aQuery input: anInput.

	self assert: aQuery input equals: anInput.

	self
		assert: aQuery input == aQuery input
		description: [ 'Query input must return same objects when called several times.' ].

	self
		assert: aQuery operation isNil
		description: [ 'Query operation must be nil' ].

	^ aQuery
]

{ #category : #accessing }
GtGQLQueryExamples >> queryWithInput_AsEmptyString [
	<gtExample>
	<return: #GtGQLQuery>
	| aQuery anInput |
	aQuery := self basicQuery.
	anInput := ''.

	aQuery input: anInput.

	self assert: aQuery input equals: Dictionary new.

	self
		assert: aQuery input == aQuery input
		description: [ 'Query input must return same objects when called several times.' ].

	self
		assert: aQuery operation isNil
		description: [ 'Query operation must be nil' ].

	^ aQuery
]

{ #category : #accessing }
GtGQLQueryExamples >> queryWithInput_AsInvalidString [
	<gtExample>
	<return: #GtGQLQuery>
	| aQuery anInput |
	aQuery := self basicQuery.
	anInput := '{ [] }'.

	aQuery input: anInput.

	self assert: aQuery input equals: Dictionary new.

	self
		assert: aQuery input == aQuery input
		description: [ 'Query input must return same objects when called several times.' ].

	self
		assert: aQuery operation isNil
		description: [ 'Query operation must be nil' ].

	^ aQuery
]

{ #category : #accessing }
GtGQLQueryExamples >> queryWithInput_AsString [
	<gtExample>
	<return: #GtGQLQuery>
	| aQuery anInput |
	aQuery := self basicQuery.
	anInput := '{ "variable" : 42 }'.

	aQuery input: anInput.

	self
		assert: aQuery input
		equals: (Dictionary new
				at: #variable put: 42;
				yourself).

	self
		assert: aQuery input == aQuery input
		description: [ 'Query input must return same objects when called several times.' ].

	self
		assert: aQuery operation isNil
		description: [ 'Query operation must be nil' ].

	^ aQuery
]

{ #category : #accessing }
GtGQLQueryExamples >> queryWithOperation [
	<gtExample>
	<return: #GtGQLQuery>
	| aQuery anOperation |
	aQuery := self basicQuery.
	anOperation := 'query MyQuery { 
	fieldName }'.

	aQuery operation: anOperation.

	self assert: aQuery operation equals: anOperation.
	self assert: aQuery input isNil description: [ 'Query input must be nil' ].

	^ aQuery
]
