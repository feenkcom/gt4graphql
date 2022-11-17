Class {
	#name : #GtGQLModifiedQuery,
	#superclass : #Object,
	#instVars : [
		'operation',
		'input',
		'previousQuery'
	],
	#category : #'GToolkit4GraphQL-Async Streams'
}

{ #category : #'gt - extensions' }
GtGQLModifiedQuery >> gtNewQueryFor: aView [
	<gtView>
	self operation ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'New Query';
		priority: 30;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ GraphQLParser gtStyler ];
		text: [ self operation ]
]

{ #category : #'gt - extensions' }
GtGQLModifiedQuery >> gtQueryFor: aView [
	<gtView>
	^ aView explicit
		title: 'Query';
		priority: 1;
		stencil: [ GtDiffElementWithLabelStencil new
				fromLabelText: 'Previous Query:';
				toLabelText: 'New Query:';
				diffBuilder: (TextDiffBuilder from: self previousQuery operation to: self operation) ]
]

{ #category : #'gt - extensions' }
GtGQLModifiedQuery >> gtVariablesFor: aView [
	<gtView>
	| aSelector |
	input ifNil: [ ^ aView empty ].

	aSelector := input isString
			ifTrue: [ #gtStringFor: ]
			ifFalse: [ #gtTreeFor:context: ].

	^ aView forward
		title: 'Variables';
		priority: 31;
		object: [ input ];
		view: aSelector
]

{ #category : #accessing }
GtGQLModifiedQuery >> input [
	^ input
]

{ #category : #accessing }
GtGQLModifiedQuery >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtGQLModifiedQuery >> operation [
	^ operation
]

{ #category : #accessing }
GtGQLModifiedQuery >> operation: anObject [
	operation := anObject
]

{ #category : #accessing }
GtGQLModifiedQuery >> previousQuery [
	^ previousQuery
]

{ #category : #accessing }
GtGQLModifiedQuery >> previousQuery: anObject [
	previousQuery := anObject
]
