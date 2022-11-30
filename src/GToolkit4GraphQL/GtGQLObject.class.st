Class {
	#name : #GtGQLObject,
	#superclass : #GtGQLComposite,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLObject class >> kindName [
	^ 'OBJECT'
]

{ #category : #accessing }
GtGQLObject >> interfaces [
	^ self propertyAt: #interfaces ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLObject >> interfaces: aCollection [
	self propertyAt: #interfaces put: aCollection
]

{ #category : #accessing }
GtGQLObject >> isObjectType [
	^ true
]

{ #category : #'api - response' }
GtGQLObject >> newValueUsing: aBuilder [
	^ aBuilder newValueObjectWithType: self
]
