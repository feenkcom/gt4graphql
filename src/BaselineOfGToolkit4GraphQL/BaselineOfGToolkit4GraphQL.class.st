Class {
	#name : #BaselineOfGToolkit4GraphQL,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4GraphQL
}

{ #category : #baseline }
BaselineOfGToolkit4GraphQL >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'GToolkit4Magritte'
				with: [ spec repository: 'github://feenkcom/gt4magritte:main/src' ].
			spec
				baseline: 'LepiterEngine'
				with: [ spec repository: 'github://feenkcom/lepiter:main/src' ].
			spec
				baseline: 'GToolkit4Json'
				with: [ spec repository: 'github://feenkcom/gt4json:main/src' ].

			spec
				baseline: 'GToolkit4Changes'
				with: [ spec repository: 'github://feenkcom/gt4changes:main/src' ].

			spec
				package: 'GToolkit4GraphQL'
				with: [ spec
						requires: #('GToolkit4Magritte' 'LepiterEngine' 'GToolkit4Json' 'GToolkit4Changes') ] ]
]
