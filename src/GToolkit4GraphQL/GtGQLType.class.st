Class {
	#name : #GtGQLType,
	#superclass : #GtGQLModel,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLType class >> kindName [
	^ self name
]

{ #category : #factory }
GtGQLType class >> typeClassForKindName: aName [
	| anUppercase |
	anUppercase := aName asUppercase.

	self
		allSubclassesDo: [ :aClass | 
			(aClass isAbstract not and: [ aClass kindName = anUppercase ])
				ifTrue: [ ^ aClass ] ].

	self error: ('Cannot find type class for kind name: {1}' format: {aName})
]

{ #category : #accessing }
GtGQLType >> baseType [
	^ self
]

{ #category : #accessing }
GtGQLType >> description [
	^ self propertyAt: #description
]

{ #category : #accessing }
GtGQLType >> description: anObject [
	self propertyAt: #description put: anObject
]

{ #category : #accessing }
GtGQLType >> fields [
	^ #()
]

{ #category : #'gt - extensions' }
GtGQLType >> gtDescriptionFor: aView [
	<gtView>
	self description ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Description';
		priority: 40;
		stencil: [ LeCoderTextElement coderElementFor: (self description ifNil: [ '' ]) ]
]

{ #category : #'gt - extensions' }
GtGQLType >> gtTypesNameText [
	^ self name
]

{ #category : #testing }
GtGQLType >> isBoolean [
	^ false
]

{ #category : #testing }
GtGQLType >> isComposite [
	^ false
]

{ #category : #testing }
GtGQLType >> isDeprecated [
	^ false
]

{ #category : #testing }
GtGQLType >> isList [
	^ false
]

{ #category : #testing }
GtGQLType >> isNonNullable [
	^ false
]

{ #category : #testing }
GtGQLType >> isObjectType [
	^ false
]

{ #category : #testing }
GtGQLType >> isPrimitive [
	^ false
]

{ #category : #testing }
GtGQLType >> isRequired [
	^ false
]

{ #category : #testing }
GtGQLType >> isScalar [
	^ false
]

{ #category : #accessing }
GtGQLType >> kindName [
	^ self class kindName
]

{ #category : #accessing }
GtGQLType >> name [
	^ self propertyAt: #name
]

{ #category : #accessing }
GtGQLType >> name: aString [
	self propertyAt: #name put: aString
]

{ #category : #'api - response' }
GtGQLType >> newValueUsing: aType [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtGQLType >> nonNullableType [
	^ self
]

{ #category : #printing }
GtGQLType >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name asString.

	self printTypeOn: aStream.

	aStream nextPut: $)
]

{ #category : #printing }
GtGQLType >> printTypeOn: aStream [ 
]

{ #category : #accessing }
GtGQLType >> typeName [
	^ self class name asString allButFirst: 5
]
