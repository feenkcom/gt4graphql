Class {
	#name : #GtGQLRequestProblem,
	#superclass : #GtGQLResult,
	#traits : 'TGtGQLWithZnRequestAndResponse',
	#classTraits : 'TGtGQLWithZnRequestAndResponse classTrait',
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #'gt - extensions' }
GtGQLRequestProblem >> gtRequestHeadersFor: aView [
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
GtGQLRequestProblem >> gtResponseHeadersFor: aView [
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
