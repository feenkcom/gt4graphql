Extension { #name : #MovingPagesExamples }

{ #category : #'*GToolkit4GraphQL' }
MovingPagesExamples >> gqlSnippetPage [
	<moveablePage>
	<gtExample>
	<return: #LePage>
	^ (LePage named: 'A Graph QL snippet page')
		addSnippet: GtGQLLepiterExamples new graphQLSnippet;
		yourself
]
