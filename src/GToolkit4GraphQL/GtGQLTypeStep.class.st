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

{ #category : #'gt - extensions' }
GtGQLTypeStep >> gtFieldArgumentsFor: aView [
	<gtView>
	self field ifNil: [ ^ aView empty ].
	self field arguments ifEmpty: [ ^ aView empty ].

	^ aView forward
		title: 'Field Arguments';
		priority: 20;
		object: [ self field ];
		view: #gtArgumentsFor:
]

{ #category : #'gt - extensions' }
GtGQLTypeStep >> gtFieldDescriptionFor: aView [
	<gtView>
	self field ifNil: [ ^ aView empty ].
	self field description ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Field Description';
		priority: 40;
		object: [ self field ];
		view: #gtDescriptionFor:
]

{ #category : #'gt - extensions' }
GtGQLTypeStep >> gtFieldRepricationReasonFor: aView [
	<gtView>
	self isDeprecated ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Deprecation Reason';
		priority: 50;
		object: [ self field ];
		view: #gtRepricationReasonFor:
]

{ #category : #'gt - extensions' }
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

{ #category : #testing }
GtGQLTypeStep >> isDeprecated [
	^ self field isDeprecated
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
