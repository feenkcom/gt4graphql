Class {
	#name : #GtGQLPreparationProblem,
	#superclass : #GtGQLBasicResult,
	#instVars : [
		'exception',
		'messageText'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLPreparationProblem >> exception [
	^ exception
]

{ #category : #accessing }
GtGQLPreparationProblem >> exception: anObject [
	exception := anObject
]

{ #category : #accessing }
GtGQLPreparationProblem >> messageText [
	^ messageText
]

{ #category : #accessing }
GtGQLPreparationProblem >> messageText: anObject [
	messageText := anObject
]
