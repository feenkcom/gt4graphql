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
				spec repository: 'github://feenkcom/gt4magritte:v0.6.1233/src' ].
		spec
			baseline: 'LepiterEngine' with: [
				spec repository: 'github://feenkcom/lepiter:v0.6.2897/src' ].
		spec
			baseline: 'GToolkit4Json' with: [
				spec repository: 'github://feenkcom/gt4json:v0.6.1358/src' ].
		spec
			baseline: 'GToolkit4Changes' with: [
				spec repository: 'github://feenkcom/gt4changes:v0.6.1051/src' ].

		spec package: 'GToolkit4GraphQL' with: [
			spec requires: #(#GToolkit4Magritte #LepiterEngine #GToolkit4Json #GToolkit4Changes) ].
	]
]
