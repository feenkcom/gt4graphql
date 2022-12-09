Class {
	#name : #GtGQLLepiterExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #asserting }
GtGQLLepiterExamples >> assertActualSnippet: aDeserializedSnippet expectedSnippet: aSnippet [
	self assert: aDeserializedSnippet operation equals: aSnippet operation.
	self assert: aDeserializedSnippet input equals: aSnippet input.
	self assert: aDeserializedSnippet context equals: aSnippet context
]

{ #category : #asserting }
GtGQLLepiterExamples >> assertPageSerialization: aPage [
	| aSerializedString aDeserializedPage |
	aSerializedString := self serialize: aPage.
	aDeserializedPage := self deserialize: aSerializedString.

	self assert: aDeserializedPage children size equals: aPage children size.
	self assert: aDeserializedPage title equals: aPage title.
	self assert: aDeserializedPage uid equals: aPage uid.

	aPage children
		withIndexDo: [ :aSnippet :anIndex | 
			(aSnippet isKindOf: GtGQLSnippet)
				ifTrue: [ self
						assertActualSnippet: (aDeserializedPage children at: anIndex)
						expectedSnippet: aSnippet ] ]
]

{ #category : #asserting }
GtGQLLepiterExamples >> assertSnippetSerialization: aSnippet [
	| aSerializedString aDeserializedSnippet |
	aSerializedString := self serialize: aSnippet.
	aDeserializedSnippet := self deserialize: aSerializedString.
	self assertActualSnippet: aDeserializedSnippet expectedSnippet: aSnippet
]

{ #category : #support }
GtGQLLepiterExamples >> deserialize: aString [
	^ LeJsonV4 uniqueInstance deserialize: aString readStream
]

{ #category : #'examples - snippet' }
GtGQLLepiterExamples >> graphQLContext [
	<gtExample>
	^ 'aContext'
]

{ #category : #'examples - snippet' }
GtGQLLepiterExamples >> graphQLInput [
	<gtExample>
	^ '{ "input" : { "name" : "input name" } }'
]

{ #category : #'examples - snippet' }
GtGQLLepiterExamples >> graphQLOperation [
	<gtExample>
	^ '# This is a GraphQL snippet'
]

{ #category : #'examples - snippet' }
GtGQLLepiterExamples >> graphQLSnippet [
	<gtExample>
	| aSnippet |
	aSnippet := GtGQLSnippet new.

	aSnippet operation: self graphQLOperation.
	aSnippet input: self graphQLInput.
	aSnippet context: self graphQLContext.

	self assert: aSnippet operation equals: self graphQLOperation.
	self assert: aSnippet input equals: self graphQLInput.
	self assert: aSnippet context equals: self graphQLContext.

	self assertSnippetSerialization: aSnippet.

	^ aSnippet
]

{ #category : #'examples - page' }
GtGQLLepiterExamples >> pageWithLevelOneGraphQLSnippet [
	<gtExample>
	| aPage aSnippet |
	aPage := LePage new.
	aSnippet := self graphQLSnippet.

	aPage addSnippet: aSnippet.

	self assert: aPage children size equals: 1.
	self assert: aPage children anyOne equals: aSnippet.
	self assert: aSnippet parent equals: aPage.
	self assertPageSerialization: aPage.

	^ aPage
]

{ #category : #support }
GtGQLLepiterExamples >> serialize: anObject [
	^ String
		streamContents: [ :stream | 
			LeJsonV4 uniqueInstance
				serialize: anObject
				on: stream
				prettyPrint: false ]
]
