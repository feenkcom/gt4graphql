"
I build basic {{gtClass:GtGQLType}} , filling its name. 
I use a JSON introspection GraphQL response to build a given type.
I am used by {{gtClass:GtGQLIntrospectionSchemaBuilder}}.
#Examples
##Scalar String Type
By providing the following JSON response: {{gtExample:GtGQLIntrospectionTypeBuilderExamples >> #scalarStringTypeJson | noCode | previewShow=#gtJsonStringFor: | previewHeight=120}}
I create the following type: {{gtExample:GtGQLIntrospectionTypeBuilderExamples >> #scalarStringType | noCode}} 
##Non-Null List Type
By providing the following JSON response: {{gtExample:GtGQLIntrospectionTypeBuilderExamples >> #nonNullListTypeJson | noCode | previewShow=#gtJsonStringFor: | previewHeight=330}} 
I create the following type: {{gtExample: GtGQLIntrospectionTypeBuilderExamples >> #nonNullListType | noCode}} 

"
Class {
	#name : #GtGQLIntrospectionTypeBuilder,
	#superclass : #Object,
	#instVars : [
		'json',
		'type',
		'schema'
	],
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'api - building' }
GtGQLIntrospectionTypeBuilder >> build [
	<return: #GtGQLType>
	type := self ofTypeFromJson: self json.

	^ type
]

{ #category : #'gt - extensions' }
GtGQLIntrospectionTypeBuilder >> gtJsonFor: aView context: aContext [
	<gtView>
	self json ifNil: [ ^ aView empty ].

	aContext at: #gtTreeExpansionLevel ifAbsentPut: [ true ].

	^ aView forward
		title: 'JSON';
		priority: 10;
		object: [ self json ];
		view: #gtTreeFor:context:
]

{ #category : #accessing }
GtGQLIntrospectionTypeBuilder >> json [
	<return: #Dictionary>
	^ json
]

{ #category : #'api - initialization' }
GtGQLIntrospectionTypeBuilder >> json: aDictionary [
	json := aDictionary
]

{ #category : #'private - building' }
GtGQLIntrospectionTypeBuilder >> ofTypeFromJson: aJson [
	<return: #GtGQLType>
	| aKind aClass aType |
	aJson ifNil: [ ^ nil ].
	aKind := aJson at: #kind ifAbsent: [ ^ nil ].
	aClass := GtGQLType typeClassForKindName: aKind.
	aType := aClass new.

	aJson
		at: #name
		ifPresent: [ :aName | aName ifNotNil: [ aType name: aName ] ]
		ifAbsent: [  "ignore" ].

	aJson
		at: #ofType
		ifPresent: [ :ofTypeJson | 
			ofTypeJson
				ifNotNil: [ (self ofTypeFromJson: ofTypeJson) ifNotNil: [ :ofType | aType type: ofType ] ] ]
		ifAbsent: [  "ignore" ].

	schema ifNil: [ ^ aType ].

	^ schema
		typeNamed: aType name
		ifPresent: [ :anExistingType | anExistingType ]
		ifAbsentPut: [ aType ]
]

{ #category : #accessing }
GtGQLIntrospectionTypeBuilder >> printOn: aStream [
	super printOn: aStream.

	self type ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self typeName asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLIntrospectionTypeBuilder >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLIntrospectionTypeBuilder >> schema: anObject [
	schema := anObject
]

{ #category : #'api - initialization' }
GtGQLIntrospectionTypeBuilder >> string: aString [
	self json: (STONJSON fromString: aString)
]

{ #category : #accessing }
GtGQLIntrospectionTypeBuilder >> type [
	<return: #GtGQLType>
	^ type
]

{ #category : #accessing }
GtGQLIntrospectionTypeBuilder >> typeName [
	<return: #String>
	^ self type ifNotNil: #name ifNil: [ '?' ]
]
