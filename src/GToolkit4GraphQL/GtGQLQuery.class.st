Class {
	#name : #GtGQLQuery,
	#superclass : #Object,
	#instVars : [
		'operation',
		'input'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLQuery >> copyWithNewInputs: anInput [
	^ self copy input: anInput
]

{ #category : #private }
GtGQLQuery >> ensureDictionary [
	input isDictionary ifTrue: [ ^ self ].
	input isString ifTrue: [ input := STONJSON fromString: input ]
]

{ #category : #'gt - extensions' }
GtGQLQuery >> gtQueryFor: aView [
	<gtView>
	self operation ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Query';
		priority: 1;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ GraphQLParser gtStyler ];
		text: [ self operation ]
]

{ #category : #'gt - extensions' }
GtGQLQuery >> gtVariablesFor: aView [
	<gtView>
	| aSelector |
	input ifNil: [ ^ aView empty ].

	aSelector := input isString
			ifTrue: [ #gtStringFor: ]
			ifFalse: [ #gtTreeFor:context: ].

	^ aView forward
		title: 'Variables';
		priority: 2;
		object: [ input ];
		view: aSelector
]

{ #category : #accessing }
GtGQLQuery >> input [
	<return: #Dictionary>
	self ensureDictionary.
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
