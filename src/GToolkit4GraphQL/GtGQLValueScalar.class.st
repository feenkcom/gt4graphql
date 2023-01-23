Class {
	#name : #GtGQLValueScalar,
	#superclass : #GtGQLValue,
	#category : #'GToolkit4GraphQL-Report'
}

{ #category : #visiting }
GtGQLValueScalar >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLValueScalar: self
]

{ #category : #'gt - extensions' }
GtGQLValueScalar >> gtFieldsViewCanHaveChildren [
	^ false
]

{ #category : #'gt - extensions' }
GtGQLValueScalar >> gtFieldsViewValueText [
	^ self value asRopedText
]

{ #category : #'gt - extensions' }
GtGQLValueScalar >> gtValueFor: aView [
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
GtGQLValueScalar >> stringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Value';
		priority: 1;
		accessor: (MAPluggableAccessor
				read: [ :aModel | aModel value ]
				write: [ :aModel :aValue | aModel value: aValue ])
]

{ #category : #accessing }
GtGQLValueScalar >> value [
	^ self data ifNotNil: #jsonObject
]
