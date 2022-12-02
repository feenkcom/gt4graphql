Class {
	#name : #GtGQLQueryPathBuilder,
	#superclass : #Object,
	#instVars : [
		'schema',
		'paths',
		'typeReferences',
		'traversedTypes',
		'currentPath',
		'context'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'private - accessing' }
GtGQLQueryPathBuilder >> baseTypes [
	^ self schema baseTypes
]

{ #category : #'api - building' }
GtGQLQueryPathBuilder >> build [
	self buildTypeReferences.
	self buildPathsFromQuery
]

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> buildPathsFromQuery [
	typeReferences
		keysDo: [ :aStopType | 
			aStopType isCommonScalarType
				ifFalse: [ self buildPathsFromStart: self queryType toStop: aStopType ] ]
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

			aStartType = self queryType ifTrue: [ aStopType queryPaths: aTypePaths ] ]
]

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> buildTypeReferences [
	typeReferences := Dictionary new.

	self baseTypes
		do: [ :aSourceType | 
			aSourceType isComposite
				ifTrue: [ aSourceType fields
						do: [ :aSourceField | 
							| aTargetType aTypeReference |
							aTargetType := aSourceField type baseType.
							aTypeReference := GtGQLTypeReference new
									targetType: aTargetType;
									sourceType: aSourceType;
									sourceField: aSourceField.
							typeReferences
								at: aTargetType
								ifPresent: [ :aCollection | aCollection add: aTypeReference ]
								ifAbsentPut: [ OrderedCollection with: aTypeReference ] ] ] ]
]

{ #category : #'api - building' }
GtGQLQueryPathBuilder >> clear [
	self baseTypes
		do: [ :aType | aType clearOption: #queryPaths ifAbsent: [  "ignore" ] ]
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

{ #category : #'gt - extensions' }
GtGQLQueryPathBuilder >> gtTypeReferencesFor: aView [
	<gtView>
	typeReferences ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Type References';
		priority: 20;
		items: [ typeReferences keys asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :anObject | 
			| aType |
			aType := (anObject isKindOf: GtGQLType)
					ifTrue: [ anObject ]
					ifFalse: [ anObject sourceType ].

			typeReferences
				at: aType
				ifPresent: [ :aCollection | 
					aCollection
						asSortedCollection: [ :a :b | a sourceType name < b sourceType name ] ]
				ifAbsent: [ #() ] ];
		column: 'Referenced Type'
			text: [ :aType | aType gtTypeReferencesViewReferencedTypeText ]
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
