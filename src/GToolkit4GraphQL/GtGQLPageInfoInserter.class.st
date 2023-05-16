Class {
	#name : #GtGQLPageInfoInserter,
	#superclass : #Object,
	#instVars : [
		'schema',
		'query',
		'connectorPaths',
		'unfulfilledFields',
		'modifiedQuery'
	],
	#category : #'GToolkit4GraphQL-Async Streams'
}

{ #category : #'private - insertion' }
GtGQLPageInfoInserter >> computeUnfulfilledFields [
	unfulfilledFields := GtGQLConnectionFinder new
			schema: self schema;
			query: self query;
			find;
			unfulfilledFields
]

{ #category : #accessing }
GtGQLPageInfoInserter >> connectorPath: aCollection [
	"Collection is a path to a connection field with PageInfo,
	e.g., #(organization repositories);"

	connectorPaths add: aCollection
]

{ #category : #accessing }
GtGQLPageInfoInserter >> connectorPaths [
	^ connectorPaths
]

{ #category : #accessing }
GtGQLPageInfoInserter >> connectorPaths: aCollectionOfCollections [
	connectorPaths := aCollectionOfCollections
]

{ #category : #'private - insertion' }
GtGQLPageInfoInserter >> createNewQuery [
	modifiedQuery := GtGQLModifiedQuery new
			operation: self query operation copy;
			input: self query input copy;
			previousQuery: self query
]

{ #category : #'gt - extensions' }
GtGQLPageInfoInserter >> gtActuallAndPreviousQueryDiffFor: aView [
	<gtView>
	self modifiedQuery ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'New query (two panes)';
		priority: 1;
		object: [ self modifiedQuery ];
		view: #gtQueryFor:
]

{ #category : #'gt - extensions' }
GtGQLPageInfoInserter >> gtNewQueryFor: aView [
	<gtView>
	self modifiedQuery ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'New query';
		priority: 2;
		object: [ self modifiedQuery ];
		view: #gtNewQueryFor:
]

{ #category : #'gt - extensions' }
GtGQLPageInfoInserter >> gtPreviousQueryFor: aView [
	<gtView>
	self query ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Previous query';
		priority: 3;
		object: [ self query ];
		view: #gtQueryFor:
]

{ #category : #testing }
GtGQLPageInfoInserter >> hasModifications [
	^ self modifiedQuery isNotNil
]

{ #category : #accessing }
GtGQLPageInfoInserter >> initialize [
	super initialize.
	connectorPaths := OrderedCollection new
]

{ #category : #'api - insertion' }
GtGQLPageInfoInserter >> insert [
	self computeUnfulfilledFields.
	self unfulfilledFields ifEmpty: [ ^ self ].

	self connectorPaths ifEmpty: [ self insertAll ] ifNotEmpty: [ self insertSome ]
]

{ #category : #'private - insertion' }
GtGQLPageInfoInserter >> insertAll [
	self createNewQuery.
	self unfulfilledFields do: [ :aField | self insertField: aField ]
]

{ #category : #'private - insertion' }
GtGQLPageInfoInserter >> insertField: aField [
	| anOpertion anInsertion aPosition aBeforePart anAfterPart aNewOperation |
	anOpertion := modifiedQuery operation.
	anInsertion := self insertionStringForField: aField.
	aPosition := aField insertPosition.

	aBeforePart := anOpertion copyFrom: 1 to: aPosition - 1.
	anAfterPart := anOpertion copyFrom: aPosition to: anOpertion size.

	aNewOperation := aBeforePart , anInsertion , anAfterPart.
	modifiedQuery operation: aNewOperation
]

{ #category : #'private - insertion' }
GtGQLPageInfoInserter >> insertSome [
	self unfulfilledFields
		do: [ :aField | 
			(self connectorPaths includes: aField path resultPath)
				ifTrue: [ modifiedQuery ifNil: [ self createNewQuery ].
					self insertField: aField ] ]
]

{ #category : #'private - insertion' }
GtGQLPageInfoInserter >> insertionStringForField: aField [
	^ aField hasPageInfoAst
		ifTrue: [ self insertionStringOfPageInfoMissingFieldsFor: aField ]
		ifFalse: [ self insertionStringOfPageInfoFor: aField ]
]

{ #category : #'private - insertion' }
GtGQLPageInfoInserter >> insertionStringOfPageInfoFor: aField [
	| aPageInfoField |
	aPageInfoField := aField pageInfoField.
	^ String
		streamContents: [ :aStream | 
			| anIndent |
			aField ast leftBrace ifNil: [ aStream nextPutAll: ' {' ].
			anIndent := aField pageInfoIndent.

			aStream nextPutAll: anIndent.
			aStream nextPutAll: aPageInfoField name.
			aStream nextPutAll: ' {'.
			aPageInfoField type baseType fields
				do: [ :eachField | 
					eachField isMetaField
						ifFalse: [ aStream
								nextPutAll: anIndent;
								tab;
								nextPutAll: eachField name ] ].
			aStream
				nextPutAll: anIndent;
				nextPutAll: '}'.

			aField ast rightBrace
				ifNil: [ aStream
						nextPutAll: (anIndent ifNotEmpty: [ anIndent allButLast ] ifEmpty: [ anIndent ]);
						nextPutAll: '}' ] ]
]

{ #category : #'private - insertion' }
GtGQLPageInfoInserter >> insertionStringOfPageInfoMissingFieldsFor: aField [
	^ String
		streamContents: [ :aStream | 
			aField pageInfoAst leftBrace ifNil: [ aStream nextPutAll: ' {' ].

			aField missingPageInfoFields
				do: [ :eachField | 
					aStream
						nextPutAll: aField pageInfoIndent;
						tab;
						nextPutAll: eachField name ].

			aField pageInfoAst rightBrace
				ifNil: [ aStream
						nextPutAll: aField pageInfoIndent;
						nextPutAll: '}' ] ]
]

{ #category : #accessing }
GtGQLPageInfoInserter >> modifiedQuery [
	^ modifiedQuery
]

{ #category : #accessing }
GtGQLPageInfoInserter >> query [
	^ query
]

{ #category : #accessing }
GtGQLPageInfoInserter >> query: anObject [
	query := anObject
]

{ #category : #accessing }
GtGQLPageInfoInserter >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLPageInfoInserter >> schema: anObject [
	schema := anObject
]

{ #category : #accessing }
GtGQLPageInfoInserter >> unfulfilledFields [
	^ unfulfilledFields
]
