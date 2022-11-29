Class {
	#name : #GtGQLValueEnumeration,
	#superclass : #GtGQLValue,
	#category : #'GToolkit4GraphQL-Response'
}

{ #category : #accessing }
GtGQLValueEnumeration >> acceptVisitor: aVisitor [
	^ aVisitor visitGtGQLValueEnumeration: self
]

{ #category : #'gt - extensions' }
GtGQLValueEnumeration >> gtFieldsViewValueText [
	^ self data jsonObject
]

{ #category : #accessing }
GtGQLValueEnumeration >> value [
	^ self data ifNotNil: #jsonObject
]
