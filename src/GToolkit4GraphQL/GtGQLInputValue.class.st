Class {
	#name : #GtGQLInputValue,
	#superclass : #GtGQLModel,
	#instVars : [
		'parentType'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInputValue >> isDeprecated [
	^ self propertyAt: #isDeprecated ifAbsent: [ false ]
]
