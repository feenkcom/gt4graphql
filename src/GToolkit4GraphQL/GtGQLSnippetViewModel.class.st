Class {
	#name : #GtGQLSnippetViewModel,
	#superclass : #LeSnippetViewModel,
	#category : #'GToolkit4GraphQL-Snippet-View-Model'
}

{ #category : #'api - accessing' }
GtGQLSnippetViewModel >> snippetElementClass [
	^ GtGQLSnippetElement
]

{ #category : #accessing }
GtGQLSnippetViewModel >> snippetView [
	<return: #LeSnippetView>
	^ super snippetView needsContentDecorationBar: true
]

{ #category : #accessing }
GtGQLSnippetViewModel >> subscribeToSnippetModel [
	super subscribeToSnippetModel.
	self snippetModel weak
		when: GtGQLSnippetContextChanged
		send: #announce:
		to: self.
	self snippetModel weak
		when: GtGQLSnippetInputChanged
		send: #announce:
		to: self.
	self snippetModel weak
		when: GtGQLSnippetOperationChanged
		send: #announce:
		to: self
]

{ #category : #accessing }
GtGQLSnippetViewModel >> unsubscribeFromSnippetModel [
	super unsubscribeFromSnippetModel.
	self snippetModel unsubscribe: self
]
