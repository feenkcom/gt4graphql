Class {
	#name : #GtGQLSnippetViewModel,
	#superclass : #LeSnippetViewModel,
	#instVars : [
		'resultValue'
	],
	#category : #'GToolkit4GraphQL-Snippet-View-Model'
}

{ #category : #'api - accessing' }
GtGQLSnippetViewModel >> context [
	<return: #GtGQLContext>
	^ self snippetModel contextUsing: sharedContext
]

{ #category : #private }
GtGQLSnippetViewModel >> newResultValue [
	^ GtGQLPreparation new
		context: self context;
		operation: self snippetModel operation input: self snippetModel input
]

{ #category : #'private - announcement handling' }
GtGQLSnippetViewModel >> onInputChanged: anAnnouncement [
	self resultValue: self newResultValue.

	self announce: anAnnouncement
]

{ #category : #'private - announcement handling' }
GtGQLSnippetViewModel >> onOperationChanged: anAnnouncement [
	self resultValue: self newResultValue.

	self announce: anAnnouncement
]

{ #category : #'private - announcement handling' }
GtGQLSnippetViewModel >> onResultVariableNameChanged: anAnnouncement [
	| aName |
	aName := self resultVariableName.
	aName ifNil: [ ^ self ].
	aName ifEmpty: [ ^ self ].

	anAnnouncement oldName
		ifNotNil: [ self snippetBindings removeBindingOf: anAnnouncement oldName ].

	(self snippetBindings bindingOf: aName) value: self resultValue.

	self announce: anAnnouncement
]

{ #category : #'private - announcement handling' }
GtGQLSnippetViewModel >> onSnippetContextChanged: anAnnouncement [
	self resultValue: self newResultValue.

	self announce: anAnnouncement
]

{ #category : #'api - snippet model' }
GtGQLSnippetViewModel >> onSnippetModelChanged [
	super onSnippetModelChanged.

	self updateResultVariableBindings
]

{ #category : #'api - accessing' }
GtGQLSnippetViewModel >> query [
	<return: #GtGQLQuery>
	^ self resultValue query
]

{ #category : #'api - result variable' }
GtGQLSnippetViewModel >> resultValue [
	^ resultValue ifNil: [ resultValue := self newResultValue ]
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

{ #category : #'api - shared context' }
GtGQLSnippetViewModel >> sharedSnippetContext: aLeSharedSnippetContext [
	super sharedSnippetContext: aLeSharedSnippetContext.
	
	self updateResultVariableBindings
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
		send: #onSnippetContextChanged:
		to: self.
	self snippetModel weak
		when: GtGQLSnippetOperationChanged
		send: #onOperationChanged:
		to: self.
	self snippetModel weak
		when: GtGQLSnippetInputChanged
		send: #onInputChanged:
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
