"
Just an excercise.
To be removed soon.

"
Class {
	#name : #GtGQLDataWidgetBuilder,
	#superclass : #Object,
	#instVars : [
		'data',
		'schema',
		'query',
		'rootContainer',
		'containerStack'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #accessing }
GtGQLDataWidgetBuilder class >> isDeprecated [
	"An experimental code that will be removed"

	^ true
]

{ #category : #'api - building' }
GtGQLDataWidgetBuilder >> build [
	containerStack := Stack new.
	rootContainer := self newFrameContainer.
	self pushContainer: rootContainer.

	self data
		do: [ :aJson :aKey | 
			| aField |
			aField := self schema queryType fieldNamed: aKey.
			self buildField: aField data: aJson ].

	self popContainer.
	self
		assert: [ containerStack isEmpty ]
		description: [ 'Container stack must be empty' ]
]

{ #category : #'private - building' }
GtGQLDataWidgetBuilder >> buildBasicValues: aJson [
	self halt
]

{ #category : #'private - building' }
GtGQLDataWidgetBuilder >> buildCompositeType: aType data: aJson [
	| aCompositeContainer |
	aCompositeContainer := self newCompositeContainer.
	self currentContainer addChild: aCompositeContainer.
	self pushContainer: aCompositeContainer.

	aType fields
		do: [ :eachField | 
			| aFieldData |
			self flag: 'FIXIT: there can be an alias instead of a field name'.
			aFieldData := aJson at: eachField name.

			aFieldData exists
				ifTrue: [ self buildCompositeTypeField: eachField data: aFieldData ] ].

	self popContainer
]

{ #category : #'private - building' }
GtGQLDataWidgetBuilder >> buildCompositeTypeField: aField data: aJson [
	self currentContainer addChild: (self newFieldLabelNamed: aField name).

	self pushContainer: self newFieldValueContainer.
	self buildField: aField data: aJson.

	self popContainer
]

{ #category : #'private - building' }
GtGQLDataWidgetBuilder >> buildField: aField data: aJson [
	| aType |
	aType := aField type.
	aType ifNil: [ self buildBasicValues: aJson ].
	
	self buildType: aType data: aJson
]

{ #category : #'private - building' }
GtGQLDataWidgetBuilder >> buildListType: aType data: aJson [
	self halt
]

{ #category : #'private - building' }
GtGQLDataWidgetBuilder >> buildScalarType: aType data: aJson [
	self currentContainer addChild: (self newValueLabelWithValue: aJson jsonObject)
]

{ #category : #'private - building' }
GtGQLDataWidgetBuilder >> buildType: aType data: aJson [
	aType ifNil: [ self error: 'Type must be non-nil' ].

	aType isList
		ifTrue: [ self buildListType: aType data: aJson.
			^ self ].

	aType isComposite
		ifTrue: [ self buildCompositeType: aType data: aJson.
			^ self ].

	aType isNonNullable
		ifTrue: [ self buildType: aType type data: aJson.
			^ self ].

	aType isScalar
		ifTrue: [ self buildScalarType: aType data: aJson.
			^ self ].

	self halt
]

{ #category : #'private - widgets' }
GtGQLDataWidgetBuilder >> currentContainer [
	<return: #BlElement>
	^ containerStack first
]

{ #category : #accessing }
GtGQLDataWidgetBuilder >> data [
	^ data
]

{ #category : #'api - initialization' }
GtGQLDataWidgetBuilder >> data: anObject [
	data := anObject
]

{ #category : #accessing }
GtGQLDataWidgetBuilder >> element [
	^ rootContainer
]

{ #category : #'private - widgets' }
GtGQLDataWidgetBuilder >> newCompositeContainer [
	^ BrHorizontalGrid new
		cellSpacing: 0;
		columnCount: 2;
		alignCenterLeft;
		fitContent
]

{ #category : #'private - widgets' }
GtGQLDataWidgetBuilder >> newFieldLabelNamed: aName [
	^ BrLabel new
		fitContent;
		aptitude: (BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors disabledButtonTextColor);
		text: aName
]

{ #category : #'private - widgets' }
GtGQLDataWidgetBuilder >> newFieldValueContainer [
	^ BrFrame new fitContent
]

{ #category : #'private - widgets' }
GtGQLDataWidgetBuilder >> newFrameContainer [
	^ BrFrame new fitContent
]

{ #category : #'private - widgets' }
GtGQLDataWidgetBuilder >> newValueLabelWithValue: aValue [
	^ BrLabel new
		fitContent;
		aptitude: BrGlamorousLabelAptitude new;
		text: aValue asString
]

{ #category : #'private - widgets' }
GtGQLDataWidgetBuilder >> popContainer [
	containerStack pop
]

{ #category : #'private - widgets' }
GtGQLDataWidgetBuilder >> pushContainer: aContainer [
	aContainer parent
		ifNil: [ containerStack ifNotEmpty: [ self currentContainer addChild: aContainer ] ].
	containerStack push: aContainer
]

{ #category : #accessing }
GtGQLDataWidgetBuilder >> query [
	^ query
]

{ #category : #'api - initialization' }
GtGQLDataWidgetBuilder >> query: anObject [
	query := anObject
]

{ #category : #'api - initialization' }
GtGQLDataWidgetBuilder >> result: aGtGQLResult [
	self
		data: aGtGQLResult data;
		schema: aGtGQLResult schema;
		query: aGtGQLResult query
]

{ #category : #accessing }
GtGQLDataWidgetBuilder >> schema [
	^ schema
]

{ #category : #'api - initialization' }
GtGQLDataWidgetBuilder >> schema: anObject [
	schema := anObject
]
