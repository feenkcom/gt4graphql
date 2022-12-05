Class {
	#name : #GtGQLPathAccessor,
	#superclass : #Object,
	#instVars : [
		'builder'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLPathAccessor >> builder [
	<return: #GtGQLQueryPathBuilder>
	^ builder
]

{ #category : #accessing }
GtGQLPathAccessor >> builder: anObject [
	builder := anObject
]

{ #category : #'api - accessing' }
GtGQLPathAccessor >> startType [
	<return: #GtGQLObject>
	^ self subclassResponsibility
]

{ #category : #'api - writing' }
GtGQLPathAccessor >> write: aStopType paths: aCollection [
	^ self subclassResponsibility
]
