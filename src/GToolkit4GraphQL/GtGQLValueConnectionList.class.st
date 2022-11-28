Class {
	#name : #GtGQLValueConnectionList,
	#superclass : #GtGQLValueList,
	#instVars : [
		'itemType',
		'listData',
		'listType'
	],
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #visiting }
GtGQLValueConnectionList >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLValueConnectionObject: self
]

{ #category : #accessing }
GtGQLValueConnectionList >> itemType [
	^ itemType
]

{ #category : #accessing }
GtGQLValueConnectionList >> itemType: anObject [
	itemType := anObject
]

{ #category : #accessing }
GtGQLValueConnectionList >> listData [
	^ listData
]

{ #category : #accessing }
GtGQLValueConnectionList >> listData: anObject [
	listData := anObject
]

{ #category : #accessing }
GtGQLValueConnectionList >> listType [
	^ listType
]

{ #category : #accessing }
GtGQLValueConnectionList >> listType: anObject [
	listType := anObject
]

{ #category : #accessing }
GtGQLValueConnectionList >> userData [
	"Return data that is meaningful to users"

	^ self listData
]

{ #category : #accessing }
GtGQLValueConnectionList >> userType [
	"Return type that is meaningful to users"

	^ self listType
]