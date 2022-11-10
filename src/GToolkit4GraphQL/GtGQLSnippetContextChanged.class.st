Class {
	#name : #GtGQLSnippetContextChanged,
	#superclass : #LeSnippetContentChanged,
	#instVars : [
		'context'
	],
	#category : #'GToolkit4GraphQL-Snippet-Events'
}

{ #category : #accessing }
GtGQLSnippetContextChanged >> context [
	^ context
]

{ #category : #accessing }
GtGQLSnippetContextChanged >> context: aString [
	context := aString
]
