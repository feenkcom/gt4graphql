Class {
	#name : #GtGQLResponseScalar,
	#superclass : #GtGQLResponseData,
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #visiting }
GtGQLResponseScalar >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLResponseScalar: self
]

{ #category : #'gt - extensions' }
GtGQLResponseScalar >> gtFieldsViewValueText [
	^ self value asRopedText
]

{ #category : #'gt - extensions' }
GtGQLResponseScalar >> gtValueFor: aView [
	<gtView>
	self data ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Value';
		priority: 10;
		object: [ self value ];
		view: #gtLiveFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Value'
			tooltip: 'Inspect value'
			action: [ :aButton | aButton phlow spawnObject: self value ]
]

{ #category : #accessing }
GtGQLResponseScalar >> stringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Value';
		priority: 1;
		accessor: (MAPluggableAccessor
				read: [ :aModel | aModel value ]
				write: [ :aModel :aValue | aModel value: aValue ])
]

{ #category : #accessing }
GtGQLResponseScalar >> value [
	^ self data ifNotNil: #jsonObject
]
