Class {
	#name : #GtGQLDataExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubMiniSchema [
	<gtExample>
	| anAst aSchema anArgument anOrganizationField |
	anAst := self gitHubMiniSchemaAst.
	aSchema := GtGQLSchema new.
	aSchema import: anAst.

	self assert: aSchema isNotNil.
	self assert: aSchema baseTypes size equals: 34.
	self assert: aSchema types size equals: 59.

	anOrganizationField := aSchema queryType fieldNamed: 'organization'.

	self assert: anOrganizationField arguments size equals: 1.

	anArgument := anOrganizationField arguments anyOne.

	self assert: anArgument name equals: 'login'.
	self assert: anArgument type name equals: 'String!'.
	self assert: anArgument description equals: nil.
	self assert: anArgument defaultValue isNil.

	^ aSchema
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubMiniSchemaAst [
	<gtExample>
	| anAst |
	anAst := GraphQLParser parseFile: self gitHubMiniSchemaGraphQLFile.

	self assert: anAst isNotNil.

	^ anAst
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubMiniSchemaGraphQLFile [
	<gtExample>
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/github-mini-schema.graphql'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryStringWithFragmentPageInfoField [
	<gtExample>
	^ 'fragment CommitInfo on Commit {
	history(first: $count, after: $after) {
		edges {
			node {
				author {
					name
					}
					additions
					deletions
					changedFilesIfAvailable
					committedDate
			}
		}
		pageInfo {
			hasPreviousPage
			hasNextPage
			startCursor
			endCursor
		}
	}
}

query GetCommits($count: Int!, $name: String!, $owner: String!, $after: String) {
	repository (owner: $owner, name: $name) {
		defaultBranchRef {
			target {
				...CommitInfo
			}
		}
	}
}'
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryStringWithFragmentWithoutPageInfoField [
	<gtExample>
	^ 'fragment CommitInfo on Commit {
	history(first: $count, after: $after) {
		edges {
			node {
				author {
					name
					}
					additions
					deletions
					changedFilesIfAvailable
					committedDate
			}
		}
	}
}

query GetCommits($count: Int!, $name: String!, $owner: String!, $after: String) {
	repository (owner: $owner, name: $name) {
		defaultBranchRef {
			target {
				...CommitInfo
			}
		}
	}
}'
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryStringWithInlinedFragmentPageInfoField [
	<gtExample>
	^ 'query GetCommits($count: Int!, $name: String!, $owner: String!, $after: String) {
	repository (owner: $owner, name: $name) {
		defaultBranchRef {
			target {
				... on Commit {
					history(first: $count, after: $after) {
						edges {
							node {
								author {
									name
								}
								additions
								deletions
								changedFilesIfAvailable
								committedDate
							}
						}
						pageInfo {
							hasPreviousPage
							hasNextPage
							startCursor
							endCursor
						}
					}
				}
			}
		}
	}
}'
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryStringWithInlinedFragmentWithoutPageInfoField [
	<gtExample>
	^ 'query GetCommits($count: Int!, $name: String!, $owner: String!, $after: String) {
	repository (owner: $owner, name: $name) {
		defaultBranchRef {
			target {
				... on Commit {
					history(first: $count, after: $after) {
						edges {
							node {
								author {
									name
								}
								additions
								deletions
								changedFilesIfAvailable
								committedDate
							}
						}
					}
				}
			}
		}
	}
}'
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryStringWithMissingPageInfoField [
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
			}
		}
	}
}'
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryStringWithOrganizationRepositoriesAndOpenAndClosedIssues [
	<gtExample>
	^ 'fragment IssueDetails on IssueConnection {
	__typename
	totalCount
}

