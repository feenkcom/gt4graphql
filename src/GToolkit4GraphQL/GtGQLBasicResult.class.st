Class {
	#name : #GtGQLBasicResult,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'query',
		'variables'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLBasicResult >> configuration [
	^ configuration
]

{ #category : #accessing }
GtGQLBasicResult >> configuration: anObject [
	configuration := anObject
]

{ #category : #'gt - extensions' }
GtGQLBasicResult >> gtQueryFor: aView [
	<gtView>
	self query ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Query';
		priority: 30;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ GraphQLParser gtStyler ];
		text: [ self query ]
]

{ #category : #'gt - extensions' }
GtGQLBasicResult >> gtVariablesFor: aView [
	<gtView>
	self variables ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Variables';
		priority: 31;
		object: [ self variables ];
		view: #gtTreeFor:context:
]

{ #category : #accessing }
GtGQLBasicResult >> isSuccess [
	^ false
]

{ #category : #accessing }
GtGQLBasicResult >> query [
	^ query
]

{ #category : #accessing }
GtGQLBasicResult >> query: anObject [
	query := anObject
]

{ #category : #accessing }
GtGQLBasicResult >> variables [
	^ variables
]

{ #category : #accessing }
GtGQLBasicResult >> variables: anObject [
	variables := anObject
]
