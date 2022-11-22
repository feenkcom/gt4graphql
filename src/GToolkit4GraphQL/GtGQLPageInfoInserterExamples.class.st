Class {
	#name : #GtGQLPageInfoInserterExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - inserter' }
GtGQLPageInfoInserterExamples >> basicInserter [
	<gtExample>
	| anInserter |
	anInserter := GtGQLPageInfoInserter new.

	self assert: anInserter schema isNil description: [ 'Schema must be nil' ].
	self assert: anInserter query isNil description: [ 'Query must be nil' ].

	self
		assert: anInserter modifiedQuery isNil
		description: [ 'Modified query must be nil' ].
	self
		assert: anInserter hasModifications not
		description: [ 'Inserter must not have modifications' ].


	self
		assert: anInserter connectorPaths isEmpty
		description: [ 'Connector paths must be empty' ].
	self
		assert: anInserter unfulfilledFields isNil
		description: [ 'Unfulfilled fields must be nil' ].

	^ anInserter
]

{ #category : #'examples - schema' }
GtGQLPageInfoInserterExamples >> gitHubMiniSchema [
	<gtExample>
	^ GtGQLDataExamples new gitHubMiniSchema
]

{ #category : #accessing }
GtGQLPageInfoInserterExamples >> gitHubQueryWithMissingPageInfoField [
	<gtExample>
	^ GtGQLDataExamples new gitHubQueryWithMissingPageInfoField
]

{ #category : #accessing }
GtGQLPageInfoInserterExamples >> inserterOfQueryStringWithMissingPageInfoField [
	<gtExample>
	| anInserter aQuery aSchema aModifiedQuery |
	anInserter := self basicInserter.
	aQuery := self gitHubQueryWithMissingPageInfoField.
	aSchema := self gitHubMiniSchema.

	anInserter query: aQuery.
	anInserter schema: aSchema.

	self assert: anInserter query equals: aQuery.
	self assert: anInserter schema equals: aSchema.
	self
		assert: anInserter hasModifications not
		description: [ 'Inserter must not have modifications' ].
	self
		assert: anInserter unfulfilledFields isNil
		description: [ 'Unfulfilled fields must be nil' ].

	anInserter insert.

	self assert: anInserter unfulfilledFields size equals: 2.
	self
		assert: anInserter modifiedQuery isNotNil
		description: [ 'Modified query must exist' ].
		
	aModifiedQuery := anInserter modifiedQuery.
	
	self assert: aModifiedQuery operation equals: self modifiedQueryStringWithAddedPageInfoFields.

	^ anInserter
]

{ #category : #accessing }
GtGQLPageInfoInserterExamples >> inserterOfQueryStringWithMissingPageInfoField_DefinedConnectoPath [
	<gtExample>
	| anInserter aQuery aSchema aModifiedQuery |
	anInserter := self basicInserter.
	aQuery := self gitHubQueryWithMissingPageInfoField.
	aSchema := self gitHubMiniSchema.

	anInserter query: aQuery.
	anInserter schema: aSchema.
	anInserter connectorPath: #(organization repos).

	self assert: anInserter query equals: aQuery.
	self assert: anInserter schema equals: aSchema.
	self
		assert: anInserter hasModifications not
		description: [ 'Inserter must not have modifications' ].
	self
		assert: anInserter unfulfilledFields isNil
		description: [ 'Unfulfilled fields must be nil' ].

	anInserter insert.

	self assert: anInserter unfulfilledFields size equals: 2.
	self
		assert: anInserter modifiedQuery isNotNil
		description: [ 'Modified query must exist' ].

	aModifiedQuery := anInserter modifiedQuery.

	self
		assert: aModifiedQuery operation
		equals: self modifiedQueryStringWithAddedPageInfoFields_DefinedConnectoPath.

	^ anInserter
]

{ #category : #'examples - queries' }
GtGQLPageInfoInserterExamples >> modifiedQueryStringWithAddedPageInfoFields [
	<gtExample>
	^ 'query Repositories($count: Int!, $login: String!, $after: String, $privacy: RepositoryPrivacy) {
	organization (login: $login) {
		name
		url
		repos: repositories(first: $count, after: $after, privacy: $privacy) {
			totalCount
			totalDiskUsage
			edges {
				node {
					name
					sshUrl
					url
					forks {
						totalCount
						pageInfo {
							hasNextPage
							hasPreviousPage
							endCursor
							startCursor
						}
					}
				}
			}
			info: pageInfo {
				hasNextPage
				startCursor
				endCursor
				hasPreviousPage
			}
		}
	}
}'
]

{ #category : #'examples - queries' }
GtGQLPageInfoInserterExamples >> modifiedQueryStringWithAddedPageInfoFields_DefinedConnectoPath [
	<gtExample>
	^ 'query Repositories($count: Int!, $login: String!, $after: String, $privacy: RepositoryPrivacy) {
	organization (login: $login) {
		name
		url
		repos: repositories(first: $count, after: $after, privacy: $privacy) {
			totalCount
			totalDiskUsage
			edges {
				node {
					name
					sshUrl
					url
					forks {
						totalCount
					}
				}
			}
			info: pageInfo {
				hasNextPage
				startCursor
				endCursor
				hasPreviousPage
			}
		}
	}
}'
]