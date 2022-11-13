Class {
	#name : #GtGQLSnippetViewModel,
	#superclass : #LeSnippetViewModel,
	#instVars : [
		'resultValue'
	],
	#category : #'GToolkit4GraphQL-Snippet-View-Model'
}

{ #category : #'private - announcement handling' }
GtGQLSnippetViewModel >> onResultVariableNameChanged: anAnnouncement [
	"self updateResultVariableBindings."

	self announce: anAnnouncement
]

{ #category : #'api - result variable' }
GtGQLSnippetViewModel >> resultValue [
	^ resultValue
]

{ #category : #'api - result variable' }
GtGQLSnippetViewModel >> resultValue: aResult [
	resultValue := aResult.

	self updateResultVariableBindings
]

{ #category : #'api - result variable' }
GtGQLSnippetViewModel >> resultVariableName [
	^ self snippetModel resultVariableName
]

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
		to: self.
	self snippetModel weak
		when: GtGQLSnippetResultVariableNameChanged
		send: #onResultVariableNameChanged:
		to: self
]

{ #category : #accessing }
GtGQLSnippetViewModel >> unsubscribeFromSnippetModel [
	super unsubscribeFromSnippetModel.
	self snippetModel unsubscribe: self
]

{ #category : #'api - result variable' }
GtGQLSnippetViewModel >> updateResultVariableBindings [
	| aName |
	aName := self resultVariableName.
	aName ifNil: [ ^ self ].
	aName ifEmpty: [ ^ self ].

	(self snippetBindings bindingOf: aName) value: self resultValue
]
