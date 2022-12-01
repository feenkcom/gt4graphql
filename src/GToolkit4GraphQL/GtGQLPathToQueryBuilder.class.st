"
I take a {{gtClass:GtGQLTypePath}} and build {{gtClass:GtGQLQuery}} with a query operation text.

"
Class {
	#name : #GtGQLPathToQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'path',
		'query'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> build [
	self buildQuery.
	^ self query
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> buildOperation [
	^ String
		streamContents: [ :aStream | 
			| indentation |
			indentation := 0.

			aStream
				nextPutAll: 'query {';
				cr.
			indentation := indentation + 1.

			self path steps
				do: [ :eachStep | 
					| aFieldName |
					aFieldName := eachStep field name.

					indentation timesRepeat: [ aStream tab ].

					aStream nextPutAll: aFieldName.

					eachStep = self path leafStep
						ifTrue: [ (self hasFieldTypeWithSelections: eachStep)
								ifTrue: [ aStream nextPutAll: ' {' ] ]
						ifFalse: [ aStream nextPutAll: ' {' ].

					indentation := indentation + 1.

					(self isTypeWithSelections: eachStep type baseType)
						ifTrue: [ aStream cr.
							indentation timesRepeat: [ aStream tab ].
							aStream nextPutAll: GtGQLIntrospectionConstants metaMetaTypeName ].

					aStream cr ].

			self path steps
				reverseDo: [ :eachStep | 
					indentation := indentation - 1.

					indentation timesRepeat: [ aStream tab ].

					eachStep = self path leafStep
						ifTrue: [ (self hasFieldTypeWithSelections: eachStep)
								ifTrue: [ aStream nextPutAll: '}' ] ]
						ifFalse: [ aStream nextPutAll: '}' ].
					aStream cr ].

			aStream
				nextPut: $};
				cr ]
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> buildQuery [
	query := GtGQLQuery new operation: self buildOperation
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> hasFieldTypeWithSelections: eachStep [
	^ self isTypeWithSelections: eachStep fieldBaseType
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> isTypeWithSelections: aBaseType [
	^ aBaseType isComposite or: [ aBaseType isUnion ]
]

{ #category : #accessing }
GtGQLPathToQueryBuilder >> path [
	^ path
]

{ #category : #accessing }
GtGQLPathToQueryBuilder >> path: anObject [
	path := anObject
]

{ #category : #accessing }
GtGQLPathToQueryBuilder >> query [
	^ query
]

{ #category : #accessing }
GtGQLPathToQueryBuilder >> query: anObject [
	query := anObject
]
