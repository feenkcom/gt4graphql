Class {
	#name : #GtGQLSnippetResultVariableNameChanged,
	#superclass : #LeSnippetContentChanged,
	#instVars : [
		'newName',
		'oldName'
	],
	#category : #'GToolkit4GraphQL-Snippet-Events'
}

{ #category : #accessing }
GtGQLSnippetResultVariableNameChanged >> oldName [

	^ oldName
]

{ #category : #accessing }
GtGQLSnippetResultVariableNameChanged >> oldName: anObject [

	oldName := anObject
]

{ #category : #accessing }
GtGQLSnippetResultVariableNameChanged >> resultVariableName [
	^ newName
]

{ #category : #accessing }
GtGQLSnippetResultVariableNameChanged >> resultVariableName: anObject [
	newName := anObject
]
