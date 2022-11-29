Class {
	#name : #GtGQLValueList,
	#superclass : #GtGQLValue,
	#instVars : [
		'items'
	],
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #visiting }
GtGQLValueList >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLValueList: self
]

{ #category : #accessing }
GtGQLValueList >> addItem: aModel [
	aModel parent: self.

	items add: aModel
]

{ #category : #converting }
GtGQLValueList >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]

{ #category : #accessing }
GtGQLValueList >> at: anIndex [
	^ items at: anIndex
]

{ #category : #accessing }
GtGQLValueList >> gtFieldsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].

	^ self class gtFieldsFor: aView items: [ self gtFieldsViewChildren ]
]

{ #category : #'gt - extensions' }
GtGQLValueList >> gtFieldsViewChildren [
	^ items
		ifNil: [ #() ]
		ifNotNil: [ :aCollection | aCollection withIndexCollect: [ :aModel :anIndex | anIndex -> aModel ] ]
]

{ #category : #'gt - extensions' }
GtGQLValueList >> gtFieldsViewValueText [
	^ items
		ifNil: [ '0 items' ]
		ifNotNil: [ :aCollection | 
			String
				streamContents: [ :aStream | 
					aStream print: aCollection size.
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
GtGQLValueList >> initialize [
	super initialize.
	
	items := OrderedCollection new.
]

{ #category : #accessing }
GtGQLValueList >> itemType [
	^ self type responseItemType
]

{ #category : #accessing }
GtGQLValueList >> listType [
	^ self type
]

{ #category : #printing }
GtGQLValueList >> printOn: aStream [
	super printOn: aStream.

	self listType ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: (self listType ifNotNil: #name);
		nextPut: $)
]

{ #category : #accessing }
GtGQLValueList >> size [
	^ items ifNotNil: #size ifNil: [ 0 ]
]

{ #category : #accessing }
GtGQLValueList >> userData [
	"Return data that is meaningful to users"

	^ self data
]
