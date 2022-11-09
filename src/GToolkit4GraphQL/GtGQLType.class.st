Class {
	#name : #GtGQLType,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #GToolkit4GraphQL
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
