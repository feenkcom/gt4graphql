Class {
	#name : #GtGQLTypeStep,
	#superclass : #Object,
	#instVars : [
		'type',
		'field'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLTypeStep >> field [
	^ field
]

{ #category : #accessing }
GtGQLTypeStep >> field: anObject [
	field := anObject
]

{ #category : #accessing }
GtGQLTypeStep >> fieldBaseType [
	^ self fieldType ifNotNil: #baseType
]

{ #category : #accessing }
GtGQLTypeStep >> fieldName [
	^ self field name
]

{ #category : #accessing }
GtGQLTypeStep >> fieldType [
	^ self field ifNotNil: #type
]

{ #category : #accessing }
GtGQLTypeStep >> fieldTypeName [
	^ self fieldType name
]

{ #category : #accessing }
GtGQLTypeStep >> fullName [
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: self type name asString;
				nextPutAll: ' >> #';
				nextPutAll: self field name asString;
				nextPutAll: ': ';
				nextPutAll: self fieldBaseType name asString ]
]

{ #category : #accessing }
GtGQLTypeStep >> gtFieldTypeFor: aView [
	<gtView>
	^ (GtGQLSchema gtTypesFor: aView items: [ {self fieldBaseType} ])
		title: 'Field Type';
		expandUpTo: 1;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Field Type'
			tooltip: 'Inspect field type'
			action: [ :aButton | aButton phlow spawnObject: self fieldBaseType ]
]

{ #category : #printing }
GtGQLTypeStep >> printOn: aStream [
	super printOn: aStream.

	self type ifNil: [ ^ self ].
	self field ifNil: [ ^ self ].


	aStream
		nextPut: $(;
		nextPutAll: self type name asString;
		nextPutAll: ' >> #';
		nextPutAll: self field name asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLTypeStep >> type [
	^ type
]

{ #category : #accessing }
GtGQLTypeStep >> type: anObject [
	type := anObject
]

{ #category : #accessing }
GtGQLTypeStep >> typeName [
	^ self type name
]
