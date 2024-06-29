Class {
	#name : #GtGQLValueUnion,
	#superclass : #GtGQLValue,
	#instVars : [
		'actualItem'
	],
	#category : #'GToolkit4GraphQL-Report'
}

{ #category : #visiting }
GtGQLValueUnion >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLValueUnion: self
]

{ #category : #accessing }
GtGQLValueUnion >> actualItem [
	<return: #GtGQLValue>
	^ actualItem
]

{ #category : #accessing }
GtGQLValueUnion >> actualItem: aGtGQLValue [
	actualItem := aGtGQLValue
]

{ #category : #'gt - extensions' }
GtGQLValueUnion >> gtFieldsViewChildren [
	^ self actualItem ifNotNil: #gtFieldsViewChildren ifNil: [ #() ]
]

{ #category : #'gt - extensions' }
GtGQLValueUnion >> gtFieldsViewValueText [
	^ self actualItem
		ifNotNil: #gtFieldsViewValueText
		ifNil: [ self value asRopedText ]
]

{ #category : #accessing }
GtGQLValueUnion >> value [
	^ self data ifNotNil: #jsonObject
]
