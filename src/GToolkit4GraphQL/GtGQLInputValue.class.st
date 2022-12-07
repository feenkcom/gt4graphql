Class {
	#name : #GtGQLInputValue,
	#superclass : #GtGQLModel,
	#instVars : [
		'parentType'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInputValue >> defaultValue [
	^ self propertyAt: #defaultValue ifAbsent: [ nil ]
]

{ #category : #accessing }
GtGQLInputValue >> defaultValue: anObject [
	self propertyAt: #defaultValue put: anObject
]

{ #category : #'api - paths' }
GtGQLInputValue >> defaultVariableValue [
	^ Dictionary new
]

{ #category : #accessing }
GtGQLInputValue >> deprecationReason [
	^ self propertyAt: #deprecationReason
]

{ #category : #accessing }
GtGQLInputValue >> deprecationReason: anObject [
	self propertyAt: #deprecationReason put: anObject
]

{ #category : #accessing }
GtGQLInputValue >> description [
	^ self propertyAt: #description
]

{ #category : #accessing }
GtGQLInputValue >> description: anObject [
	self propertyAt: #description put: anObject
]

{ #category : #'gt - extensions' }
GtGQLInputValue >> gtDepricationReasonFor: aView [
	<gtView>
	self isDeprecated ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Deprecation Reason';
		priority: 50;
		stencil: [ LeCoderTextElement coderElementFor: (self deprecationReason ifNil: [ '' ]) ]
]

{ #category : #'gt - extensions' }
GtGQLInputValue >> gtDescriptionFor: aView [
	<gtView>
	self description ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Description';
		priority: 40;
		stencil: [ LeCoderTextElement coderElementFor: (self description ifNil: [ '' ]) ]
]

{ #category : #'gt - extensions' }
GtGQLInputValue >> gtParentTypeFor: aView [
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
GtGQLInputValue >> gtTypeFor: aView [
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
GtGQLInputValue >> gtTypesNameText [
	| aText |
	aText := self name asRopedText.

	self isRequired ifTrue: [ aText bold ].

	self isDeprecated ifTrue: [ aText lineThroughDo: [ :anAttribute |  ] ].

	self isDeprecated
		ifTrue: [ aText
				italic;
				append: (' (deprecated)' asRopedText
						italic;
						foreground: BrGlamorousColors disabledButtonTextColor) ].

	^ aText
]

{ #category : #accessing }
GtGQLInputValue >> isDeprecated [
	^ self propertyAt: #isDeprecated ifAbsent: [ false ]
]

{ #category : #accessing }
GtGQLInputValue >> isDeprecated: anObject [
	self propertyAt: #isDeprecated put: anObject
]

{ #category : #testing }
GtGQLInputValue >> isRequired [
	^ self type ifNotNil: #isRequired ifNil: [ false ]
]

{ #category : #accessing }
GtGQLInputValue >> name [
	^ self propertyAt: #name
]

{ #category : #accessing }
GtGQLInputValue >> name: aString [
	self propertyAt: #name put: aString
]

{ #category : #accessing }
GtGQLInputValue >> parentType [
	^ parentType
]

{ #category : #accessing }
GtGQLInputValue >> parentType: anObject [
	parentType := anObject
]

{ #category : #printing }
GtGQLInputValue >> printOn: aStream [
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

	self defaultValue
		ifNotNil: [ :aValue | 
			aStream
				nextPutAll: ' = ';
				print: aValue ].

	aStream nextPut: $)
]

{ #category : #accessing }
GtGQLInputValue >> type [
	^ self propertyAt: #type
]

{ #category : #accessing }
GtGQLInputValue >> type: aGQLType [
	self propertyAt: #type put: aGQLType
]