query Repositories($count: Int!, $login: String!, $after: String, $privacy: RepositoryPrivacy) {
	organization (login: $login) {
		login
		name
		url
		repositories(first: $count, after: $after, privacy: $privacy) {
			totalCount
			totalDiskUsage
			edges {
				node {
					__typename
					id
					name
					sshUrl
					url
					owner {
						__typename
						id 
						login
						url
						...on User { 
							bio
							isEmployee
						}
						...on Organization {
							email
							isVerified
						}
					}
					openIssues: issues(states: [ OPEN ]) {
						...IssueDetails
					}
					closedIssues: issues(states: [ CLOSED ]) {
						...IssueDetails
					}
					forks {
						totalCount
					}
				}
			}
			pageInfo {
				hasNextPage
				startCursor
				endCursor
			}
		}
	}
}'
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryWithFragmentPageInfoField [
	<gtExample>
	| aQuery anOperation |
	aQuery := GtGQLQuery new.
	anOperation := self gitHubQueryStringWithFragmentPageInfoField.

	aQuery operation: anOperation.

	self assert: aQuery operation equals: anOperation.

	^ aQuery
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryWithFragmentWithoutPageInfoField [
	<gtExample>
	| aQuery anOperation |
	aQuery := GtGQLQuery new.
	anOperation := self gitHubQueryStringWithFragmentWithoutPageInfoField.

	aQuery operation: anOperation.

	self assert: aQuery operation equals: anOperation.

	^ aQuery
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryWithInlinedFragmentPageInfoField [
	<gtExample>
	| aQuery anOperation |
	aQuery := GtGQLQuery new.
	anOperation := self gitHubQueryStringWithInlinedFragmentPageInfoField.

	aQuery operation: anOperation.

	self assert: aQuery operation equals: anOperation.

	^ aQuery
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryWithInlinedFragmentWithoutPageInfoField [
	<gtExample>
	| aQuery anOperation |
	aQuery := GtGQLQuery new.
	anOperation := self gitHubQueryStringWithInlinedFragmentWithoutPageInfoField.

	aQuery operation: anOperation.

	self assert: aQuery operation equals: anOperation.

	^ aQuery
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryWithMissingPageInfoField [
	<gtExample>
	| aQuery anOperation |
	aQuery := GtGQLQuery new.
	anOperation := self gitHubQueryStringWithMissingPageInfoField.

	aQuery operation: anOperation.

	self assert: aQuery operation equals: anOperation.

	^ aQuery
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues [
	<gtExample>
	| aQuery anOperation |
	aQuery := GtGQLQuery new.
	anOperation := self
			gitHubQueryStringWithOrganizationRepositoriesAndOpenAndClosedIssues.

	aQuery operation: anOperation.

	self assert: aQuery operation equals: anOperation.

	^ aQuery
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubRepositoriesJsonFile [
	<gtExample>
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/github-repositories.json'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubRepositoriesJsonObject [
	<gtExample>
	| aJson |
	aJson := STONJSON fromString: self gitHubRepositoriesJsonFile.

	self assert: aJson isNotNil.
	self assert: aJson isDictionary.
	self assert: aJson isNotEmpty.

	^ aJson
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubRepositoriesWithOpenAndClosedIssuesJson [
	<gtExample>
	| aJson |
	aJson := GtJson
			forJsonString: self gitHubRepositoriesWithOpenAndClosedIssuesJsonString.

	self assert: aJson isNotNil.
	self assert: aJson exists.
	self assert: aJson jsonObject isDictionary.
	self assert: aJson jsonObject isNotEmpty.

	^ aJson
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubRepositoriesWithOpenAndClosedIssuesJsonData [
	<gtExample>
	| aJson aData |
	aJson := self gitHubRepositoriesWithOpenAndClosedIssuesJson.
	aData := aJson at: #data.

	self assert: aData isNotNil.
	self assert: aData exists.
	self assert: aData jsonObject isDictionary.
	self assert: aData jsonObject isNotEmpty.

	^ aData
]

{ #category : #'examples - github' }
GtGQLDataExamples >> gitHubRepositoriesWithOpenAndClosedIssuesJsonString [
	<gtExample>
	^ '{
	"data" : {
		"organization" : {
			"login" : "feenkcom",
			"name" : "feenk",
			"url" : "https://github.com/feenkcom",
			"repositories" : {
				"totalCount" : 174,
				"totalDiskUsage" : 818825,
				"edges" : [
					{
						"node" : {
							"__typename" : "Repository",
							"id" : "MDEwOlJlcG9zaXRvcnk0MDA3NTQyMg==",
							"name" : "jdt2famix",
							"sshUrl" : "git@github.com:feenkcom/jdt2famix.git",
							"url" : "https://github.com/feenkcom/jdt2famix",
							"owner" : {
								"__typename" : "Organization",
								"id" : "MDEyOk9yZ2FuaXphdGlvbjIyMTIyMzY2",
								"login" : "feenkcom",
								"url" : "https://github.com/feenkcom",
								"email" : null,
								"isVerified" : false
							},
							"openIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 22
							},
							"closedIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 15
							},
							"forks" : {
								"totalCount" : 21
							}
						}
					},
					{
						"node" : {
							"__typename" : "Repository",
							"id" : "MDEwOlJlcG9zaXRvcnk0NjExOTIwMA==",
							"name" : "FameJava",
							"sshUrl" : "git@github.com:feenkcom/FameJava.git",
							"url" : "https://github.com/feenkcom/FameJava",
							"owner" : {
								"__typename" : "Organization",
								"id" : "MDEyOk9yZ2FuaXphdGlvbjIyMTIyMzY2",
								"login" : "feenkcom",
								"url" : "https://github.com/feenkcom",
								"email" : null,
								"isVerified" : false
							},
							"openIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 0
							},
							"closedIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 0
							},
							"forks" : {
								"totalCount" : 4
							}
						}
					},
					{
						"node" : {
							"__typename" : "Repository",
							"id" : "MDEwOlJlcG9zaXRvcnk2MDExMjU0Ng==",
							"name" : "libMoz2D",
							"sshUrl" : "git@github.com:feenkcom/libMoz2D.git",
							"url" : "https://github.com/feenkcom/libMoz2D",
							"owner" : {
								"__typename" : "Organization",
								"id" : "MDEyOk9yZ2FuaXphdGlvbjIyMTIyMzY2",
								"login" : "feenkcom",
								"url" : "https://github.com/feenkcom",
								"email" : null,
								"isVerified" : false
							},
							"openIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 3
							},
							"closedIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 2
							},
							"forks" : {
								"totalCount" : 2
							}
						}
					},
					{
						"node" : {
							"__typename" : "Repository",
							"id" : "MDEwOlJlcG9zaXRvcnk2NjM3Njk5NA==",
							"name" : "sparta",
							"sshUrl" : "git@github.com:feenkcom/sparta.git",
							"url" : "https://github.com/feenkcom/sparta",
							"owner" : {
								"__typename" : "Organization",
								"id" : "MDEyOk9yZ2FuaXphdGlvbjIyMTIyMzY2",
								"login" : "feenkcom",
								"url" : "https://github.com/feenkcom",
								"email" : null,
								"isVerified" : false
							},
							"openIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 2
							},
							"closedIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 4
							},
							"forks" : {
								"totalCount" : 6
							}
						}
					},
					{
						"node" : {
							"__typename" : "Repository",
							"id" : "MDEwOlJlcG9zaXRvcnk2OTI5MTYyMA==",
							"name" : "gt4gemstone-old",
							"sshUrl" : "git@github.com:feenkcom/gt4gemstone-old.git",
							"url" : "https://github.com/feenkcom/gt4gemstone-old",
							"owner" : {
								"__typename" : "Organization",
								"id" : "MDEyOk9yZ2FuaXphdGlvbjIyMTIyMzY2",
								"login" : "feenkcom",
								"url" : "https://github.com/feenkcom",
								"email" : null,
								"isVerified" : false
							},
							"openIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 35
							},
							"closedIssues" : {
								"__typename" : "IssueConnection",
								"totalCount" : 24
							},
							"forks" : {
								"totalCount" : 4
							}
						}
					}
				],
				"pageInfo" : {
					"hasNextPage" : true,
					"startCursor" : "Y3Vyc29yOnYyOpHOAmOAng==",
					"endCursor" : "Y3Vyc29yOnYyOpHOBCFOZA=="
				}
			}
		}
	}
}'
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> graphQLIntrospectionSchema [
	<gtExample>
	| aFile aSchema anAst |
	aFile := self graphQLIntrospectionSchemaFile.

	anAst := GraphQLParser parseFile: aFile.
	aSchema := GtGQLSchema new
			import: anAst;
			yourself.

	self assert: aSchema isNotNil.
	self assert: aSchema baseTypes size equals: 13.
	self assert: aSchema types size equals: 30.

	^ aSchema
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> graphQLIntrospectionSchemaFile [
	<gtExample>
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/graphql-introspection.graphql'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> inputTypeAst [
	<gtExample>
	| anAst |
	anAst := GraphQLParser parse: self inputTypeGraphQLSchemaString.

	self assert: anAst isNotNil.

	^ anAst
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> inputTypeGraphQLSchemaString [
	<gtExample>
	^ '
input ReviewInput {
  stars: Int!
  commentary: String
}
'
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> inputTypeSchema [
	<gtExample>
	| anAst aSchema aType |
	anAst := self inputTypeAst.
	aSchema := GtGQLSchema new.
	aSchema import: anAst.

	self assert: aSchema isNotNil.
	self assert: aSchema baseTypes size equals: 6.
	self assert: aSchema types size equals: 8.

	aType := aSchema typeNamed: 'ReviewInput'.
	self assert: aType isNotNil.
	self assert: aType inputFields isDictionary.
	self assert: aType inputFields size equals: 2.
	self assert: aType inputFields == aType fields.

	^ aSchema
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> interfaceAst [
	<gtExample>
	| anAst |
	anAst := GraphQLParser parse: self interfaceGraphQLSchemaString.

	self assert: anAst isNotNil.

	^ anAst
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> interfaceGraphQLSchemaString [
	<gtExample>
	^ '
interface Character {
  id: ID!
  name: String!
  friends: [Character]
}

type Human implements Character {
  id: ID!
  name: String!
  friends: [Character]
  totalCredits: Int
}

type Droid implements Character {
  id: ID!
  name: String!
  friends: [Character]
  primaryFunction: String
}
'
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> interfaceSchema [
	<gtExample>
	| anAst aSchema |
	anAst := self interfaceAst.
	aSchema := GtGQLSchema new.
	aSchema import: anAst.

	self assert: aSchema isNotNil.

	^ aSchema
]

{ #category : #'examples - star wars' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonFile [
	<gtExample>
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/starwars-json-schema.json'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #'examples - star wars' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonObject [
	<gtExample>
	| aJson |
	aJson := STONJSON fromString: self starWarsGraphQLSchemaJsonString.

	self assert: aJson isNotNil.
	self assert: aJson isDictionary.
	self assert: aJson isNotEmpty.

	^ aJson
]

{ #category : #'examples - star wars' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonString [
	<gtExample>
	| aFile aContents |
	aFile := self starWarsGraphQLSchemaJsonFile.
	aContents := aFile contents.
	self assert: aContents isString.
	^ aContents
]
