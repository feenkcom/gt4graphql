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

{ #category : #'accessing - field' }
GtGQLConnectionField >> fieldName [
	^ self field ifNotNil: #name
]

{ #category : #'accessing - field' }
GtGQLConnectionField >> fieldType [
	^ self field ifNotNil: #type
]

{ #category : #'accessing - field' }
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
GtGQLConnectionField >> gtIndentFor: aView [
	<gtView>
	self ast ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Indent String';
		priority: 20;
		object: [ self pageInfoIndent ];
		view: #gtLiveFor:
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

{ #category : #'testing - ast' }
GtGQLConnectionField >> hasAllPageInfoFields [
	^ self hasPageInfoAst and: [ self missingPageInfoFields isEmpty ]
]

{ #category : #'testing - ast' }
GtGQLConnectionField >> hasPageInfoAst [
	^ self pageInfoAst isNotNil
]

{ #category : #'accessing - ast' }
GtGQLConnectionField >> insertPosition [
	<return: #Integer or: nil>
	self hasPageInfoAst ifFalse: [ ^ self insertPositionForAst: self ast ].

	self hasAllPageInfoFields
		ifFalse: [ ^ self insertPositionForAst: self pageInfoAst ].

	^ nil
]

{ #category : #'private - ast' }
GtGQLConnectionField >> insertPositionForAst: anAst [
	^ (anAst selections
		ifNotEmpty: [ :anArray | anArray last ]
		ifEmpty: [ anAst leftBrace ifNil: [ anAst rightParen ifNil: [ anAst name ] ] ])
		ifNotNil: [ :aNode | aNode stopPosition + 1 ]
]

{ #category : #'testing - ast' }
GtGQLConnectionField >> isUnfulfilled [
	^ self hasPageInfoAst not or: [ self hasAllPageInfoFields not ]
]

{ #category : #'accessing - field' }
GtGQLConnectionField >> missingPageInfoFields [
	| anAstFields |
	self hasPageInfoAst ifFalse: [ ^ self pageInfoType fields ].

	anAstFields := self pageInfoAst selections collect: [ :e | e name source ].
	^ (self pageInfoType fields
		reject: [ :e | e isMetaField or: [ anAstFields includes: e name ] ]) asArray
]

{ #category : #'accessing - ast' }
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

{ #category : #'accessing - ast' }
GtGQLConnectionField >> pageInfoAstAliasAndName [
	^ self pageInfoAst
		ifNotNil: [ :anAst | 
			(anAst alias ifNotNil: [ :aToken | aToken source , ': ' ] ifNil: [ '' ])
				, (anAst name ifNotNil: #source ifNil: [ '' ]) ]
		ifNil: [ '' ]
]

{ #category : #'accessing - field' }
GtGQLConnectionField >> pageInfoField [
	^ self field type baseType fields
		detect: [ :eachField | eachField type baseType = self pageInfoType ]
		ifNone: [ nil ]
]

{ #category : #'accessing - field' }
GtGQLConnectionField >> pageInfoFieldName [
	^ self pageInfoField ifNotNil: #name ifNil: [ '' ]
]

{ #category : #'accessing - ast' }
GtGQLConnectionField >> pageInfoIndent [
	<return: #String>
	^ self subFieldIndentFor: self ast
]

{ #category : #'accessing - field' }
GtGQLConnectionField >> pageInfoType [
	^ self schema pageInfoType
]

{ #category : #'accessing - ast' }
GtGQLConnectionField >> path [
	<return: #GtGQLPath or: nil>
	^ self paths ifNotEmpty: #first ifEmpty: [ nil ]
]

{ #category : #'accessing - ast' }
GtGQLConnectionField >> pathString [
	^ self path ifNotNil: #resultPathString ifNil: [ '?' ]
]

{ #category : #'accessing - ast' }
GtGQLConnectionField >> pathText [
	^ self path
		ifNotNil: #resultPathText
		ifNil: [ '?' asRopedText foreground: BrGlamorousColors errorBackgroundColor ]
]

{ #category : #'accessing - ast' }
GtGQLConnectionField >> paths [
	<return: #Collection of: #GtGQLPath>
	^ GtGQLPathBuilder new
		ast: self ast;
		build;
		paths
]

{ #category : #printing }
GtGQLConnectionField >> printOn: aStream [
	super printOn: aStream.

	self ast ifNil: [ ^ self ].
	aStream
		nextPut: $(;
		nextPutAll: self pathString asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLConnectionField >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLConnectionField >> schema: anObject [
	schema := anObject
]

{ #category : #'accessing - ast' }
GtGQLConnectionField >> subFieldIndentFor: anAst [
	"Return an indent (spaces and tabs) string that is used as a field prefix.
	For example, in case of 
```
repositories {
	totalCount
}
```
It returns the substring between `{` and `t` (of `totalCount`)."

	<return: #String>
	^ anAst selections
		ifNotEmpty: [ :anArray | 
			| anOffset aStart aStop |
			anOffset := anAst startPosition.
			aStart := anAst leftBrace stopPosition + 2.
			aStop := anArray first startPosition.
			anAst source copyFrom: aStart - anOffset to: aStop - anOffset ]
		ifEmpty: [ (self subFieldIndentFor: anAst parent), String tab ]
]
