Class {
	#name : #GtGQLPaginatorStreamExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #accessing }
GtGQLPaginatorStreamExamples >> basicPaginator [
	<gtExample>
	<return: #GtGQLPaginatorStream>
	| aPaginator |
	aPaginator := GtGQLPaginatorStream new.

	self
		assert: aPaginator lastResult isNil
		description: [ 'Last result must be nil' ].

	^ aPaginator
]

{ #category : #accessing }
GtGQLPaginatorStreamExamples >> paginatorWithGitHubQueryWithMissingPageInfoField_PreparationResult [
	<gtExample>
	<return: #GtGQLPaginatorStream>
	| aPaginator aResult aQuery |
	aResult := self preparationResultWithGitHubQueryWithMissingPageInfoField.
	aPaginator := aResult paginator.

	aPaginator
		cursorInputName: #after;
		connectorPath: #(organization repos);
		itemsName: #edges.

	self assert: aPaginator lastResult equals: aResult.

	aQuery := aPaginator ensurePageInfoTypeInQuery: aResult query.
	self
		assert: (aQuery isKindOf: GtGQLModifiedQuery)
		description: [ 'Query must be a modified query' ].

	^ aPaginator
]

{ #category : #accessing }
GtGQLPaginatorStreamExamples >> preparationResultWithGitHubQueryWithMissingPageInfoField [
	<gtExample>
	<return: #GtGQLPreparation>
	| aResult aQuery aContext |
	aResult := GtGQLPreparation new.

	aQuery := GtGQLQuery new
			operation: GtGQLDataExamples new gitHubQueryStringWithMissingPageInfoField;
			input: (Dictionary new
					at: #count put: 5;
					at: #login put: 'feenkcom';
					at: #after put: nil;
					at: #privacy put: 'PUBLIC';
					yourself).

	aContext := GtGQLContext new.
	aContext schema: GtGQLDataExamples new gitHubMiniSchema.

	aResult query: aQuery.
	aResult context: aContext.

	self assert: aResult query equals: aQuery.
	self assert: aResult context equals: aContext.

	^ aResult
]
