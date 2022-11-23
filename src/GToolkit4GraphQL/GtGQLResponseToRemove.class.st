Class {
	#name : #GtGQLResponseToRemove,
	#superclass : #Object,
	#instVars : [
		'parent',
		'children',
		'type',
		'data'
	],
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #accessing }
GtGQLResponseToRemove >> addChild: aModel [
	aModel parent: self.
	self children add: aModel
]

{ #category : #accessing }
GtGQLResponseToRemove >> children [
	^ children
]

{ #category : #accessing }
GtGQLResponseToRemove >> children: anObject [
	children := anObject
]

{ #category : #accessing }
GtGQLResponseToRemove >> data [
	^ data
]

{ #category : #accessing }
GtGQLResponseToRemove >> data: anObject [
	data := anObject
]

{ #category : #initialization }
GtGQLResponseToRemove >> initialize [
	super initialize.
	children := OrderedCollection new
]

{ #category : #accessing }
GtGQLResponseToRemove >> parent [
	^ parent
]

{ #category : #accessing }
GtGQLResponseToRemove >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
GtGQLResponseToRemove >> type [
	^ type
]

{ #category : #accessing }
GtGQLResponseToRemove >> type: anObject [
	type := anObject
]
