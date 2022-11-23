Class {
	#name : #GtGQLResponseData,
	#superclass : #Object,
	#instVars : [
		'type',
		'context',
		'data',
		'parent'
	],
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #'gt - extensions' }
GtGQLResponseData class >> gtFieldsFor: aView items: aBlock [

	^ aView columnedTree
		title: 'Fields';
		priority: 10;
		items: aBlock;
		children: [ :anAssoc | anAssoc value gtFieldsViewChildren ];
		expandUpTo: 1;
		column: 'Name'
			text: #key
			weight: 0.5;
		column: 'Value' text: [ :anAssoc | anAssoc value gtFieldsViewValueText ];
		send: #value
]

{ #category : #testing }
GtGQLResponseData class >> isAbstract [
	^ self name = #GtGQLResponseData
]

{ #category : #visiting }
GtGQLResponseData >> acceptVisitor: aVisitor [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtGQLResponseData >> baseType [
	^ self type ifNotNil: #baseType
]

{ #category : #accessing }
GtGQLResponseData >> context [
	^ context
]

{ #category : #accessing }
GtGQLResponseData >> context: anObject [
	context := anObject
]

{ #category : #accessing }
GtGQLResponseData >> data [
	^ data
]

{ #category : #accessing }
GtGQLResponseData >> data: anObject [
	data := anObject
]

{ #category : #'gt - extensions' }
GtGQLResponseData >> gtFieldsViewChildren [
	^ #()
]

{ #category : #accessing }
GtGQLResponseData >> parent [
	^ parent
]

{ #category : #accessing }
GtGQLResponseData >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
GtGQLResponseData >> type [
	^ type
]

{ #category : #accessing }
GtGQLResponseData >> type: anObject [
	type := anObject
]
