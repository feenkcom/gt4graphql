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
GtGQLObject >> gtImplementedInterfacesFor: aView [
	<gtView>
	(self hasOptionAt: #implementedInterfaces) ifFalse: [ ^ aView empty ].

	^ (GtGQLSchema
		gtTypesFor: aView
		items: [ self implementedInterfaces asSortedCollection: [ :a :b | a name < b name ] ])
		title: 'Implemented Interfaces';
		priority: 45
]

{ #category : #accessing }
GtGQLObject >> gtPartOfUnionsFor: aView [
	<gtView>
	(self hasOptionAt: #partOfUnions) ifFalse: [ ^ aView empty ].

	^ (GtGQLSchema
		gtTypesFor: aView
		items: [ self partOfUnions asSortedCollection: [ :a :b | a name < b name ] ])
		title: 'Part of Unions';
		priority: 46
]

{ #category : #accessing }
GtGQLObject >> implementedInterfaces [
	^ self optionAt: #implementedInterfaces ifAbsent: [ #() ]
]

{ #category : #'api - initialization' }
GtGQLObject >> implementedInterfaces: aCollection [
	self optionAt: #implementedInterfaces put: aCollection
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

{ #category : #accessing }
GtGQLObject >> partOfUnions [
	^ self optionAt: #partOfUnions ifAbsent: [ #() ]
]

{ #category : #'api - initialization' }
GtGQLObject >> partOfUnions: aCollection [
	self optionAt: #partOfUnions put: aCollection
]
