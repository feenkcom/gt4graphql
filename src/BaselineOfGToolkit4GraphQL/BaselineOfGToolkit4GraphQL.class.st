Class {
	#name : #BaselineOfGToolkit4GraphQL,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4GraphQL
}

{ #category : #baseline }
BaselineOfGToolkit4GraphQL >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkit4Magritte' with: [
				spec repository: 'github://feenkcom/gt4magritte:v0.6.718/src' ].
		spec
			baseline: 'LepiterEngine' with: [
				spec repository: 'github://feenkcom/lepiter:v0.6.1600/src' ].
		spec
			baseline: 'GToolkit4Json' with: [
				spec repository: 'github://feenkcom/gt4json:v0.6.409/src' ].
		spec
			baseline: 'GToolkit4Changes' with: [
				spec repository: 'github://feenkcom/gt4changes:v0.6.551/src' ].

		spec package: 'GToolkit4GraphQL' with: [
			spec requires: #('GToolkit4Magritte' 'LepiterEngine' 'GToolkit4Json' 'GToolkit4Changes') ].
	]
]
