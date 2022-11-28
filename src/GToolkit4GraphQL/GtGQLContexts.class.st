Class {
	#name : #GtGQLContexts,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'contexts'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'gt - extensions' }
GtGQLContexts class >> gtRegisteredContextsFor: aView [
	<gtView>
	<gtClassView>
	^ aView forward
		title: 'Contexts';
		priority: 10;
		object: [ self default ];
		view: #gtContextsFor:
]

{ #category : #'api - global registration' }
GtGQLContexts class >> named: aName [
	<return: #GtGQLContext or: nil>
	^ self default named: aName
]

{ #category : #'api - global registration' }
GtGQLContexts class >> register: aContext [
	self default add: aContext
]

{ #category : #'api - global registration' }
GtGQLContexts class >> unregister: aContext [
	self default remove: aContext
]

{ #category : #'api - global registration' }
GtGQLContexts class >> withUrl: anUrl [
	<return: #GtGQLContext or: nil>
	^ self default withUrl: anUrl
]

{ #category : #'api - adding / removing' }
GtGQLContexts >> add: aContext [
	self assert: [ aContext isNotNil ] description: [ 'Context must be non-nil' ].
	self
		assert: [ aContext respondsTo: #name ]
		description: [ 'Context must responds to #name calls: {1}' format: {aContext} ].

	(contexts includes: aContext) ifTrue: [ ^ self ].

	contexts add: aContext
]

{ #category : #accessing }
GtGQLContexts >> all [
	^ contexts ifNotNil: [ :aCollection | aCollection asArray ] ifNil: [ #() ]
]

{ #category : #'gt - extensions' }
GtGQLContexts >> gtContextsFor: aView [
	<gtView>
	contexts ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Contexts';
		priority: 1;
		items: [ self all ];
		column: 'Name' text: #name;
		column: 'URL' text: #url;
		actionUpdateButton
]

{ #category : #initialization }
GtGQLContexts >> initialize [
	super initialize.

	contexts := SortedCollection sortUsing: [ :a :b | a name < b name ]
]

{ #category : #'api - enumerating' }
GtGQLContexts >> named: aName [
	<return: #GtGQLContext or: nil>
	^ contexts detect: [ :eachContext | eachContext name = aName ] ifNone: [ nil ]
]

{ #category : #'api - adding / removing' }
GtGQLContexts >> remove: aContext [
	contexts remove: aContext ifAbsent: [  "ignore" ]
]

{ #category : #'api - enumerating' }
GtGQLContexts >> withUrl: anUrl [
	<return: #GtGQLContext or: nil>
	| aZnUrl |
	aZnUrl := anUrl asZnUrl.
	^ contexts detect: [ :eachContext | eachContext url = aZnUrl ] ifNone: [ nil ]
]
