Class {
	#name : #GtGQLObjectType,
	#superclass : #GtGQLCompositeType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLObjectType class >> kindName [
	^ 'OBJECT'
]

{ #category : #accessing }
GtGQLObjectType >> interfaces [
	^ self propertyAt: #interfaces ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLObjectType >> interfaces: aCollection [
	self propertyAt: #interfaces put: aCollection
]

{ #category : #accessing }
GtGQLObjectType >> isObjectType [
	^ true
]

{ #category : #'api - response' }
GtGQLObjectType >> newResponseModelInstanceUsing: aBuilder [
	^ aBuilder newResponseModelObjectInstanceWithType: self
]
