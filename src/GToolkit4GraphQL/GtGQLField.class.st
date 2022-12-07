Class {
	#name : #GtGQLField,
	#superclass : #GtGQLModel,
	#instVars : [
		'parentType'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLField >> addArgument: aGQLField [
	self arguments add: aGQLField
]

{ #category : #accessing }
GtGQLField >> arguments [
	^ self propertyAt: #arguments ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #accessing }
GtGQLField >> arguments: aCollection [
	self propertyAt: #arguments put: aCollection
]

{ #category : #accessing }
GtGQLField >> deprecationReason [
	^ self propertyAt: #deprecationReason
]

{ #category : #accessing }
GtGQLField >> deprecationReason: anObject [
	self propertyAt: #deprecationReason put: anObject
]

{ #category : #accessing }
GtGQLField >> description [
	^ self propertyAt: #description
]

{ #category : #accessing }
GtGQLField >> description: anObject [
	self propertyAt: #description put: anObject
]

{ #category : #'gt - extensions' }
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

{ #category : #'gt - extensions' }
GtGQLField >> gtDepricationReasonFor: aView [
	<gtView>
	self isDeprecated ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Deprecation Reason';
		priority: 50;
		stencil: [ LeCoderTextElement coderElementFor: (self deprecationReason ifNil: [ '' ]) ]
]

{ #category : #'gt - extensions' }
GtGQLField >> gtDescriptionFor: aView [
	<gtView>
	self description ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Description';
		priority: 40;
		stencil: [ LeCoderTextElement coderElementFor: (self description ifNil: [ '' ]) ]
]

{ #category : #'gt - extensions' }
GtGQLField >> gtParentTypeFor: aView [
	<gtView>
	self parentType ifNil: [ ^ aView empty ].
	(self parentType baseType isKindOf: GtGQLComposite) ifFalse: [ ^ aView empty ].

	^ (GtGQLSchema gtTypesFor: aView items: [ {self parentType baseType} ])
		title: 'Parent Type';
		priority: 40;
		expandUpTo: 1;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Parent Type'
			tooltip: 'Inspect parent type'
			action: [ :aButton | aButton phlow spawnObject: self parentType baseType ]
]

{ #category : #accessing }
GtGQLField >> gtTypeFor: aView [
	<gtView>
	self type ifNil: [ ^ aView empty ].
	(self type baseType isKindOf: GtGQLComposite) ifFalse: [ ^ aView empty ].

	^ (GtGQLSchema gtTypesFor: aView items: [ {self type baseType} ])
		title: 'Type';
		expandUpTo: 1;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Type'
			tooltip: 'Inspect field type'
			action: [ :aButton | aButton phlow spawnObject: self type baseType ]
]

{ #category : #'gt - extensions' }
GtGQLField >> gtTypesNameText [
	| aText |
	aText := self name asRopedText.

	self isMetaField
		ifTrue: [ ^ aText foreground: BrGlamorousColors disabledButtonTextColor ].

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
GtGQLField >> isDeprecated [
	^ self propertyAt: #isDeprecated ifAbsent: [ false ]
]

{ #category : #accessing }
GtGQLField >> isDeprecated: anObject [
	self propertyAt: #isDeprecated put: anObject
]

{ #category : #testing }
GtGQLField >> isField [
	^ true
]

{ #category : #testing }
GtGQLField >> isMetaField [
	^ self name = GtGQLIntrospectionConstants metaMetaTypeName
]

{ #category : #testing }
GtGQLField >> isRequired [
	^ self type ifNotNil: #isRequired ifNil: [ false ]
]

{ #category : #accessing }
GtGQLField >> name [
	^ self propertyAt: #name
]

{ #category : #accessing }
GtGQLField >> name: aString [
	self propertyAt: #name put: aString
]

{ #category : #accessing }
GtGQLField >> parentType [
	^ parentType
]

{ #category : #accessing }
GtGQLField >> parentType: aType [
	self isMetaField ifTrue: [ ^ self ].

	self
		assert: [ parentType isNil ]
		description: [ 'Parent type can be set only once' ].
	self assert: [ aType isNotNil ] description: [ 'Parent type must be non-nil' ].

	parentType := aType
]

{ #category : #printing }
GtGQLField >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name.

	self type
		ifNotNil: [ :aType | 
			aStream
				nextPutAll: ': ';
				nextPutAll: aType name asString ].

	aStream nextPut: $)
]

{ #category : #accessing }
GtGQLField >> type [
	^ self propertyAt: #type
]

{ #category : #accessing }
GtGQLField >> type: aGQLType [
	self propertyAt: #type put: aGQLType
]
