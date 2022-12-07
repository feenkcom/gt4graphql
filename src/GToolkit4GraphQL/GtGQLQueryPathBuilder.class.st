Class {
	#name : #GtGQLQueryPathBuilder,
	#superclass : #Object,
	#instVars : [
		'schema',
		'paths',
		'traversedTypes',
		'currentPath',
		'context',
		'startAccessor'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'private - accessing' }
GtGQLQueryPathBuilder >> baseTypes [
	^ self schema baseTypes
]

{ #category : #'api - building' }
GtGQLQueryPathBuilder >> build [
	startAccessor
		ifNil: [ self buildQueryPaths.
			self buildMutationPaths.
			^ self ].

	self buildPathsFromStartType
]

{ #category : #'api - building' }
GtGQLQueryPathBuilder >> buildMutationPaths [
	self forMutation.
	self buildPathsFromStartType
]

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> buildPathsFromStart: aStartType toStop: aStopType [
	(self isType: aStartType kindOf: aStopType) ifTrue: [ ^ self ].

	paths := OrderedCollection new.
	traversedTypes := OrderedCollection new.
	currentPath := LinkedList new.

	self
		traverseFromStartType: aStartType
		throughType: aStartType
		stopType: aStopType.

	paths
		ifNotEmpty: [ | aTypePaths |
			aTypePaths := paths asArray.

			self sortPaths: aTypePaths.

			startAccessor write: aStopType paths: aTypePaths ]
]

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> buildPathsFromStartType [
	self baseTypes
		do: [ :aStopType | 
			aStopType isCommonScalarType
				ifFalse: [ self buildPathsFromStart: self startType toStop: aStopType ] ]
]

{ #category : #'api - building' }
GtGQLQueryPathBuilder >> buildQueryPaths [
	self forQuery.
	self buildPathsFromStartType
]

{ #category : #'api - building' }
GtGQLQueryPathBuilder >> clear [
	self baseTypes
		do: [ :aType | 
			aType clearOption: #queryPaths ifAbsent: [  "ignore" ].
			aType clearOption: #mutationPaths ifAbsent: [  "ignore" ] ]
]

{ #category : #'private - traversing' }
GtGQLQueryPathBuilder >> completePathForStartType: aStartType stopType: aStopType [
	| aPath |
	aPath := GtGQLTypePath new
			steps: currentPath asArray;
			startType: aStartType;
			stopType: aStopType;
			context: self context.

	paths add: aPath
]

{ #category : #accessing }
GtGQLQueryPathBuilder >> context [
	<return: #GtGQLContext or: nil>
	^ context
]

{ #category : #accessing }
GtGQLQueryPathBuilder >> context: aContext [
	context := aContext
]

{ #category : #'api - initialization' }
GtGQLQueryPathBuilder >> forMutation [
	startAccessor := GtGQLMutationPathAccessor new builder: self
]

{ #category : #'api - initialization' }
GtGQLQueryPathBuilder >> forQuery [
	startAccessor := GtGQLQueryPathAccessor new builder: self
]

{ #category : #'gt - extensions' }
GtGQLQueryPathBuilder >> gtMutationPathsFor: aView [
	<gtView>
	schema ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Mutation Paths';
		priority: 11;
		items: [ (self baseTypes select: [ :each | each mutationPaths isNotNil ])
				asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :anObject | 
			(anObject isKindOf: GtGQLType)
				ifTrue: [ anObject mutationPaths ifNil: [ #() ] ]
				ifFalse: [ #() ] ];
		column: 'Name' text: [ :aType | aType queryPathViewNameText ];
		column: 'Paths'
			text: [ :anObject | 
				(anObject isKindOf: GtGQLType)
					ifTrue: [ anObject mutationPaths size ]
					ifFalse: [ '' ] ]
			width: 40
]

{ #category : #'gt - extensions' }
GtGQLQueryPathBuilder >> gtQueryPathsFor: aView [
	<gtView>
	schema ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Query Paths';
		priority: 10;
		items: [ (self baseTypes select: [ :each | each queryPaths isNotNil ])
				asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :anObject | 
			(anObject isKindOf: GtGQLType)
				ifTrue: [ anObject queryPaths ifNil: [ #() ] ]
				ifFalse: [ #() ] ];
		column: 'Name' text: [ :aType | aType queryPathViewNameText ];
		column: 'Paths'
			text: [ :anObject | 
				(anObject isKindOf: GtGQLType)
					ifTrue: [ anObject queryPaths size ]
					ifFalse: [ '' ] ]
			width: 40
]

{ #category : #'private - traversing' }
GtGQLQueryPathBuilder >> isType: aFieldType kindOf: aStopType [
	^ aFieldType = aStopType
		or: [ aStopType isObjectType
				and: [ (aStopType implementedInterfaces includes: aFieldType)
						or: [ aStopType partOfUnions includes: aFieldType ] ] ]
]

{ #category : #accessing }
GtGQLQueryPathBuilder >> paths [
	^ paths
]

{ #category : #'private - traversing' }
GtGQLQueryPathBuilder >> popLastStep [
	currentPath removeLast
]

{ #category : #'private - traversing' }
GtGQLQueryPathBuilder >> popTraversedType [
	traversedTypes removeLast
]

{ #category : #'private - traversing' }
GtGQLQueryPathBuilder >> pushNextStepThroughType: aType field: aField [
	| aStep |
	aStep := GtGQLTypeStep new
			type: aType;
			field: aField.

	currentPath add: aStep
]

{ #category : #'private - traversing' }
GtGQLQueryPathBuilder >> pushTraversedType: aNextType [
	traversedTypes add: aNextType
]

{ #category : #'private - accessing' }
GtGQLQueryPathBuilder >> queryType [
	^ self schema queryType
]

{ #category : #accessing }
GtGQLQueryPathBuilder >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLQueryPathBuilder >> schema: anObject [
	schema := anObject
]

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> sortPaths: aTypePaths [
	aTypePaths
		sort: [ :a :b | 
			| aMark bMark |
			aMark := a isDeprecated ifTrue: [ 10 ] ifFalse: [ 0 ].
			bMark := b isDeprecated ifTrue: [ 10 ] ifFalse: [ 0 ].

			aMark = bMark
				ifFalse: [ aMark < bMark ]
				ifTrue: [ a steps size = b steps size
						ifFalse: [ a steps size < b steps size ]
						ifTrue: [ a queryPathViewNameText asString < b queryPathViewNameText asString ] ] ]
]

{ #category : #'private - accessing' }
GtGQLQueryPathBuilder >> startType [
	^ startAccessor startType
]

{ #category : #'private - traversing' }
GtGQLQueryPathBuilder >> traverseFromStartType: aStartType throughType: aNextType stopType: aStopType [
	(traversedTypes includes: aNextType) ifTrue: [ ^ self ].
	self pushTraversedType: aNextType.

	(self isType: aNextType kindOf: aStopType)
		ifTrue: [ self error: 'should not happen' ].

	aNextType isComposite ifFalse: [ ^ self ].

	aNextType fields
		do: [ :aField | 
			| aFieldType |
			self pushNextStepThroughType: aNextType field: aField.

			aFieldType := aField type baseType.

			(self isType: aFieldType kindOf: aStopType)
				ifTrue: [ self completePathForStartType: aStartType stopType: aStopType ]
				ifFalse: [ self
						traverseFromStartType: aStartType
						throughType: aFieldType
						stopType: aStopType ].
			self popLastStep ].

	self popTraversedType
]
