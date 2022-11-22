Class {
	#name : #GtGQLModifiedQuery,
	#superclass : #GtGQLQuery,
	#instVars : [
		'previousQuery'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'gt - extensions' }
GtGQLModifiedQuery >> gtNewQueryFor: aView [
	<gtView>
	self operation ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'New Query';
		priority: 10;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ GraphQLParser gtStyler ];
		text: [ self operation ]
]

{ #category : #'gt - extensions' }
GtGQLModifiedQuery >> gtPreviousQueryFor: aView [
	<gtView>
	self previousQuery ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Previous Query';
		priority: 11;
		object: [ self previousQuery ];
		view: #gtViewFor:
]

{ #category : #'gt - extensions' }
GtGQLModifiedQuery >> gtQueryFor: aView [
	<gtView>
	^ aView explicit
		title: 'Query';
		priority: 1;
		stencil: [ | aFromOperation aToOperation |
			aFromOperation := (self previousQuery ifNotNil: #operation) ifNil: [ '' ].
			aToOperation := self operation ifNil: [ '' ].
			GtDiffElementWithLabelStencil new
				fromLabelText: 'Previous Query:';
				toLabelText: 'New Query:';
				diffBuilder: (GtTextDiff new
						from: aFromOperation to: aToOperation;
						styler: [ GraphQLParser gtStyler ]) ]
]

{ #category : #accessing }
GtGQLModifiedQuery >> previousQuery [
	^ previousQuery
]

{ #category : #accessing }
GtGQLModifiedQuery >> previousQuery: anObject [
	previousQuery := anObject
]
