Class {
	#name : #GtGQLConnectionFinder,
	#superclass : #GraphQLProgramNodeVisitor,
	#instVars : [
		'schema',
		'ast',
		'nodes'
	],
	#category : #'GToolkit4GraphQL-Async Streams'
}

{ #category : #accessing }
GtGQLConnectionFinder >> ast [
	^ ast
]

{ #category : #'api - initialization' }
GtGQLConnectionFinder >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
GtGQLConnectionFinder >> connectionTypes [
	^ self schema connectionTypes
]

{ #category : #'api - finding' }
GtGQLConnectionFinder >> find [
	self ast ifNil: [ ^ self ].
	self schema ifNil: [ ^ self ].
	self pageInfoType ifNil: [ ^ self ].
	self connectionTypes ifEmpty: [ ^ self ].

	self ast acceptVisitor: self
]

{ #category : #'gt - extensions' }
GtGQLConnectionFinder >> gtFieldsFor: aView [
	<gtView>
	nodes ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Fields';
		priority: 1;
		items: [ nodes ];
		column: 'Path'
			text: [ :aField | 
				| aText aPath |
				aText := '' asRopedText.
				aPath := aField path.

				aPath
					withIndexDo: [ :aName :anIndex | 
						anIndex = aPath size
							ifFalse: [ aText
									append: aName asRopedText;
									append: '.' asRopedText ]
							ifTrue: [ aText append: aName asRopedText bold ] ].

				aText ]
			weight: 2;
		column: 'Type' text: #fieldTypeName;
		column: 'Includes PageInfo' text: #hasPageInfoAst;
		column: 'Includes PageInfo Fields'
			text: [ :aField | aField hasPageInfoAst ifTrue: [ aField hasAllPageInfoFields ] ifFalse: [ '' ] ]
]

{ #category : #accessing }
GtGQLConnectionFinder >> initialize [
	super initialize.
	nodes := OrderedCollection new
]

{ #category : #accessing }
GtGQLConnectionFinder >> pageInfoType [
	^ self schema pageInfoType
]

{ #category : #'api - initialization' }
GtGQLConnectionFinder >> query: aGtGQLQuery [
	| anAst |
	anAst := GraphQLParser parse: aGtGQLQuery operation.
	self ast: anAst
]

{ #category : #accessing }
GtGQLConnectionFinder >> schema [
	^ schema
]

{ #category : #'api - initialization' }
GtGQLConnectionFinder >> schema: anObject [
	schema := anObject
]

{ #category : #visiting }
GtGQLConnectionFinder >> visitField: aNode [
	| aField |
	aField := aNode fieldIn: self schema.
	(self connectionTypes includes: aField type baseType)
		ifTrue: [ nodes
				add: (GtGQLConnectionField new
						ast: aNode;
						field: aField;
						schema: self schema) ].
	super visitField: aNode
]

{ #category : #visiting }
GtGQLConnectionFinder >> visitOperationDefinition: aNode [
	aNode isPartOfMutation ifTrue: [ ^ self ].
	super visitOperationDefinition: aNode
]
