Class {
	#name : #GtGQLSchema,
	#superclass : #Object,
	#instVars : [
		'types'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLSchema class >> gtTypesFor: aView items: aBlock [
	<gtView>
	^ aView columnedTree
		priority: 10;
		title: 'Types';
		column: 'Name' text: [ :each | each name ];
		column: 'Type' text: [ :each | (self typeForObject: each) name ];
		column: 'Class'
			text: [ :each | (self typeForObject: each) baseType typeName ];
		items: aBlock;
		children: [ :each | (self typeForObject: each) baseType fields ]
]

{ #category : #accessing }
GtGQLSchema class >> typeForObject: aTypeOrField [
	^ (aTypeOrField isKindOf: GtGQLField) ifTrue: [ aTypeOrField type ] ifFalse: [ aTypeOrField ]
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
			types at: type name put: type ]
]

{ #category : #accessing }
GtGQLSchema >> gtSearchFieldsFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 20;
		title: 'Fields';
		items: [ (types values asArray asAsyncStream
				collect: [ :each | each fields asArray asAsyncStream ]) flatten ];
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
		items: [ types values asArray ];
		itemName: #name;
		filter: (GtSpotterSubstringFilter new itemString: #name);
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #accessing }
GtGQLSchema >> gtTypesFor: aView [
	<gtView>
	^ self class
		gtTypesFor: aView
		items: [ (types values reject: [ :each | each isList or: [ each isNonNullable ] ])
				asSortedCollection: [ :a :b | a name < b name ] ]
]

{ #category : #importing }
GtGQLSchema >> import: aNode [
	self createTypesFrom: aNode.
	self importEnums: aNode.
	self importUnions: aNode.
	self importComposites: aNode
]

{ #category : #importing }
GtGQLSchema >> importComposites: aNode [
	aNode
		withAllNodesDo: [ :each | 
			| type |
			((each isKindOf: GraphQLInputObjectTypeDefinitionNode)
				or: [ (each isKindOf: GraphQLInterfaceTypeDefinitionNode)
						or: [ each isKindOf: GraphQLObjectTypeDefinitionNode ] ])
				ifTrue: [ type := types at: each name source.
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
										addArgument: (GtGQLField new
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
			type := types at: each name source.
			type values: (each definitions collect: [ :enum | enum value source ]) ]
]

{ #category : #importing }
GtGQLSchema >> importUnions: aNode [
	aNode
		withAllNodesOfType: GraphQLUnionTypeDefinitionNode
		do: [ :each | 
			| type |
			type := types at: each name source.
			type types: (each types collect: [ :union | self typeFor: union ]) ]
]

{ #category : #initialization }
GtGQLSchema >> initialize [
	super initialize.
	types := Dictionary new.
	#(boolean float id int string)
		do: [ :each | 
			| type |
			type := GtGQLScalar perform: each.
			types at: type name put: type ]
]

{ #category : #importing }
GtGQLSchema >> typeFor: aType [
	| name |
	name := self typeNameFor: aType.
	^ types
		at: name
		ifAbsentPut: [ | baseType |
			baseType := (aType isKindOf: GraphQLListTypeNode)
					ifTrue: [ GtGQLList new
							type: (self typeFor: aType type);
							yourself ]
					ifFalse: [ types at: aType name source ].
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
