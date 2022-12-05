"
I take a {{gtClass:GtGQLTypePath}} and build {{gtClass:GtGQLQuery}} with a query operation text.

"
Class {
	#name : #GtGQLPathToQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'path',
		'query',
		'indentation',
		'stream',
		'currentStep',
		'variables'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> build [
	self buildQuery
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> buildClosingPath [
	self path steps
		reverseDo: [ :eachStep | 
			self decreaseIndentation.
			self nextPutIndentationTabs.

			eachStep = self path leafStep
				ifTrue: [ (self hasFieldTypeWithSelections: eachStep) ifTrue: [ stream nextPutAll: '}' ] ]
				ifFalse: [ stream nextPutAll: '}' ].
			stream cr ]
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> buildCurrentStep [
	| aFieldName |
	self nextPutIndentationTabs.

	aFieldName := currentStep field name.
	stream nextPutAll: aFieldName.

	self buildFieldArguments.

	self isCurrentStepLeaf
		ifTrue: [ (self hasFieldTypeWithSelections: currentStep)
				ifTrue: [ stream nextPutAll: ' {' ] ]
		ifFalse: [ stream nextPutAll: ' {' ].

	self increaseIndentation.

	(self isTypeWithSelections: currentStep type baseType)
		ifTrue: [ | shouldDecreaseIndentation |
			shouldDecreaseIndentation := false.

			self isCurrentStepLeaf
				ifTrue: [ self path stopType = currentStep fieldBaseType
						ifFalse: [ stream cr.
							self nextPutIndentationTabs.
							stream nextPutAll: '...on '.
							stream nextPutAll: self path stopType name.

							(self hasFieldTypeWithSelections: currentStep)
								ifTrue: [ stream nextPutAll: ' {' ].

							self increaseIndentation.
							shouldDecreaseIndentation := true ] ].

			stream cr.
			self nextPutIndentationTabs.
			stream nextPutAll: GtGQLIntrospectionConstants metaMetaTypeName.

			shouldDecreaseIndentation
				ifTrue: [ self decreaseIndentation.
					stream cr.
					self nextPutIndentationTabs.
					stream nextPut: $} ] ].

	stream cr
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> buildFieldArguments [
	| fieldArguments requiredArguments |
	fieldArguments := currentStep field arguments.
	fieldArguments ifEmpty: [ ^ self ].

	requiredArguments := fieldArguments select: #isRequired.

	currentStep field arguments
		detect: [ :anArgument | anArgument name = 'first' ]
		ifFound: [ :anArgument | requiredArguments := {anArgument} , requiredArguments ]
		ifNone: [  "ignore" ].

	currentStep field arguments
		detect: [ :anArgument | anArgument name = 'after' ]
		ifFound: [ :anArgument | requiredArguments := {anArgument} , requiredArguments ]
		ifNone: [  "ignore" ].

	requiredArguments ifEmpty: [ ^ self ].

	stream nextPut: $(.

	requiredArguments
		do: [ :anArgument | 
			| aVariableName |
			stream nextPutAll: anArgument name.

			aVariableName := self variableNameForArgument: anArgument.

			stream nextPutAll: ': $'.
			stream nextPutAll: aVariableName ]
		separatedBy: [ stream nextPutAll: ', ' ].

	stream nextPut: $)
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> buildOpeningPath [
	self path steps
		do: [ :eachStep | 
			currentStep := eachStep.
			self buildCurrentStep.
			currentStep := nil ]
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> buildOperation [
	| anOperation aQueryName |
	anOperation := String
			streamContents: [ :aStream | 
				variables := OrderedDictionary new.
				indentation := 0.
				stream := aStream.
				
				self path isQuery ifTrue: [ (stream nextPutAll: 'query') ].
				self path isMutation ifTrue: [ (stream nextPutAll: 'mutation') ].
				
				stream
					nextPutAll: ' <<<NAME_AND_VARIABLES>>> {';
					cr.

				self increaseIndentation.

				self buildOpeningPath.
				self buildClosingPath.

				self decreaseIndentation.

				self
					assert: [ indentation isZero ]
					description: [ 'Indentation must be zero at the end of operation building process' ].

				stream nextPut: $}.

				stream := nil ].

	aQueryName := variables
			ifEmpty: [ '' ]
			ifNotEmpty: [ String
					streamContents: [ :aStream | 
						aStream nextPutAll: self path stopType name.
						aStream nextPut: $(.
						variables
							do: [ :aVariable | 
								aStream nextPut: $$.
								aStream nextPutAll: aVariable name.
								aStream nextPutAll: ': '.
								aStream nextPutAll: aVariable type name ]
							separatedBy: [ aStream nextPutAll: ', ' ].
						aStream nextPut: $) ] ].

	^ anOperation copyReplaceAll: '<<<NAME_AND_VARIABLES>>>' with: aQueryName
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> buildQuery [
	query := GtGQLQuery new
			operation: self buildOperation;
			input: self buildVariables.
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> buildVariables [
	| input |
	variables ifNil: [ ^ nil ].
	variables ifEmpty: [ ^ nil ].

	input := OrderedDictionary new.

	variables do: [ :aVariable | input at: aVariable name put: aVariable value ].

	^ input
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> decreaseIndentation [
	indentation := indentation - 1
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> hasFieldTypeWithSelections: eachStep [
	^ self isTypeWithSelections: eachStep fieldBaseType
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> increaseIndentation [
	indentation := indentation + 1
]

{ #category : #'private - testing' }
GtGQLPathToQueryBuilder >> isCurrentStepLeaf [
	^ currentStep = self path leafStep
]

{ #category : #'api - building' }
GtGQLPathToQueryBuilder >> isTypeWithSelections: aBaseType [
	^ aBaseType isComposite or: [ aBaseType isUnion ]
]

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> nextPutIndentationTabs [
	indentation timesRepeat: [ stream tab ]
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

{ #category : #'private - building' }
GtGQLPathToQueryBuilder >> variableNameForArgument: anArgument [
	| aName aType aVariable anIndex |
	aName := anArgument name.
	aType := anArgument type.

	aVariable := nil.
	anIndex := 0.

	[ aVariable isNil ]
		whileTrue: [ | aVariableName |
			aVariableName := anIndex isZero
					ifTrue: [ aName ]
					ifFalse: [ aName , anIndex asString ].

			variables
				at: aVariableName
				ifAbsentPut: [ aVariable := GtGQLVariable new
							name: aVariableName;
							type: aType.

					(aName = 'first' and: [ aType baseType isIntType ])
						ifTrue: [ aVariable value: 10 ].

					aVariable ].

			"aType = aVariable type ifFalse: [ aVariable := nil ]."
			anIndex := anIndex + 1 ].

	^ aVariable name
]
