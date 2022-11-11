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
				each isDeprecated
					ifTrue: [ each name asRopedText
							append: (' (deprecated)' asRopedText
									foreground: BrGlamorousColors disabledButtonTextColor) ]
					ifFalse: [ each name ] ];
		column: 'Type' text: [ :each | each type ifNotNil: #name ifNil: [ '' ] ];
		column: 'Default Value' text: [ :each | each defaultValue ifNil: [ '' ] ];
		column: 'Description'
			text: [ :each | each description ifNil: [ '' ] ]
			weight: 3
]

{ #category : #accessing }
GtGQLField >> gtTypeFor: aView [
	<gtView>
	(type baseType isKindOf: GtGQLCompositeType) ifFalse: [ ^ aView empty ].
	^ (GtGQLSchema gtTypesFor: aView items: [ {type baseType} ]) title: 'Type'
]

{ #category : #'gt - extensions' }
GtGQLField >> gtTypesNameText [
	| aText |
	aText := self name asRopedText.

	self hasArguments
		ifTrue: [ | anArgumentsText |
			anArgumentsText := '(' asRopedText.
			self arguments
				do: [ :eachArgument | 
					| eachText |
					eachText := eachArgument name asRopedText.
					eachArgument isRequired
						ifTrue: [ eachText
								append: '!' asRopedText;
								bold ].
					anArgumentsText append: eachText ]
				separatedBy: [ anArgumentsText append: ', ' asRopedText ].
			anArgumentsText append: ')' asRopedText.
			anArgumentsText foreground: BrGlamorousColors disabledButtonTextColor.
			aText append: anArgumentsText ].

	self isDeprecated
		ifTrue: [ aText
				lineThroughDo: [ :anAttribute |  ];
				italic;
				append: (' (deprecated)' asRopedText
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
