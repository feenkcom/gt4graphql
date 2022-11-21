Class {
	#name : #GtGQLConnectionFieldExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - finder' }
GtGQLConnectionFieldExamples >> basicFinder [
	<gtExample>
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
GtGQLConnectionFieldExamples >> finderOfQueryStringWithMissingPageInfoField [
	<gtExample>
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

{ #category : #'examples - schema' }
GtGQLConnectionFieldExamples >> gitHubMiniSchema [
	<gtExample>
	^ GtGQLDataExamples new gitHubMiniSchema
]

{ #category : #'examples - queries' }
GtGQLConnectionFieldExamples >> gitHubQueryWithMissingPageInfoField [
	<gtExample>
	^ GtGQLDataExamples new gitHubQueryWithMissingPageInfoField
]
