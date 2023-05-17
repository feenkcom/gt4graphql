Trait {
	#name : #TGtGQLWithZnRequestAndResponse,
	#instVars : [
		'request',
		'response'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'gt - extensions' }
TGtGQLWithZnRequestAndResponse >> gtRequestHeadersFor: aView [
	<gtView>
	self request ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Request headers';
		priority: 45;
		object: [ self request ];
		view: #gtHeadersFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Request'
			tooltip: 'Inspect request'
			action: [ :aButton | aButton phlow spawnObject: self request ]
]

{ #category : #'gt - extensions' }
TGtGQLWithZnRequestAndResponse >> gtRequestJsonFor: aView [
	<gtView>
	self request ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Request JSON';
		priority: 40;
		object: [ self request ];
		view: #gtJsonFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Request'
			tooltip: 'Inspect request'
			action: [ :aButton | aButton phlow spawnObject: self request ]
]

{ #category : #'gt - extensions' }
TGtGQLWithZnRequestAndResponse >> gtResponseHeadersFor: aView [
	<gtView>
	self response ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Response headers';
		priority: 35;
		object: [ self response ];
		view: #gtHeadersFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Response'
			tooltip: 'Inspect response'
			action: [ :aButton | aButton phlow spawnObject: self response ]
]

{ #category : #'gt - extensions' }
TGtGQLWithZnRequestAndResponse >> gtResponseJsonFor: aView [
	<gtView>
	self response ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Response JSON';
		priority: 25;
		object: [ self response ];
		view: #gtJsonFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Response'
			tooltip: 'Inspect response'
			action: [ :aButton | aButton phlow spawnObject: self response ]
]

{ #category : #accessing }
TGtGQLWithZnRequestAndResponse >> request [
	^ request
]

{ #category : #accessing }
TGtGQLWithZnRequestAndResponse >> request: anObject [
	request := anObject
]

{ #category : #accessing }
TGtGQLWithZnRequestAndResponse >> response [
	^ response
]

{ #category : #accessing }
TGtGQLWithZnRequestAndResponse >> response: anObject [
	response := anObject
]
