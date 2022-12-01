Class {
	#name : #GtGQLTypePath,
	#superclass : #Object,
	#instVars : [
		'steps',
		'startType',
		'stopType'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLTypePath >> firstStep [
	^ self steps first
]

{ #category : #'gt - extensions' }
GtGQLTypePath >> gtQueryFor: aView [
	<gtView>
	self steps ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Query';
		priority: 10;
		object: [ self query ];
		view: #gtQueryFor:
]

{ #category : #'gt - extensions' }
GtGQLTypePath >> gtQueryPathViewNameText [
	| aText |
	aText := '' asRopedText.

	self steps
		do: [ :aStep | 
			| aStepText isLeafStep |
			isLeafStep := aStep = self leafStep.
			aStepText := aStep fieldName asRopedText.
			isLeafStep ifTrue: [ aStepText bold ].

			aStep isDeprecated
				ifTrue: [ aStepText
						lineThroughDo: [ :anAttribute | anAttribute color: BrGlamorousColors errorBackgroundColor ] ].

			aText append: aStepText.

			isLeafStep
				ifFalse: [ aText
						append: ('.' asRopedText foreground: BrGlamorousColors disabledButtonTextColor) ] ].

	^ aText
]

{ #category : #'gt - extensions' }
GtGQLTypePath >> gtStepsFor: aView [
	<gtView>
	self steps ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Steps';
		priority: 1;
		items: [ self steps ifNil: [ #() ] ];
		column: 'Index'
			text: [ :_ :anIndex | anIndex ]
			width: 40;
		column: 'Step'
			text: [ :aStep | 
				| aName |
				aName := '' asRopedText.

				aStep = self firstStep
					ifTrue: [ aName := aStep typeName asRopedText
								append: (' >> #' asRopedText foreground: BrGlamorousColors disabledButtonTextColor) ].

				aName append: aStep fieldName asRopedText.
				aName
					append: ((': ' , aStep fieldTypeName) asRopedText
							foreground: BrGlamorousColors disabledButtonTextColor).

				aStep = self leafStep ifTrue: [ aName bold ].

				aStep isDeprecated
					ifTrue: [ aName
							lineThroughDo: [ :anAttribute | anAttribute color: BrGlamorousColors errorBackgroundColor ].

						aName
							append: (' (deprecated)' asRopedText
									italic;
									foreground: BrGlamorousColors disabledButtonTextColor) ].

				aName ]
]

{ #category : #testing }
GtGQLTypePath >> isDeprecated [
	^ self steps anySatisfy: #isDeprecated
]

{ #category : #accessing }
GtGQLTypePath >> leafStep [
	^ self steps ifNotEmpty: #last ifEmpty: [ nil ]
]

{ #category : #printing }
GtGQLTypePath >> printOn: aStream [
	| aCount |
	super printOn: aStream.

	self startType ifNil: [ ^ self ].
	self stopType ifNil: [ ^ self ].
	self steps ifNil: [ ^ self ].

	aCount := self steps size.

	aStream
		nextPut: $(;
		nextPutAll: self startType name asString;
		nextPutAll: ' ... ';
		print: aCount;
		nextPutAll: (' field' asPluralBasedOn: aCount);
		nextPutAll: ' ... ';
		nextPutAll: self stopType name asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLTypePath >> query [
	^ GtGQLPathToQueryBuilder new
		path: self;
		build;
		query
]

{ #category : #accessing }
GtGQLTypePath >> startType [
	^ startType
]

{ #category : #accessing }
GtGQLTypePath >> startType: anObject [
	startType := anObject
]

{ #category : #accessing }
GtGQLTypePath >> steps [
	^ steps
]

{ #category : #accessing }
GtGQLTypePath >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
GtGQLTypePath >> stopType [
	^ stopType
]

{ #category : #accessing }
GtGQLTypePath >> stopType: anObject [
	stopType := anObject
]
