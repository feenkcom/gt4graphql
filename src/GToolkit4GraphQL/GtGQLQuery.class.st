Class {
	#name : #GtGQLQuery,
	#superclass : #Object,
	#instVars : [
		'operation',
		'input'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'gt - extensions' }
GtGQLQuery >> gtQueryFor: aView [
	<gtView>
	self operation ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Query';
		priority: 30;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ GraphQLParser gtStyler ];
		text: [ self operation ]
]

{ #category : #'gt - extensions' }
GtGQLQuery >> gtVariablesFor: aView [
	<gtView>
	| aSelector |
	self input ifNil: [ ^ aView empty ].

	aSelector := self input isString
			ifTrue: [ #gtStringFor: ]
			ifFalse: [ #gtTreeFor:context: ].

	^ aView forward
		title: 'Variables';
		priority: 31;
		object: [ self input ];
		view: aSelector
]

{ #category : #accessing }
GtGQLQuery >> input [
	^ input
]

{ #category : #accessing }
GtGQLQuery >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtGQLQuery >> operation [
	^ operation
]

{ #category : #accessing }
GtGQLQuery >> operation: anObject [
	operation := anObject
]
