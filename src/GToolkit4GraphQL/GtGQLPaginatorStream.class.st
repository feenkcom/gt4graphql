Class {
	#name : #GtGQLPaginatorStream,
	#superclass : #Object,
	#traits : 'TAsyncStream',
	#classTraits : 'TAsyncStream classTrait',
	#instVars : [
		'lastResult',
		'stream',
		'done',
		'connectorPath',
		'itemsName',
		'pageInfoName',
		'hasNextPageName',
		'endCursorName',
		'cursorInputName',
		'initialResult'
	],
	#category : #'GToolkit4GraphQL-Async Streams'
}

{ #category : #accessing }
GtGQLPaginatorStream >> configuration [
	<return: #GtGQLContext>
	^ self lastResult ifNotNil: #configuration
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> connectorObject [
	<return: #GtJson>
	^ self lastResult data atPath: self connectorPath
]

{ #category : #accessing }
GtGQLPaginatorStream >> connectorPath [
	<return: #Collection>
	^ connectorPath
]

{ #category : #'api - initialization' }
GtGQLPaginatorStream >> connectorPath: anObject [

	connectorPath := anObject
]

{ #category : #accessing }
GtGQLPaginatorStream >> cursorInputName [
	<return: #String>
	^ cursorInputName
]

{ #category : #'api - initialization' }
GtGQLPaginatorStream >> cursorInputName: anObject [

	cursorInputName := anObject
]

{ #category : #accessing }
GtGQLPaginatorStream >> endCursorName [
	<return: #String>
	^ endCursorName
]

{ #category : #'api - initialization' }
GtGQLPaginatorStream >> endCursorName: anObject [

	endCursorName := anObject
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> ensurePageInfoType [
	"Return true if the `lastResult` was modified, false otherwise"

	<return: #Boolean>
	| anInserter |
	anInserter := GtGQLPageInfoInserter new
			schema: lastResult configuration schema;
			query: lastResult query;
			connectorPath: self connectorPath;
			insert.

	anInserter hasModifications ifFalse: [ ^ false ].

	lastResult := GtGQLPreparation new
			configuration: lastResult configuration;
			query: anInserter modifiedQuery.

	^ true
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> extractFirstItemsIfWithPageInfoType [
	<return: #Collection>
	^ self ensurePageInfoType ifTrue: [ #() ] ifFalse: [ self extractItems ]
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> extractItems [
	<return: #Collection>
	self lastResultExists
		ifFalse: [ done := true.
			^ #() ].

	^ (self connectorObject at: self itemsName) jsonObject ifNil: [ #() ]
]

{ #category : #'gt - extensions' }
GtGQLPaginatorStream >> gtQueryFor: aView [
	<gtView>
	^ aView forward
		title: 'Query';
		priority: 30;
		object: [ lastResult ifNil: [ GtGQLPreparation new ] ];
		view: #gtQueryFor:;
		actionUpdateButton
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> hasNextPage [
	<return: #Boolean>
	| hasNextPage |
	self connectorObject exists ifFalse: [ ^ false ].

	hasNextPage := self hasNextPageObject.
	hasNextPage ifNil: [ ^ false ].
	hasNextPage exists ifFalse: [ ^ false ].
	hasNextPage jsonObject isBoolean ifFalse: [ ^ false ].
	^ hasNextPage jsonObject
]

{ #category : #accessing }
GtGQLPaginatorStream >> hasNextPageName [
	<return: #String>
	^ hasNextPageName
]

{ #category : #'api - initialization' }
GtGQLPaginatorStream >> hasNextPageName: anObject [

	hasNextPageName := anObject
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> hasNextPageObject [
	<return: #GtJson>
	^ self pageInfoObject at: self hasNextPageName
]

{ #category : #initialization }
GtGQLPaginatorStream >> initialize [
	super initialize.
	done := false.
	cursorInputName := #after.
	pageInfoName := #pageInfo.
	hasNextPageName := #hasNextPage.
	endCursorName := #endCursor.
	connectorPath := #().
	itemsName := #edges
]

{ #category : #accessing }
GtGQLPaginatorStream >> itemsName [
	<return: #String>
	^ itemsName
]

{ #category : #'api - initialization' }
GtGQLPaginatorStream >> itemsName: anObject [

	itemsName := anObject
]

{ #category : #accessing }
GtGQLPaginatorStream >> lastResult [
	<return: #GtGQLBasicResult>
	^ lastResult
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> lastResultExists [
	<return: #Boolean>
	^ lastResult isNotNil
		and: [ lastResult isSuccess or: [ lastResult isPreparation ] ]
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> loadNewValues [
	<return: #Collection>
	self configuration
		ifNil: [ done := true.
			^ #() ].

	self lastResultExists
		ifFalse: [ done := true.
			^ #() ].

	(lastResult isSuccess and: [ self hasNextPage not ])
		ifTrue: [ done := true.
			^ #() ].

	lastResult := self configuration client query: self newQuery.

	self lastResultExists
		ifFalse: [ done := true.
			^ #() ].

	^ self extractItems
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> newQuery [
	^ self lastResult query copyWithNewInputs: self nextInputs
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> nextCursorValue [
	<return: #String>
	^ (self pageInfoObject at: self endCursorName) jsonObject
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> nextInputs [
	<return: #Dictionary>
	| anInput aValue |
	anInput := self lastResult query input copy.
	aValue := lastResult isPreparation
			ifTrue: [ nil ]
			ifFalse: [ self nextCursorValue ].
	^ anInput
		at: self cursorInputName put: aValue;
		yourself
]

{ #category : #accessing }
GtGQLPaginatorStream >> pageInfoName [
	<return: #String>
	^ pageInfoName
]

{ #category : #'api - initialization' }
GtGQLPaginatorStream >> pageInfoName: anObject [

	pageInfoName := anObject
]

{ #category : #'private - loading' }
GtGQLPaginatorStream >> pageInfoObject [
	<return: #GtJson>
	^ self connectorObject at: self pageInfoName
]

{ #category : #'api - stream' }
GtGQLPaginatorStream >> pollNext: anAsynchronousContext [
	"Attempt to pull out the next value of this stream, registering the current task for wakeup if the value is not yet available, and returning None if the stream is exhausted.
	There are several possible return values, each indicating a distinct stream state:
	 - Poll::Pending means that this stream's next value is not ready yet. Implementations will ensure that the current task will be notified when the next value may be ready.
	 - Poll::Ready(Some(val)) means that the stream has successfully produced a value, val, and may produce further values on subsequent poll_next calls.
	 - Poll::Ready(None) means that the stream has terminated, and poll_next should not be invoked again."

	<return: #AsyncPoll>
	stream ifNil: [ ^ AsyncPoll ready: AsyncOptionalValue none ].

	^ (stream pollNext: anAsynchronousContext)
		ifReady: [ :aReadyPoll | 
			aReadyPoll value
				ifSome: [ aReadyPoll ]
				ifNone: [ done
						ifTrue: [ aReadyPoll ]
						ifFalse: [ stream := AsyncSequenceStream
									forCollection: [ self loadNewValues ] asAsyncFuture.
							stream pollNext: anAsynchronousContext ] ] ]
		ifPending: [ :aPendingPoll | aPendingPoll ]
]

{ #category : #'api - stream copy' }
GtGQLPaginatorStream >> postSimilarCopy [
	"Is called by similarCopy. self is a shallow copy, implementors should set the fields as necessary to complete the similar copy"

	initialResult
		ifNotNil: [ :aResult | 
			aResult isPreparation
				ifTrue: [ self preparation: aResult ]
				ifFalse: [ aResult isSuccess ifTrue: [ self result: aResult ] ] ]
]

{ #category : #'api - initialization' }
GtGQLPaginatorStream >> preparation: aGtGQLPreparation [
	initialResult := aGtGQLPreparation.
	lastResult := aGtGQLPreparation.
	done := false.
	stream := AsyncSequenceStream
			forCollection: [ self ensurePageInfoType.
				#() ] asAsyncFuture
]

{ #category : #'api - initialization' }
GtGQLPaginatorStream >> result: aGtGQLResult [
	initialResult := aGtGQLResult.
	lastResult := aGtGQLResult.
	done := false.
	stream := AsyncSequenceStream
			forCollection: [ self extractFirstItemsIfWithPageInfoType ] asAsyncFuture
]
