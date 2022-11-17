Class {
	#name : #GtGQLConnectionField,
	#superclass : #Object,
	#instVars : [
		'ast',
		'field',
		'schema'
	],
	#category : #'GToolkit4GraphQL-Async Streams'
}

{ #category : #accessing }
GtGQLConnectionField >> ast [
	^ ast
]

{ #category : #accessing }
GtGQLConnectionField >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
GtGQLConnectionField >> field [
	^ field
]

{ #category : #accessing }
GtGQLConnectionField >> field: anObject [
	field := anObject
]

{ #category : #accessing }
GtGQLConnectionField >> fieldName [
	^ self field ifNotNil: #name
]

{ #category : #accessing }
GtGQLConnectionField >> fieldType [
	^ self field ifNotNil: #type
]

{ #category : #accessing }
GtGQLConnectionField >> fieldTypeName [
	^ self fieldType ifNotNil: #name
]

{ #category : #'gt - extensions' }
GtGQLConnectionField >> gtAstExploreFor: aView [
	<gtView>
	self ast ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'AST';
		priority: 1;
		object: [ self ast ];
		view: #gtExploreFor:
]

{ #category : #'gt - extensions' }
GtGQLConnectionField >> gtFieldTypeFor: aView [
	<gtView>
	self field ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Field Type';
		priority: 2;
		object: [ self field ];
		view: #gtTypeFor:
]

{ #category : #'gt - extensions' }
GtGQLConnectionField >> gtMissingPageInfoFieldsFor: aView [
	<gtView>
	self hasPageInfoAst ifFalse: [ ^ aView empty ].
	self missingPageInfoFields ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Missing PageInfo Fields';
		priority: 5;
		items: [ self missingPageInfoFields ];
		column: 'Name' text: #name
]

{ #category : #testing }
GtGQLConnectionField >> hasAllPageInfoFields [
	^ self missingPageInfoFields isEmpty
]

{ #category : #testing }
GtGQLConnectionField >> hasPageInfoAst [
	^ self pageInfoAst isNotNil
]

{ #category : #accessing }
GtGQLConnectionField >> missingPageInfoFields [
	| anAstFields |
	anAstFields := self pageInfoAst selections collect: [ :e | e name source ].
	^ (self pageInfoType fields
		reject: [ :e | e isMetaField or: [ anAstFields includes: e name ] ]) asArray
]

{ #category : #accessing }
GtGQLConnectionField >> pageInfoAst [
	^ self ast selections
		detect: [ :eachNode | 
			(eachNode fieldIn: self schema)
				ifNotNil: [ :aField | 
					| aType |
					aType := aField type baseType.
					self pageInfoType = aType ]
				ifNil: [ false ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtGQLConnectionField >> pageInfoType [
	^ self schema pageInfoType
]

{ #category : #accessing }
GtGQLConnectionField >> path [
	| anAst anArray |
	anAst := self ast.
	anArray := Array
			streamContents: [ :aStream | 
				[ anAst isNil ]
					whileFalse: [ | aName |
						aName := anAst alias ifNotNil: #source ifNil: [ anAst name source ].
						aStream nextPut: aName.
						anAst := anAst parentOfType: anAst class ] ].
	^ anArray reversed
]

{ #category : #accessing }
GtGQLConnectionField >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLConnectionField >> schema: anObject [
	schema := anObject
]
