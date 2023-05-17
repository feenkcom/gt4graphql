Class {
	#name : #GtGQLInterface,
	#superclass : #GtGQLComposite,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInterface class >> kindName [
	^ 'INTERFACE'
]

{ #category : #'gt - extensions' }
GtGQLInterface >> gtPossibleTypesFor: aView [
	<gtView>
	^ (GtGQLSchema gtTypesFor: aView items: [ self possibleTypes ])
		title: 'Possible types';
		priority: 11
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

{ #category : #'api - response' }
GtGQLInterface >> newValueUsing: aBuilder [
	^ aBuilder newValueInterfaceWithType: self
]

{ #category : #accessing }
GtGQLInterface >> possibleTypes [
	^ self propertyAt: #possibleTypes ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLInterface >> possibleTypes: anObject [
	self propertyAt: #possibleTypes put: anObject
]
