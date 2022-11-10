Class {
	#name : #GtGQLSnippetOperationChanged,
	#superclass : #LeSnippetContentChanged,
	#instVars : [
		'operation'
	],
	#category : #'GToolkit4GraphQL-Snippet-Events'
}

{ #category : #accessing }
GtGQLSnippetOperationChanged >> operation [
	^ operation
]

{ #category : #accessing }
GtGQLSnippetOperationChanged >> operation: aString [
	operation := aString
]
