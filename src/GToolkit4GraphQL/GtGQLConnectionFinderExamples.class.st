Class {
	#name : #GtGQLConnectionFinderExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - finder' }
GtGQLConnectionFinderExamples >> basicFinder [
	<gtExample>
	<return: #GtGQLConnectionFinder>
	| aFinder |
	aFinder := GtGQLConnectionFinder new.

	self assert: aFinder schema isNil description: [ 'Schema must be nil' ].
	self assert: aFinder ast isNil description: [ 'AST must be nil' ].
	self assert: aFinder fields isEmpty description: [ 'Fields must be empty' ].
	self
		assert: aFinder unfulfilledFields isEmpty
		description: [ 'Unfulfilled fields must be empty' ].

	^ aFinder
]

{ #category : #'examples - finder' }
GtGQLConnectionFinderExamples >> finderOfQueryStringWithInlinedFragmentPageInfoField [
	<gtExample>
	<return: #GtGQLConnectionFinder>
	| aFinder aQuery aSchema |
	aFinder := self basicFinder.
	aQuery := self gitHubQueryWithInlinedFragmentPageInfoField.
	aSchema := self gitHubMiniSchema.

	aFinder query: aQuery.
	aFinder schema: aSchema.

	self assert: aFinder ast isNotNil description: [ 'AST must be non-nil' ].
	self assert: aFinder schema equals: aSchema.
	self assert: aFinder fields isEmpty description: [ 'Fields must be empty' ].
	self
		assert: aFinder unfulfilledFields isEmpty
		description: [ 'Unfulfilled fields must be empty' ].

	aFinder find.

	self assert: aFinder fields size equals: 1.
	self assert: aFinder unfulfilledFields size equals: 0.

	^ aFinder
]

{ #category : #'examples - finder' }
GtGQLConnectionFinderExamples >> finderOfQueryStringWithInlinedFragmentWithoutPageInfoField [
	<gtExample>
	<return: #GtGQLConnectionFinder>
	| aFinder aQuery aSchema |
	aFinder := self basicFinder.
	aQuery := self gitHubQueryWithInlinedFragmentWithoutPageInfoField.
	aSchema := self gitHubMiniSchema.

	aFinder query: aQuery.
	aFinder schema: aSchema.

	self assert: aFinder ast isNotNil description: [ 'AST must be non-nil' ].
	self assert: aFinder schema equals: aSchema.
	self assert: aFinder fields isEmpty description: [ 'Fields must be empty' ].
	self
		assert: aFinder unfulfilledFields isEmpty
		description: [ 'Unfulfilled fields must be empty' ].

	aFinder find.

	self assert: aFinder fields size equals: 1.
	self assert: aFinder unfulfilledFields size equals: 1.

	^ aFinder
]

{ #category : #'examples - finder' }
GtGQLConnectionFinderExamples >> finderOfQueryStringWithMissingPageInfoField [
	<gtExample>
	<return: #GtGQLConnectionFinder>
	| aFinder aQuery aSchema |
	aFinder := self basicFinder.
	aQuery := self gitHubQueryWithMissingPageInfoField.
	aSchema := self gitHubMiniSchema.

	aFinder query: aQuery.
	aFinder schema: aSchema.

	self assert: aFinder ast isNotNil description: [ 'AST must be non-nil' ].
	self assert: aFinder schema equals: aSchema.
	self assert: aFinder fields isEmpty description: [ 'Fields must be empty' ].
	self
		assert: aFinder unfulfilledFields isEmpty
		description: [ 'Unfulfilled fields must be empty' ].

	aFinder find.

	self assert: aFinder fields size equals: 2.
	self assert: aFinder unfulfilledFields size equals: 2.

	^ aFinder
]

{ #category : #'examples - finder' }
GtGQLConnectionFinderExamples >> finderOfQueryWithFragmentPageInfoField [
	<gtExample>
	<return: #GtGQLConnectionFinder>
	| aFinder aQuery aSchema |
	aFinder := self basicFinder.
	aQuery := self gitHubQueryWithFragmentPageInfoField.
	aSchema := self gitHubMiniSchema.

	aFinder query: aQuery.
	aFinder schema: aSchema.

	self assert: aFinder ast isNotNil description: [ 'AST must be non-nil' ].
	self assert: aFinder schema equals: aSchema.
	self assert: aFinder fields isEmpty description: [ 'Fields must be empty' ].
	self
		assert: aFinder unfulfilledFields isEmpty
		description: [ 'Unfulfilled fields must be empty' ].

	aFinder find.

	self assert: aFinder fields size equals: 1.
	self assert: aFinder unfulfilledFields size equals: 0.

	^ aFinder
]

{ #category : #'examples - finder' }
GtGQLConnectionFinderExamples >> finderOfQueryWithFragmentWithoutPageInfoField [
	<gtExample>
	<return: #GtGQLConnectionFinder>
	| aFinder aQuery aSchema |
	aFinder := self basicFinder.
	aQuery := self gitHubQueryWithFragmentWithoutPageInfoField.
	aSchema := self gitHubMiniSchema.

	aFinder query: aQuery.
	aFinder schema: aSchema.

	self assert: aFinder ast isNotNil description: [ 'AST must be non-nil' ].
	self assert: aFinder schema equals: aSchema.
	self assert: aFinder fields isEmpty description: [ 'Fields must be empty' ].
	self
		assert: aFinder unfulfilledFields isEmpty
		description: [ 'Unfulfilled fields must be empty' ].

	aFinder find.

	self assert: aFinder fields size equals: 1.
	self assert: aFinder unfulfilledFields size equals: 1.

	^ aFinder
]

{ #category : #'examples - schema' }
GtGQLConnectionFinderExamples >> gitHubMiniSchema [
	<gtExample>
	<return: #GtGQLSchema>
	^ GtGQLDataExamples new gitHubMiniSchema
]

{ #category : #'examples - queries' }
GtGQLConnectionFinderExamples >> gitHubQueryWithFragmentPageInfoField [
	<gtExample>
	<return: #GtGQLQuery>
	^ GtGQLDataExamples new gitHubQueryWithFragmentPageInfoField
]

{ #category : #'examples - queries' }
GtGQLConnectionFinderExamples >> gitHubQueryWithFragmentWithoutPageInfoField [
	<gtExample>
	<return: #GtGQLQuery>
	^ GtGQLDataExamples new gitHubQueryWithFragmentWithoutPageInfoField
]

{ #category : #'examples - queries' }
GtGQLConnectionFinderExamples >> gitHubQueryWithInlinedFragmentPageInfoField [
	<gtExample>
	<return: #GtGQLQuery>
	^ GtGQLDataExamples new gitHubQueryWithInlinedFragmentPageInfoField
]

{ #category : #'examples - queries' }
GtGQLConnectionFinderExamples >> gitHubQueryWithInlinedFragmentWithoutPageInfoField [
	<gtExample>
	<return: #GtGQLQuery>
	^ GtGQLDataExamples new gitHubQueryWithInlinedFragmentWithoutPageInfoField
]

{ #category : #'examples - queries' }
GtGQLConnectionFinderExamples >> gitHubQueryWithMissingPageInfoField [
	<gtExample>
	<return: #GtGQLQuery>
	^ GtGQLDataExamples new gitHubQueryWithMissingPageInfoField
]
