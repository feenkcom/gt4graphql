Class {
	#name : #GtGQLSnippetInputChanged,
	#superclass : #LeSnippetContentChanged,
	#instVars : [
		'input'
	],
	#category : #'GToolkit4GraphQL-Snippet-Events'
}

{ #category : #accessing }
GtGQLSnippetInputChanged >> input [
	^ input
]

{ #category : #accessing }
GtGQLSnippetInputChanged >> input: aString [
	input := aString
]
