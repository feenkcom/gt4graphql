Class {
	#name : #GtGQLResponseConnectionList,
	#superclass : #GtGQLResponseList,
	#instVars : [
		'itemType',
		'listData',
		'listType'
	],
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #visiting }
GtGQLResponseConnectionList >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLResponseConnectionObject: self
]

{ #category : #accessing }
GtGQLResponseConnectionList >> itemType [
	^ itemType
]

{ #category : #accessing }
GtGQLResponseConnectionList >> itemType: anObject [
	itemType := anObject
]

{ #category : #accessing }
GtGQLResponseConnectionList >> listData [
	^ listData
]

{ #category : #accessing }
GtGQLResponseConnectionList >> listData: anObject [
	listData := anObject
]

{ #category : #accessing }
GtGQLResponseConnectionList >> listType [
	^ listType
]

{ #category : #accessing }
GtGQLResponseConnectionList >> listType: anObject [
	listType := anObject
]

{ #category : #accessing }
GtGQLResponseConnectionList >> userData [
	"Return data that is meaningful to users"

	^ self listData
]

{ #category : #accessing }
GtGQLResponseConnectionList >> userType [
	"Return type that is meaningful to users"

	^ self listType
]
