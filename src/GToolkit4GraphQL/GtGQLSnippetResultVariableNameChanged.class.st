Class {
	#name : #GtGQLSnippetResultVariableNameChanged,
	#superclass : #LeSnippetContentChanged,
	#instVars : [
		'resultVariableName'
	],
	#category : #'GToolkit4GraphQL-Snippet-Events'
}

{ #category : #accessing }
GtGQLSnippetResultVariableNameChanged >> resultVariableName [
	^ resultVariableName
]

{ #category : #accessing }
GtGQLSnippetResultVariableNameChanged >> resultVariableName: anObject [
	resultVariableName := anObject
]
