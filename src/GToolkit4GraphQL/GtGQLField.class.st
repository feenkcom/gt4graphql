Class {
	#name : #GtGQLField,
	#superclass : #Object,
	#instVars : [
		'name',
		'arguments',
		'type',
		'description',
		'isDeprecated',
		'deprecationReason'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLField >> addArgument: aGQLField [
	arguments add: aGQLField
]

{ #category : #accessing }
GtGQLField >> arguments [
	^ arguments
]

{ #category : #accessing }
GtGQLField >> arguments: aCollection [
	arguments := aCollection
]

{ #category : #accessing }
GtGQLField >> deprecationReason [
	^ deprecationReason
]

{ #category : #accessing }
GtGQLField >> deprecationReason: anObject [
	deprecationReason := anObject
]

{ #category : #accessing }
GtGQLField >> description [
	^ description
]

{ #category : #accessing }
GtGQLField >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtGQLField >> gtArgumentsFor: aView [
	<gtView>
	self arguments ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Arguments';
		priority: 20;
		items: [ self arguments ifNil: [ #() ] ];
		column: 'Name'
			text: [ :each | 
				| aText |
				aText := each name asRopedText.

				each isRequired ifTrue: [ aText bold ].

				each isDeprecated
					ifTrue: [ aText
							lineThroughDo: [ :anAttribute | anAttribute color: BrGlamorousColors disabledButtonTextColor ];
							append: ' (deprecated)' asRopedText;
							foreground: BrGlamorousColors disabledButtonTextColor;
							italic ].

				aText ];
		column: 'Type' text: [ :each | each type ifNotNil: #name ifNil: [ '' ] ];
		column: 'Default Value' text: [ :each | each defaultValue ifNil: [ '' ] ];
		column: 'Description'
			text: [ :each | each description ifNil: [ '' ] ]
			weight: 3
]

{ #category : #accessing }
GtGQLField >> gtTypeFor: aView [
	<gtView>
	type ifNil: [ ^ aView empty ].
	(type baseType isKindOf: GtGQLCompositeType) ifFalse: [ ^ aView empty ].
	^ (GtGQLSchema gtTypesFor: aView items: [ {type baseType} ])
		title: 'Type';
		expandUpTo: 1
]

{ #category : #'gt - extensions' }
GtGQLField >> gtTypesNameText [
	| aText |
	aText := self name asRopedText.

	self isRequired ifTrue: [ aText bold ].

	self isDeprecated ifTrue: [ aText lineThroughDo: [ :anAttribute |  ] ].

	self hasArguments
		ifTrue: [ | anArgumentsText |
			anArgumentsText := '(' asRopedText.
			self arguments
				do: [ :eachArgument | anArgumentsText append: eachArgument gtTypesNameText ]
				separatedBy: [ anArgumentsText append: ', ' asRopedText ].
			anArgumentsText append: ')' asRopedText.
			anArgumentsText foreground: BrGlamorousColors disabledButtonTextColor.
			aText append: anArgumentsText ].

	self isDeprecated
		ifTrue: [ aText
				italic;
				append: (' (deprecated)' asRopedText
						italic;
						foreground: BrGlamorousColors disabledButtonTextColor) ].

	^ aText
]

{ #category : #testing }
GtGQLField >> hasArguments [
	^ self arguments isNotNil and: [ self arguments isNotEmpty ]
]

{ #category : #accessing }
GtGQLField >> initialize [
	super initialize.
	arguments := OrderedCollection new.
	isDeprecated := false
]

{ #category : #accessing }
GtGQLField >> isDeprecated [
	^ isDeprecated
]

{ #category : #accessing }
GtGQLField >> isDeprecated: anObject [
	isDeprecated := anObject
]

{ #category : #testing }
GtGQLField >> isRequired [
	^ self type ifNotNil: #isRequired ifNil: [ false ]
]

{ #category : #accessing }
GtGQLField >> name [
	^ name
]

{ #category : #accessing }
GtGQLField >> name: aString [
	name := aString
]

{ #category : #printing }
GtGQLField >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtGQLField >> type [
	^ type
]

{ #category : #accessing }
GtGQLField >> type: aGQLType [
	type := aGQLType
]
