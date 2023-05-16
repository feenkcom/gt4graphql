Class {
	#name : #GtGQLValue,
	#superclass : #Object,
	#instVars : [
		'type',
		'context',
		'data',
		'parent',
		'step'
	],
	#category : #'GToolkit4GraphQL-Report'
}

{ #category : #'gt - extensions' }
GtGQLValue class >> gtFieldsFor: aView items: aBlock [

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
GtGQLValue class >> isAbstract [
	^ self name = #GtGQLValue
]

{ #category : #visiting }
GtGQLValue >> acceptVisitor: aVisitor [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtGQLValue >> baseType [
	^ self type ifNotNil: #baseType
]

{ #category : #accessing }
GtGQLValue >> context [
	^ context
]

{ #category : #accessing }
GtGQLValue >> context: anObject [
	context := anObject
]

{ #category : #accessing }
GtGQLValue >> data [
	<return: #GtJson>
	^ data
]

{ #category : #accessing }
GtGQLValue >> data: anObject [
	data := anObject
]

{ #category : #accessing }
GtGQLValue >> gtDataJsonStringFor: aView [
	<gtView>
	self data ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'JSON string';
		priority: 20;
		object: [ self data ];
		view: #gtJsonStringFor:
]

{ #category : #'gt - extensions' }
GtGQLValue >> gtFieldsViewCanHaveChildren [
	^ true
]

{ #category : #'gt - extensions' }
GtGQLValue >> gtFieldsViewChildren [
	^ #()
]

{ #category : #testing }
GtGQLValue >> isSuccess [
	"Polymorphic to {{gtClass:GtGQLReport}}"

	^ true
]

{ #category : #testing }
GtGQLValue >> isValueObject [
	^ false
]

{ #category : #accessing }
GtGQLValue >> parent [
	^ parent
]

{ #category : #accessing }
GtGQLValue >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
GtGQLValue >> schema [
	<return: #GtGQLSchema>
	^ self context ifNotNil: #schema
]

{ #category : #accessing }
GtGQLValue >> step [
	^ step
]

{ #category : #accessing }
GtGQLValue >> step: anObject [
	step := anObject
]

{ #category : #accessing }
GtGQLValue >> type [
	^ type
]

{ #category : #accessing }
GtGQLValue >> type: anObject [
	type := anObject
]
