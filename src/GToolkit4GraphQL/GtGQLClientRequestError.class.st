Class {
	#name : #GtGQLClientRequestError,
	#superclass : #Error,
	#instVars : [
		'request',
		'response'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'gt - extensions' }
GtGQLClientRequestError >> gtRequestHeadersFor: aView [
	<gtView>
	self request ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Request Headers';
		priority: -5;
		object: [ self request ];
		view: #gtHeadersFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Request'
			tooltip: 'Inspect request'
			action: [ :aButton | aButton phlow spawnObject: self request ]
]

{ #category : #'gt - extensions' }
GtGQLClientRequestError >> gtRequestJsonFor: aView [
	<gtView>
	self request ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Request JSON';
		priority: -6;
		object: [ self request ];
		view: #gtJsonFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Request'
			tooltip: 'Inspect request'
			action: [ :aButton | aButton phlow spawnObject: self request ]
]

{ #category : #'gt - extensions' }
GtGQLClientRequestError >> gtResponseHeadersFor: aView [
	<gtView>
	self response ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Response Headers';
		priority: -9;
		object: [ self response ];
		view: #gtHeadersFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Response'
			tooltip: 'Inspect response'
			action: [ :aButton | aButton phlow spawnObject: self response ]
]

{ #category : #'gt - extensions' }
GtGQLClientRequestError >> gtResponseJsonFor: aView [
	<gtView>
	self response ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Response JSON';
		priority: -10;
		object: [ self response ];
		view: #gtJsonFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Response'
			tooltip: 'Inspect response'
			action: [ :aButton | aButton phlow spawnObject: self response ]
]

{ #category : #accessing }
GtGQLClientRequestError >> request [
	^ request
]

{ #category : #accessing }
GtGQLClientRequestError >> request: anObject [
	request := anObject
]

{ #category : #accessing }
GtGQLClientRequestError >> response [
	^ response
]

{ #category : #accessing }
GtGQLClientRequestError >> response: anObject [
	response := anObject
]
