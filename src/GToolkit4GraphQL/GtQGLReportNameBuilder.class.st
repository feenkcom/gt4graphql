"
nil
"
Class {
	#name : #GtQGLReportNameBuilder,
	#superclass : #Object,
	#instVars : [
		'report',
		'name'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'private - building' }
GtQGLReportNameBuilder >> allNamePragmas [
	^ Pragma
		allNamed: #gtGraphQLName
		from: self report class
		to: GtGQLReport
]

{ #category : #'api - building' }
GtQGLReportNameBuilder >> build [
	| allPragmas |
	allPragmas := self allNamePragmas.

	allPragmas
		do: [ :eachPragma | 
			(self report perform: eachPragma methodSelector)
				ifNotNil: [ :aName | 
					name := aName.
					^ self ] ]
]

{ #category : #accessing }
GtQGLReportNameBuilder >> name [
	^ name ifNil: [ '?' ]
]

{ #category : #accessing }
GtQGLReportNameBuilder >> report [
	^ report
]

{ #category : #accessing }
GtQGLReportNameBuilder >> report: anObject [
	report := anObject
]
