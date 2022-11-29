"
nil
"
Class {
	#name : #GtGQLReport,
	#superclass : #Object,
	#instVars : [
		'context',
		'type',
		'value',
		'name'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLReport >> baseType [
	^ self type ifNotNil: #baseType
]

{ #category : #'api - report names' }
GtGQLReport >> commonReportNames [
	<gtGraphQLName>
	self value ifNil: [ ^ nil ].
	self value isValueObject ifFalse: [ ^ nil ].
	self value
		fieldNamed: #name
		ifPresent: [ :aValue | ^ aValue value ]
		ifAbsent: [ nil ].
	self value
		fieldNamed: #title
		ifPresent: [ :aValue | ^ aValue value ]
		ifAbsent: [ nil ].
	^ nil
]

{ #category : #accessing }
GtGQLReport >> context [
	^ context
]

{ #category : #accessing }
GtGQLReport >> context: anObject [
	context := anObject
]

{ #category : #private }
GtGQLReport >> createName [
	<return: #String>
	^ GtQGLReportNameBuilder new
		report: self;
		build;
		name
]

{ #category : #accessing }
GtGQLReport >> data [
	<return: #GtJson>
	^ self value ifNotNil: #data
]

{ #category : #accessing }
GtGQLReport >> gtDataJsonStringFor: aView [
	<gtView>
	self value ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'JSON String';
		priority: 60;
		object: [ self value ];
		view: #gtDataJsonStringFor:
]

{ #category : #'gt - extensions' }
GtGQLReport >> gtTypeFor: aView [
	<gtView>
	^ (GtGQLSchema gtTypesFor: aView items: [ {self type baseType} ])
		title: 'Type';
		priority: 71;
		expandUpTo: 1
]

{ #category : #'gt - extensions' }
GtGQLReport >> gtValueFor: aView [
	<gtView>
	self value ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Fields';
		priority: 70;
		object: [ self value ];
		view: #gtFieldsFor:
]

{ #category : #accessing }
GtGQLReport >> id [
	<return: #String>
	^ self value
		ifNotNil: [ :aValue | aValue isValueObject ifTrue: [ aValue id ] ifFalse: [ nil ] ]
]

{ #category : #testing }
GtGQLReport >> isSuccess [
	"Polymorphic to {{gtClass:GtGQLReport}}"

	^ true
]

{ #category : #accessing }
GtGQLReport >> name [
	<return: #String>
	^ name ifNil: [ name := self createName ]
]

{ #category : #'instance creation' }
GtGQLReport >> newReportWithValue: aValue [
	^ self class new
		context: self context;
		type: aValue type;
		value: aValue
]

{ #category : #printing }
GtGQLReport >> printOn: aStream [
	super printOn: aStream.

	self type ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name asString;
		nextPutAll: ': ';
		nextPutAll: self baseType name asString;
		nextPut: $)
]

{ #category : #'api - initialization' }
GtGQLReport >> result: aResult [
	self context: aResult context.
	self value: aResult value.
	self type: self value type
]

{ #category : #accessing }
GtGQLReport >> type [
	^ type
]

{ #category : #accessing }
GtGQLReport >> type: anObject [
	type := anObject
]

{ #category : #accessing }
GtGQLReport >> value [
	<return: #GtGQLValue>
	^ value
]

{ #category : #accessing }
GtGQLReport >> value: anObject [
	value := anObject
]
