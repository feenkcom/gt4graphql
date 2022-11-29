Class {
	#name : #GtGQLValueConnectionList,
	#superclass : #GtGQLValueList,
	#instVars : [
		'itemType',
		'listData',
		'listType',
		'totalCount',
		'listStep'
	],
	#category : #'GToolkit4GraphQL-Report'
}

{ #category : #visiting }
GtGQLValueConnectionList >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLValueConnectionObject: self
]

{ #category : #'gt - extensions' }
GtGQLValueConnectionList >> gtFieldsViewValueText [
	^ items
		ifNil: [ '0 items' ]
		ifNotNil: [ :aCollection | 
			String
				streamContents: [ :aStream | 
					aStream print: aCollection size.

					self totalCount
						ifNotNil: [ :aCount | 
							aStream
								nextPutAll: ' out of ';
								print: aCount ].

					self itemType
						ifNotNil: [ :aType | 
							aStream
								space;
								nextPutAll: aType name asString ].
					aStream
						space;
						nextPutAll: ('item' asPluralBasedOn: aCollection size) ] ]
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
GtGQLValueConnectionList >> listStep [
	^ listStep
]

{ #category : #accessing }
GtGQLValueConnectionList >> listStep: anObject [
	listStep := anObject
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
GtGQLValueConnectionList >> totalCount [
	^ totalCount ifNil: [ super size ]
]

{ #category : #accessing }
GtGQLValueConnectionList >> totalCount: anObject [
	totalCount := anObject
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
