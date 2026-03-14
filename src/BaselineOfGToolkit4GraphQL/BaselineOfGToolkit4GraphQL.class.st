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
				spec repository: 'github://feenkcom/gt4magritte:v0.7.63/src' ].
		spec
			baseline: 'LepiterEngine' with: [
				spec repository: 'github://feenkcom/lepiter:v0.7.155/src' ].
		spec
			baseline: 'GToolkit4Json' with: [
				spec repository: 'github://feenkcom/gt4json:v0.7.120/src' ].
		spec
			baseline: 'GToolkit4Changes' with: [
				spec repository: 'github://feenkcom/gt4changes:v0.7.71/src' ].

		spec package: 'GToolkit4GraphQL' with: [
			spec requires: #(#GToolkit4Magritte #LepiterEngine #GToolkit4Json #GToolkit4Changes) ].
	]
]
