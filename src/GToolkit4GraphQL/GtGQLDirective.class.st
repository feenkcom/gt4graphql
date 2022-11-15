Class {
	#name : #GtGQLDirective,
	#superclass : #GtGQLModel,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLDirective >> arguments [
	^ self propertyAt: #arguments ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLDirective >> arguments: anObject [
	self propertyAt: #arguments put: anObject
]

{ #category : #accessing }
GtGQLDirective >> description [
	^ self propertyAt: #description
]

{ #category : #accessing }
GtGQLDirective >> description: anObject [
	self propertyAt: #description put: anObject
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

{ #category : #accessing }
GtGQLDirective >> isRepeatable [
	^ self propertyAt: #isRepeatable ifAbsent: [ false ]
]

{ #category : #accessing }
GtGQLDirective >> isRepeatable: anObject [
	self propertyAt: #isRepeatable put: anObject
]

{ #category : #accessing }
GtGQLDirective >> locations [
	^ self propertyAt: #locations ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLDirective >> locations: anObject [
	self propertyAt: #locations put: anObject
]

{ #category : #accessing }
GtGQLDirective >> name [
	^ self propertyAt: #name
]

{ #category : #accessing }
GtGQLDirective >> name: anObject [
	self propertyAt: #name put: anObject
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
