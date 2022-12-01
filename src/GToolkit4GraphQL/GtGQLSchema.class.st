Class {
	#name : #GtGQLSchema,
	#superclass : #GtGQLModel,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #'gt - extensions' }
GtGQLSchema class >> gtTypesFor: aView items: aBlock [
	^ aView columnedTree
		priority: 10;
		title: 'Types';
		column: 'Name'
			text: [ :each | each gtTypesNameText ]
			weight: 2;
		column: 'Type'
			text: [ :each | (self typeForObject: each) ifNotNil: #name ifNil: [ '' ] ];
		column: 'Class'
			text: [ :each | 
				(self typeForObject: each)
					ifNotNil: [ :aType | aType baseType typeName ]
					ifNil: [ '' ] ] width: 100;
		items: aBlock;
		children: [ :each | 
			(self typeForObject: each)
				ifNotNil: [ :aType | 
					(aType baseType fields ifNil: [ #() ])
						asSortedCollection: [ :a :b | a name < b name ] ]
				ifNil: [ #() ] ]
]

{ #category : #'gt - extensions' }
GtGQLSchema class >> typeForObject: aTypeOrField [
	^ (aTypeOrField isKindOf: GtGQLField)
		ifTrue: [ aTypeOrField type ]
		ifFalse: [ aTypeOrField ]
]

{ #category : #accessing }
GtGQLSchema >> baseInterfaces [
	^ self baseTypes select: #isInterface
]

{ #category : #accessing }
GtGQLSchema >> baseTypes [
	^ self types reject: [ :each | each isList or: [ each isNonNullable ] ]
]

{ #category : #accessing }
GtGQLSchema >> baseTypesCount [
	^ self
		propertyAt: #types
		ifPresent: [ :aDict | self baseTypes size ]
		ifAbsent: [ 0 ]
]

{ #category : #accessing }
GtGQLSchema >> baseTypesWithQueryPaths [
	^ self baseTypes select: [ :each | each queryPaths isNotNil ]
]

{ #category : #accessing }
GtGQLSchema >> baseUnions [
	^ self baseTypes select: #isUnion
]

{ #category : #accessing }
GtGQLSchema >> connectionTypes [
	^ self
		optionAt: #connectionTypes
		ifAbsentPut: [ self pageInfoType
				ifNil: [ #() ]
				ifNotNil: [ :anInfoType | 
					self baseTypes
						select: [ :eachType | 
							eachType isComposite
								and: [ eachType fields
										anySatisfy: [ :eachField | eachField type baseType = anInfoType ] ] ] ] ]
]

{ #category : #importing }
GtGQLSchema >> createTypesFrom: aNode [
	aNode
		withAllNodesOfType: GraphQLTypeDefinitionNode
		do: [ :each | 
			| type |
			type := each gtTypeClass new
					name: each name source;
					yourself.
			self typesDictionary at: type name put: type ]
]

{ #category : #accessing }
GtGQLSchema >> directives [
	^ self propertyAt: #directives ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLSchema >> directives: anObject [
	self propertyAt: #directives put: anObject
]

{ #category : #'gt - extensions' }
GtGQLSchema >> gtDirectivesFor: aView [
	<gtView>
	self directives ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Directives';
		priority: 20;
		items: [ self directives ifNil: [ #() ] ];
		column: 'Name'
			text: [ :each | 
				each isRepeatable
					ifTrue: [ each name asRopedText
							append: (' (repeatable)' asRopedText
									foreground: BrGlamorousColors disabledButtonTextColor) ]
					ifFalse: [ each name ] ];
		column: 'Description'
			text: [ :each | each description ifNil: [ '' ] ]
			weight: 3
]

{ #category : #'gt - extensions' }
GtGQLSchema >> gtInterfacesFor: aView [
	<gtView>
	^ (self class
		gtTypesFor: aView
		items: [ self baseInterfaces asSortedCollection: [ :a :b | a name < b name ] ])
			title: 'Interfaces';
			priority: 45
]

{ #category : #'gt - extensions' }
GtGQLSchema >> gtMetaMetaModelFor: aView [
	<gtView>
	^ (self class
		gtTypesFor: aView
		items: [ self metaMetaModelTypes asSortedCollection: [ :a :b | a name < b name ] ])
		title: 'Meta-Meta-Model';
		priority: 40
]

{ #category : #accessing }
GtGQLSchema >> gtMutationFor: aView [
	<gtView>
	self mutationType ifNil: [ ^ aView empty ].
	^ aView forward
		priority: 12;
		title: 'Mutation';
		object: [ self mutationType ];
		view: #gtFieldsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Mutation'
			tooltip: 'Inspect mutation'
			action: [ :aButton | aButton phlow spawnObject: self mutationType ]
]

{ #category : #accessing }
GtGQLSchema >> gtQueryFor: aView [
	<gtView>
	self queryType ifNil: [ ^ aView empty ].
	^ aView forward
		priority: 11;
		title: 'Query';
		object: [ self queryType ];
		view: #gtFieldsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Query'
			tooltip: 'Inspect query'
			action: [ :aButton | aButton phlow spawnObject: self queryType ]
]

{ #category : #accessing }
GtGQLSchema >> gtSearchFieldsFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 50;
		title: 'Fields';
		items: [ (self types asArray asAsyncStream
				collect: [ :each | each fields asArray asAsyncStream ]) flatten ];
		itemName: #name;
		filter: (GtSpotterSubstringFilter new itemString: #name);
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #accessing }
GtGQLSchema >> gtSearchMutationFieldsFor: aSearch [
	<gtSearch>
	self mutationType ifNil: [ ^ aSearch empty ].

	^ aSearch list
		priority: 40;
		title: 'Mutation Fields';
		items: [ self mutationType fields asArray asAsyncStream ];
		itemName: #name;
		filter: (GtSpotterSubstringFilter new itemString: #name);
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #accessing }
GtGQLSchema >> gtSearchQueryFieldsFor: aSearch [
	<gtSearch>
	self queryType ifNil: [ ^ aSearch empty ].

	^ aSearch list
		priority: 30;
		title: 'Query Fields';
		items: [ self queryType fields asArray asAsyncStream ];
		itemName: #name;
		filter: (GtSpotterSubstringFilter new itemString: #name);
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #accessing }
GtGQLSchema >> gtSearchTypesFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 10;
		title: 'Type';
		items: [ self types asArray ];
		itemName: #name;
		filter: (GtSpotterSubstringFilter new itemString: #name);
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #'gt - extensions' }
GtGQLSchema >> gtTypesFor: aView [
	<gtView>
	^ self class
		gtTypesFor: aView
		items: [ self baseTypes asSortedCollection: [ :a :b | a name < b name ] ]
]

{ #category : #'gt - extensions' }
GtGQLSchema >> gtTypesWithQueryPathsFor: aView [
	<gtView>
	^ (self class
		gtTypesFor: aView
		items: [ self baseTypesWithQueryPaths asSortedCollection: [ :a :b | a name < b name ] ])
		title: 'Types With Query Types';
		priority: 47;
		column: 'Paths' text: [ :aType | aType queryPaths size ] width: 40
]

{ #category : #'gt - extensions' }
GtGQLSchema >> gtUnionsFor: aView [
	<gtView>
	^ (self class
		gtTypesFor: aView
		items: [ self baseUnions asSortedCollection: [ :a :b | a name < b name ] ])
			title: 'Unions';
			priority: 46
]

{ #category : #importing }
GtGQLSchema >> import: aNode [
	self createTypesFrom: aNode.
	self importEnums: aNode.
	self importUnions: aNode.
	self importComposites: aNode.
	self queryType: (self typeNamed: 'Query').
	self mutationType: (self typeNamed: 'Mutation').

	GtGQLIntrospectionImplicitFieldsBuilder new
		schema: self;
		createMissingTypes;
		build
]

{ #category : #importing }
GtGQLSchema >> importComposites: aNode [
	aNode
		withAllNodesDo: [ :each | 
			| type |
			((each isKindOf: GraphQLInputObjectTypeDefinitionNode)
				or: [ (each isKindOf: GraphQLInterfaceTypeDefinitionNode)
						or: [ each isKindOf: GraphQLObjectTypeDefinitionNode ] ])
				ifTrue: [ type := self typesDictionary at: each name source.
					each definitions
						do: [ :def | 
							| field |
							field := GtGQLField new
									name: def name source;
									type: (self typeFor: def type);
									yourself.
							def definitions
								do: [ :arg | 
									field
										addArgument: (GtGQLInputObject new
												name: arg name source;
												type: (self typeFor: arg type);
												yourself) ].
							type addField: field ] ] ]
]

{ #category : #importing }
GtGQLSchema >> importEnums: aNode [
	aNode
		withAllNodesOfType: GraphQLEnumTypeDefinitionNode
		do: [ :each | 
			| type |
			type := self typesDictionary at: each name source.
			type
				values: (each definitions
						collect: [ :enum | GtGQLEnumeration new name: enum value source ]) ]
]

{ #category : #importing }
GtGQLSchema >> importUnions: aNode [
	aNode
		withAllNodesOfType: GraphQLUnionTypeDefinitionNode
		do: [ :each | 
			| type |
			type := self typesDictionary at: each name source.
			type types: (each types collect: [ :union | self typeFor: union ]) ]
]

{ #category : #initialization }
GtGQLSchema >> initialize [
	super initialize.

	#(boolean float id int string)
		do: [ :each | 
			| type |
			type := GtGQLScalar perform: each.
			self typesDictionary at: type name put: type ]
]

{ #category : #accessing }
GtGQLSchema >> interfaces [
	^ self types select: #isInterface
]

{ #category : #accessing }
GtGQLSchema >> metaMetaModelTypes [
	^ self baseTypes select: [ :each | each name beginsWith: '__' ]
]

{ #category : #accessing }
GtGQLSchema >> mutationType [
	^ self propertyAt: #mutationType
]

{ #category : #accessing }
GtGQLSchema >> mutationType: anObject [
	self propertyAt: #mutationType put: anObject
]

{ #category : #accessing }
GtGQLSchema >> pageInfoType [
	^ self optionAt: #pageInfoType ifAbsentPut: [ self typeNamed: 'PageInfo' ]
]

{ #category : #'gt - extensions' }
GtGQLSchema >> paintInterfaceUsesWith: m [
	m nodes
		stencil: [ BlElement new
				geometry: BlCircleGeometry new;
				background: Color blue;
				size: 5 @ 5 ];
		with: self interfaces.
	m nodes with: (self interfaces flatCollectAsSet: #possibleTypes).
	m edges connect: self interfaces toAll: #possibleTypes.
	^ m layout force
]

{ #category : #printing }
GtGQLSchema >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: self baseTypesCount;
		space;
		nextPutAll: ('base type' asPluralBasedOn: self baseTypesCount);
		nextPutAll: ', ';
		print: self typesCount;
		space;
		nextPutAll: ('all type' asPluralBasedOn: self typesCount);
		nextPut: $)
]

{ #category : #accessing }
GtGQLSchema >> queryType [
	^ self propertyAt: #queryType
]

{ #category : #accessing }
GtGQLSchema >> queryType: anObject [
	self propertyAt: #queryType put: anObject
]

{ #category : #accessing }
GtGQLSchema >> subscriptionType [
	^ self propertyAt: #subscriptionType
]

{ #category : #accessing }
GtGQLSchema >> subscriptionType: anObject [
	self propertyAt: #subscriptionType put: anObject
]

{ #category : #importing }
GtGQLSchema >> typeFor: aType [
	| name |
	name := self typeNameFor: aType.
	^ self typesDictionary
		at: name
		ifAbsentPut: [ | baseType |
			baseType := (aType isKindOf: GraphQLListTypeNode)
					ifTrue: [ GtGQLList new
							type: (self typeFor: aType type);
							yourself ]
					ifFalse: [ self typesDictionary at: aType name source ].
			aType bangToken notNil
				ifTrue: [ GtGQLNonNullable new
						type: baseType;
						yourself ]
				ifFalse: [ baseType ] ]
]

{ #category : #importing }
GtGQLSchema >> typeNameFor: aType [
	| name |
	name := (aType isKindOf: GraphQLListTypeNode)
			ifTrue: [ '[' , (self typeNameFor: aType type) , ']' ]
			ifFalse: [ aType name source ].
	aType bangToken notNil ifTrue: [ name := name , '!' ].
	^ name
]

{ #category : #accessing }
GtGQLSchema >> typeNamed: aString [
	^ self typesDictionary at: aString ifAbsent: [ nil ]
]

{ #category : #'importing - json' }
GtGQLSchema >> typeNamed: aTypeName ifPresent: aPresentBlock ifAbsentPut: anAbsentBlock [
	^ self typesDictionary
		at: aTypeName
		ifPresent: aPresentBlock
		ifAbsentPut: anAbsentBlock
]

{ #category : #accessing }
GtGQLSchema >> types [
	^ self
		propertyAt: #types
		ifPresent: #values
		ifAbsent: [ #() ]
]

{ #category : #accessing }
GtGQLSchema >> typesCount [
	^ self
		propertyAt: #types
		ifPresent: #size
		ifAbsent: [ 0 ]
]

{ #category : #'private - accessing' }
GtGQLSchema >> typesDictionary [
	^ self propertyAt: #types ifAbsentPut: [ Dictionary new ]
]
