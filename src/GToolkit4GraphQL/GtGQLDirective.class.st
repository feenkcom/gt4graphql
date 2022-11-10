Class {
	#name : #GtGQLDirective,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'locations',
		'arguments',
		'isRepeatable'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLDirective >> arguments [
	^ arguments
]

{ #category : #accessing }
GtGQLDirective >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
GtGQLDirective >> description [
	^ description
]

{ #category : #accessing }
GtGQLDirective >> description: anObject [
	description := anObject
]

{ #category : #'gt - extensions' }
GtGQLDirective >> gtArgumentsFor: aView [
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
		column: 'Default Value' text: [ :each | each defaultValue ifNil: [ '' ] ];
		column: 'Description'
			text: [ :each | each description ifNil: [ '' ] ]
			weight: 3
]

{ #category : #'gt - extensions' }
GtGQLDirective >> gtDescriptionFor: aView [
	<gtView>
	self description ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Description';
		priority: 40;
		stencil: [ LeCoderTextElement coderElementFor: (self description ifNil: [ '' ]) ]
]

{ #category : #'gt - extensions' }
GtGQLDirective >> gtLocationsFor: aView [
	<gtView>
	self locations ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Locations';
		priority: 30;
		items: [ self locations ifNil: [ #() ] ];
		column: 'Name' text: #yourself
]

{ #category : #initiailize }
GtGQLDirective >> initialize [
	super initialize.
	isRepeatable := false
]

{ #category : #accessing }
GtGQLDirective >> isRepeatable [
	^ isRepeatable
]

{ #category : #accessing }
GtGQLDirective >> isRepeatable: anObject [
	isRepeatable := anObject
]

{ #category : #accessing }
GtGQLDirective >> locations [
	^ locations
]

{ #category : #accessing }
GtGQLDirective >> locations: anObject [
	locations := anObject
]

{ #category : #accessing }
GtGQLDirective >> name [
	^ name
]

{ #category : #accessing }
GtGQLDirective >> name: anObject [
	name := anObject
]

{ #category : #printing }
GtGQLDirective >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name asString;
		nextPut: $)
]
