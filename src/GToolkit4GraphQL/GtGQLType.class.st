Class {
	#name : #GtGQLType,
	#superclass : #Object,
	#instVars : [
		'name',
		'description'
	],
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
	^ description
]

{ #category : #accessing }
GtGQLType >> description: anObject [
	description := anObject
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

{ #category : #testing }
GtGQLType >> isList [
	^ false
]

{ #category : #testing }
GtGQLType >> isNonNullable [
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
	^ name
]

{ #category : #accessing }
GtGQLType >> name: aString [
	name := aString
]

{ #category : #printing }
GtGQLType >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLType >> typeName [
	^ self class name asString allButFirst: 5
]
