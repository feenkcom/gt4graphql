Class {
	#name : #GtGQLResponseList,
	#superclass : #GtGQLResponseData,
	#instVars : [
		'items'
	],
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #visiting }
GtGQLResponseList >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLResponseList: self
]

{ #category : #accessing }
GtGQLResponseList >> addItem: aModel [
	items add: aModel
]

{ #category : #accessing }
GtGQLResponseList >> gtFieldsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].

	^ self class gtFieldsFor: aView items: [ self gtFieldsViewChildren ]
]

{ #category : #'gt - extensions' }
GtGQLResponseList >> gtFieldsViewChildren [
	^ items
		ifNil: [ #() ]
		ifNotNil: [ :aCollection | aCollection withIndexCollect: [ :aModel :anIndex | anIndex -> aModel ] ]
]

{ #category : #'gt - extensions' }
GtGQLResponseList >> gtFieldsViewValueText [
	^ items
		ifNil: [ '0 items' ]
		ifNotNil: [ :aCollection | 
			String
				streamContents: [ :aStream | 
					aStream
						print: aCollection size;
						space;
						nextPutAll: self baseType name asString;
						space;
						nextPutAll: ('item' asPluralBasedOn: aCollection size) ] ]
]

{ #category : #accessing }
GtGQLResponseList >> initialize [
	super initialize.
	
	items := OrderedCollection new.
]

{ #category : #accessing }
GtGQLResponseList >> itemType [
	^ self type responseItemType
]
