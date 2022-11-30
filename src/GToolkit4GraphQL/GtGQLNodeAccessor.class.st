Class {
	#name : #GtGQLNodeAccessor,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #'api - testing' }
GtGQLNodeAccessor >> isFieldNode: aNode [
	<return: #Boolean>
	^ self subclassResponsibility
]
