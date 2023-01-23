Class {
	#name : #GtGQLInputObject,
	#superclass : #GtGQLComposite,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInputObject class >> kindName [
	^ 'INPUT_OBJECT'
]

{ #category : #'api - paths' }
GtGQLInputObject >> defaultVariableValue [
	^ Dictionary new
]

{ #category : #'gt - extensions' }
GtGQLInputObject >> gtTypesNameText [
	| aText |
	aText := self name asRopedText.

	self isRequired
		ifTrue: [ aText
				append: '!' asRopedText;
				bold ].
	self isDeprecated
		ifTrue: [ aText
				lineThroughDo: [ :anAttribute |  ];
				italic ].

	^ aText
]

{ #category : #accessing }
GtGQLInputObject >> inputFields [
	^ self fields
]

{ #category : #accessing }
GtGQLInputObject >> inputFields: aCollection [
	self fields: aCollection
]

{ #category : #testing }
GtGQLInputObject >> isInputObject [
	^ true
]

{ #category : #'api - response' }
GtGQLInputObject >> newValueUsing: aType [
	"Input objects should not appear in results"

	^ self shouldNotImplement
]

{ #category : #accessing }
GtGQLInputObject >> propertyFieldName [
	^ #inputFields
]
