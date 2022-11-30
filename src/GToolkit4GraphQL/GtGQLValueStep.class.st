Class {
	#name : #GtGQLValueStep,
	#superclass : #Object,
	#instVars : [
		'ast',
		'parent',
		'alias',
		'name'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLValueStep >> alias [
	^ alias
]

{ #category : #accessing }
GtGQLValueStep >> alias: anObject [
	alias := anObject
]

{ #category : #accessing }
GtGQLValueStep >> ast [
	^ ast
]

{ #category : #accessing }
GtGQLValueStep >> ast: anObject [
	ast := anObject
]

{ #category : #printing }
GtGQLValueStep >> fieldName [
	"Return step name used in a schema structure (type field name)."

	<return: #String>
	^ self name ifNil: [ '?' ]
]

{ #category : #'gt - extensions' }
GtGQLValueStep >> gtAstExploreFor: aView [
	<gtView>
	self ast ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'AST';
		priority: 1;
		object: [ self ast ];
		view: #gtExploreFor:
]

{ #category : #accessing }
GtGQLValueStep >> name [
	^ name
]

{ #category : #accessing }
GtGQLValueStep >> name: anObject [
	name := anObject
]

{ #category : #'api - instance creation' }
GtGQLValueStep >> newStepForFieldName: aName [
	<return: #GtGQLValueStep or: nil>
	^ GtGQLValueStepBuilder new
		parentStep: self;
		fieldName: aName;
		build;
		step
]

{ #category : #'api - instance creation' }
GtGQLValueStep >> newStepForResultName: anAlias [
	<return: #GtGQLValueStep or: nil>
	^ GtGQLValueStepBuilder new
		parentStep: self;
		aliasName: anAlias;
		build;
		step
]

{ #category : #accessing }
GtGQLValueStep >> parent [
	^ parent
]

{ #category : #accessing }
GtGQLValueStep >> parent: anObject [
	parent := anObject
]

{ #category : #printing }
GtGQLValueStep >> printOn: aStream [
	super printOn: aStream.

	aStream nextPut: $(.

	self alias
		ifNotNil: [ :anAlias | 
			aStream
				nextPutAll: anAlias asString;
				nextPutAll: ': ' ].

	aStream
		nextPutAll: self fieldName;
		nextPut: $)
]

{ #category : #printing }
GtGQLValueStep >> resultName [
	"Return step name used in a result JSON structure."

	<return: #String>
	^ self alias ifNil: [ self fieldName ]
]
