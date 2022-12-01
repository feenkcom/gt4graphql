Class {
	#name : #GtGQLQueryPathBuilder,
	#superclass : #Object,
	#instVars : [
		'schema',
		'paths',
		'typeReferences',
		'interfaceReferences',
		'unionReferences',
		'traversedTypes',
		'currentPath'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'private - applying' }
GtGQLQueryPathBuilder >> applyInterfaces [
	interfaceReferences
		keysAndValuesDo: [ :aType :implementedInterfaces | aType implementedInterfaces: implementedInterfaces asArray ]
]

{ #category : #'private - applying' }
GtGQLQueryPathBuilder >> applyUnions [
	unionReferences
		keysAndValuesDo: [ :aType :itsUnions | aType partOfUnions: itsUnions asArray ]
]

{ #category : #'private - accessing' }
GtGQLQueryPathBuilder >> baseInterfaces [
	^ self schema baseInterfaces
]

{ #category : #'private - accessing' }
GtGQLQueryPathBuilder >> baseTypes [
	^ self schema baseTypes
]

{ #category : #'private - accessing' }
GtGQLQueryPathBuilder >> baseUnions [
	^ self schema baseUnions
]

{ #category : #'api - building' }
GtGQLQueryPathBuilder >> build [
	self buildTypeReferences.
	self buildInterfaceReferences.
	self buildUnionReferences.

	self applyInterfaces.
	self applyUnions.

	self buildPathsFromQuery
]

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> buildInterfaceReferences [
	interfaceReferences := Dictionary new.

	self baseInterfaces
		do: [ :aSourceInterface | 
			aSourceInterface possibleTypes
				do: [ :aTargetType | 
					interfaceReferences
						at: aTargetType
						ifPresent: [ :aCollection | aCollection add: aSourceInterface ]
						ifAbsentPut: [ OrderedCollection with: aSourceInterface ] ] ]
]

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> buildPathsFromQuery [
	typeReferences
		keysDo: [ :aStopType | self buildPathsFromStart: self queryType toStop: aStopType ]
]

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> buildPathsFromStart: aStartType toStop: aStopType [
	(self isType: aStartType kindOf: aStopType) ifTrue: [ ^ self ].

	paths := OrderedCollection new.
	traversedTypes := LinkedList new.
	currentPath := LinkedList new.

	self
		traverseFromStartType: aStartType
		throughType: aStartType
		stopType: aStopType.

	paths
		ifNotEmpty: [ | aTypePaths |
			aTypePaths := GtGQLTypePaths new paths: paths asArray.

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

{ #category : #'private - building' }
GtGQLQueryPathBuilder >> buildUnionReferences [
	unionReferences := Dictionary new.

	self baseUnions
		do: [ :aSourceUnion | 
			aSourceUnion possibleTypes
				do: [ :aTargetType | 
					unionReferences
						at: aTargetType
						ifPresent: [ :aCollection | aCollection add: aSourceUnion ]
						ifAbsentPut: [ OrderedCollection with: aSourceUnion ] ] ]
]

{ #category : #'private - traversing' }
GtGQLQueryPathBuilder >> completePathForStartType: aStartType stopType: aStopType [
	| aPath |
	aPath := GtGQLTypePath new
			steps: currentPath asArray;
			startType: aStartType;
			stopType: aStopType.

	paths add: aPath
]

{ #category : #'gt - extensions' }
GtGQLQueryPathBuilder >> gtInterfaceReferencesFor: aView [
	<gtView>
	interfaceReferences ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Interface References';
		priority: 21;
		items: [ interfaceReferences keys asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :aType | 
			interfaceReferences
				at: aType
				ifPresent: [ :aCollection | aCollection asSortedCollection: [ :a :b | a name < b name ] ]
				ifAbsent: [ #() ] ];
		column: 'Referenced Type'
			text: [ :aType | aType gtTypeReferencesViewReferencedTypeText ];
		column: 'Interfaces'
			text: [ :aType | self gtInterfaceReferencesViewInterfacesTextFor: aType ]
			weight: 2
]

{ #category : #'gt - extensions' }
GtGQLQueryPathBuilder >> gtInterfaceReferencesViewInterfacesTextFor: aType [
	aType isInterface ifTrue: [ ^ '' ].

	^ interfaceReferences
		at: aType
		ifPresent: [ :aCollection | 
			| aSortedInterfaces |
			aSortedInterfaces := aCollection
					asSortedCollection: [ :a :b | a name < b name ].
			String
				streamContents: [ :aStream | 
					aSortedInterfaces
						do: [ :anInterface | aStream nextPutAll: anInterface name ]
						separatedBy: [ aStream nextPutAll: ', ' ] ] ]
		ifAbsent: [ '' ]
]

{ #category : #'gt - extensions' }
GtGQLQueryPathBuilder >> gtQueryPathsFor: aView [
	<gtView>
	unionReferences ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Query Paths';
		priority: 10;
		items: [ (self baseTypes select: [ :each | each queryPaths isNotNil ])
				asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :anObject | 
			(anObject isKindOf: GtGQLType)
				ifTrue: [ anObject queryPaths ifNil: [ #() ] ]
				ifFalse: [ #() ] ];
		column: 'Name' text: [ :aType | aType gtQueryPathViewNameText ];
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

{ #category : #'gt - extensions' }
GtGQLQueryPathBuilder >> gtUnionReferencesFor: aView [
	<gtView>
	unionReferences ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Union References';
		priority: 22;
		items: [ unionReferences keys asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :aType | 
			unionReferences
				at: aType
				ifPresent: [ :aCollection | aCollection asSortedCollection: [ :a :b | a name < b name ] ]
				ifAbsent: [ #() ] ];
		column: 'Referenced Type'
			text: [ :aType | aType gtTypeReferencesViewReferencedTypeText ];
		column: 'Unions'
			text: [ :aType | self gtUnionReferencesViewUnionTextFor: aType ]
			weight: 2
]

{ #category : #'gt - extensions' }
GtGQLQueryPathBuilder >> gtUnionReferencesViewUnionTextFor: aType [
	aType isUnion ifTrue: [ ^ '' ].

	^ unionReferences
		at: aType
		ifPresent: [ :aCollection | 
			| aSortedInterfaces |
			aSortedInterfaces := aCollection
					asSortedCollection: [ :a :b | a name < b name ].
			String
				streamContents: [ :aStream | 
					aSortedInterfaces
						do: [ :anInterface | aStream nextPutAll: anInterface name ]
						separatedBy: [ aStream nextPutAll: ', ' ] ] ]
		ifAbsent: [ '' ]
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
