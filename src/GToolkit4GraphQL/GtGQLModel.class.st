"
I am an abstract model class.
I implement {{gtMethod:GtGQLModel >> #propertyAt:}} which should be used to store the GraphQL schema information.
I implement {{gtMethod: GtGQLModel >> #optionAt:}} which can be used to store an extra information.

"
Class {
	#name : #GtGQLModel,
	#superclass : #Object,
	#traits : 'TGtOptions',
	#classTraits : 'TGtOptions classTrait',
	#instVars : [
		'properties'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #asserting }
GtGQLModel >> assertFields: aKey value: aValue [
	aKey = #fields ifFalse: [ ^ self ].

	self
		assert: [ aValue isDictionary ]
		description: [ 'Fields must be a dictionary: {1}' format: {aValue} ]
]

{ #category : #'api - properties' }
GtGQLModel >> fields [
	^ #()
]

{ #category : #'gt - extensions' }
GtGQLModel >> gtPropertiesFor: aView context: aContext [
	<gtView>
	^ aView columnedTree
		title: 'Properties';
		priority: 49;
		items: [ self properties associations asSortedCollection: [ :a :b | a key < b key ] ];
		column: 'Name' text: #key;
		column: 'Value' text: #value;
		send: #value;
		children: [ :anAssoc | 
			(anAssoc value isKindOf: GtGQLModel)
				ifTrue: [ anAssoc value properties associations
						asSortedCollection: [ :a :b | a key < b key ] ]
				ifFalse: [ (anAssoc value isCollection
						and: [ anAssoc value allSatisfy: [ :each | each isKindOf: GtGQLModel ] ])
						ifTrue: [ (Array
								new: anAssoc value size
								streamContents: [ :aStream | anAssoc value withIndexDo: [ :each :index | aStream nextPut: each name -> each ] ])
								asSortedCollection: [ :a :b | a key < b key ] ]
						ifFalse: [ #() ] ] ]
]

{ #category : #'api - properties' }
GtGQLModel >> includesPropertyKey: aKey [
	^ properties includesKey: aKey
]

{ #category : #initialization }
GtGQLModel >> initialize [
	super initialize.
	properties := Dictionary new
]

{ #category : #testing }
GtGQLModel >> isInterface [
	^ false
]

{ #category : #accessing }
GtGQLModel >> metaType [
	^ self propertyAt: #__type
]

{ #category : #accessing }
GtGQLModel >> metaType: aName [
	self propertyAt: #__type put: aName
]

{ #category : #accessing }
GtGQLModel >> metaTypeName: aName [
	self propertyAt: GtGQLIntrospectionConstants metaMetaTypeName put: aName
]

{ #category : #'api - properties' }
GtGQLModel >> properties [
	^ properties
]

{ #category : #'api - properties' }
GtGQLModel >> properties: anObject [
	properties := anObject
]

{ #category : #'api - properties' }
GtGQLModel >> propertyAt: aKey [
	^ self
		propertyAt: aKey
		ifPresent: [ :aValue | aValue ]
		ifAbsent: [ nil ]
]

{ #category : #'api - properties' }
GtGQLModel >> propertyAt: aKey ifAbsent: anAbsentBlock [
	^ self
		propertyAt: aKey
		ifPresent: [ :aValue | aValue ]
		ifAbsent: anAbsentBlock
]

{ #category : #'api - properties' }
GtGQLModel >> propertyAt: aKey ifAbsentPut: anAbsentBlock [
	^ self
		propertyAt: aKey
		ifPresent: [ :aValue | aValue ]
		ifAbsentPut: [ | aValue |
			aValue := anAbsentBlock value.
			self assertFields: aKey value: aValue.
			aValue ]
]

{ #category : #'api - properties' }
GtGQLModel >> propertyAt: aKey ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ properties
		at: aKey
		ifPresent: aPresentBlock
		ifAbsent: anAbsentBlock
]

{ #category : #'api - properties' }
GtGQLModel >> propertyAt: aKey ifPresent: aPresentBlock ifAbsentPut: anAbsentBlock [
	^ properties
		at: aKey
		ifPresent: aPresentBlock
		ifAbsentPut: anAbsentBlock
]

{ #category : #'api - properties' }
GtGQLModel >> propertyAt: aKey put: aValue [
	self assertFields: aKey value: aValue.

	^ properties at: aKey put: aValue
]
