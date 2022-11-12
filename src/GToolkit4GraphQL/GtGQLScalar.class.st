Class {
	#name : #GtGQLScalar,
	#superclass : #GtGQLType,
	#classVars : [
		'Boolean',
		'Float',
		'Id',
		'Int',
		'String'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLScalar class >> boolean [
	^ Boolean
		ifNil: [ Boolean := self new
					name: 'Boolean';
					yourself ]
]

{ #category : #accessing }
GtGQLScalar class >> float [
	^ Float
		ifNil: [ Float := self new
					name: 'Float';
					yourself ]
]

{ #category : #accessing }
GtGQLScalar class >> id [
	^ Id
		ifNil: [ Id := self new
					name: 'ID';
					yourself ]
]

{ #category : #accessing }
GtGQLScalar class >> int [
	^ Int
		ifNil: [ Int := self new
					name: 'Int';
					yourself ]
]

{ #category : #accessing }
GtGQLScalar class >> kindName [
	^ 'SCALAR'
]

{ #category : #accessing }
GtGQLScalar class >> string [
	^ String
		ifNil: [ String := self new
					name: 'String';
					yourself ]
]

{ #category : #testing }
GtGQLScalar >> isBoolean [
	^ self = Boolean
]

{ #category : #testing }
GtGQLScalar >> isScalar [
	^ true
]
