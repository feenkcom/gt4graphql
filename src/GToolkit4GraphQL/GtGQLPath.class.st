Class {
	#name : #GtGQLPath,
	#superclass : #Object,
	#instVars : [
		'steps',
		'ast'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #comparing }
GtGQLPath >> = anObject [
	self == anObject
		ifTrue: [ ^ true ].

	self class = anObject class
		ifFalse: [ ^ false ].

	^ self steps = anObject steps
]

{ #category : #accessing }
GtGQLPath >> ast [
	^ ast
]

{ #category : #accessing }
GtGQLPath >> ast: anObject [
	ast := anObject
]

{ #category : #'gt - extensions' }
GtGQLPath >> gtAstExploreFor: aView [
	<gtView>
	self ast ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Leaf AST';
		priority: 5;
		object: [ self leafAst ];
		view: #gtExploreFor:
]

{ #category : #'gt - extensions' }
GtGQLPath >> gtStepsFor: aView [
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
				aName := aStep fullName asRopedText.
				aStep = self leafStep ifTrue: [ aName bold ].
				aName ]
]

{ #category : #comparing }
GtGQLPath >> hash [
	^ self steps hash
]

{ #category : #accessing }
GtGQLPath >> leafAst [
	^ self leafStep ifNotNil: [ :aStep | aStep ast ] ifNil: [ self ast ]
]

{ #category : #accessing }
GtGQLPath >> leafStep [
	^ self steps ifNotEmpty: [ :aCollection | aCollection last ] ifEmpty: [ nil ]
]

{ #category : #printing }
GtGQLPath >> printOn: aStream [
	super printOn: aStream.

	steps ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self resultPathString asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLPath >> resultPath [
	^ Array
		new: self steps size
		streamContents: [ :aStream | self steps do: [ :aStep | aStream nextPut: aStep resultName ] ]
]

{ #category : #accessing }
GtGQLPath >> resultPathString [
	^ String
		streamContents: [ :aStream | 
			self steps
				do: [ :aStep | aStream nextPutAll: aStep resultName ]
				separatedBy: [ aStream nextPut: $. ] ]
]

{ #category : #accessing }
GtGQLPath >> resultPathText [
	| aText anIndex |
	aText := '' asRopedText.
	anIndex := 1.
	self steps
		do: [ :aStep | 
			| aStepName |
			aStepName := aStep resultName asRopedText.
			anIndex = self steps size ifTrue: [ aStepName bold ].
			aText append: aStepName.
			anIndex := anIndex + 1 ]
		separatedBy: [ aText append: '.' asRopedText ].

	^ aText
]

{ #category : #accessing }
GtGQLPath >> steps [
	<return: #Collection of: #GtGQLPathStep>
	^ steps
]

{ #category : #accessing }
GtGQLPath >> steps: anObject [
	steps := anObject
]
