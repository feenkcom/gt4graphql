Class {
	#name : #GtGQLResponseObject,
	#superclass : #GtGQLResponseData,
	#instVars : [
		'fields'
	],
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #visiting }
GtGQLResponseObject >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLResponseObject: self
]

{ #category : #'api - initialization' }
GtGQLResponseObject >> atFieldNamed: aName put: aModel [
	self
		assert: [ (fields includesKey: aName) not ]
		description: [ 'Cannot add twice a same field value' ].

	aModel parent: self.

	fields at: aName put: aModel
]

{ #category : #'gt - extensions' }
GtGQLResponseObject >> gtFieldsFor: aView [
	<gtView>
	fields ifNil: [ ^ aView empty ].

	^ self class gtFieldsFor: aView items: [ fields associations ]
]

{ #category : #'gt - extensions' }
GtGQLResponseObject >> gtFieldsViewChildren [
	^ fields associations
]

{ #category : #'gt - extensions' }
GtGQLResponseObject >> gtFieldsViewValueText [
	^ self type name
]

{ #category : #initialization }
GtGQLResponseObject >> initialize [
	super initialize.
	fields := Dictionary new
]

{ #category : #accessing }
GtGQLResponseObject >> userData [
	"Return data that is meaningful to users"

	^ self data
]

{ #category : #accessing }
GtGQLResponseObject >> userType [
	"Return type that is meaningful to users"

	^ self baseType
]
