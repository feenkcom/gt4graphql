Class {
	#name : #GtGQLInterface,
	#superclass : #GtGQLCompositeType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInterface class >> kindName [
	^ 'INTERFACE'
]

{ #category : #accessing }
GtGQLInterface >> interfaces [
	^ self propertyAt: #interfaces ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLInterface >> interfaces: aCollection [
	self propertyAt: #interfaces put: aCollection
]

{ #category : #testing }
GtGQLInterface >> isInterface [
	^ true
]

{ #category : #'api - introspection' }
GtGQLInterface >> isTypenameIntrospection [
	^ true
]

{ #category : #accessing }
GtGQLInterface >> possibleTypes [
	^ self propertyAt: #possibleTypes ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLInterface >> possibleTypes: anObject [
	self propertyAt: #possibleTypes put: anObject
]
