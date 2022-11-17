Class {
	#name : #GtGQLConnectionFinder,
	#superclass : #GraphQLProgramNodeVisitor,
	#instVars : [
		'schema',
		'ast',
		'fields'
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

{ #category : #accessing }
GtGQLConnectionFinder >> fields [
	<return: #Collection of: #GtGQLConnectionField>
	^ fields
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
	fields ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Fields';
		priority: 1;
		items: [ fields ];
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
			weight: 1.5;
		column: 'Type' text: #fieldTypeName;
		column: 'PageInfo Status'
			text: [ :aField | 
				aField hasPageInfoAst
					ifFalse: [ ('missing {1} field' format: {aField pageInfoFieldName}) asRopedText
							foreground: BrGlamorousColors errorBackgroundColor ]
					ifTrue: [ aField hasAllPageInfoFields
							ifFalse: [ | aCount |
								('"{1}" misses {2} {3}'
									format: {aField pageInfoAstAliasAndName.
											aCount := aField missingPageInfoFields size.
											'field' asPluralBasedOn: aCount}) asRopedText
									foreground: BrGlamorousColors errorBackgroundColor ]
							ifTrue: [ 'ok' asRopedText
									foreground: BrGlamorousColors successBackgroundColor ] ] ];
		column: 'Insert Position'
			text: [ :aField | aField hasAllPageInfoFields ifTrue: [ '' ] ifFalse: [ aField insertPosition ] ]
			width: 100
]

{ #category : #accessing }
GtGQLConnectionFinder >> initialize [
	super initialize.
	fields := OrderedCollection new
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

{ #category : #accessing }
GtGQLConnectionFinder >> unfulfilledFields [
	<return: #Collection of: #GtGQLConnectionField>
	^ (self fields select: #isUnfulfilled)
		sort: [ :a :b | a insertPosition > b insertPosition ]
]

{ #category : #visiting }
GtGQLConnectionFinder >> visitField: aNode [
	| aField |
	aField := aNode fieldIn: self schema.
	(self connectionTypes includes: aField type baseType)
		ifTrue: [ fields
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
