Class {
	#name : #GtGQLMutationPathAccessor,
	#superclass : #GtGQLPathAccessor,
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #'api - accessing' }
GtGQLMutationPathAccessor >> startType [
	<return: #GtGQLObject>
	^ self builder schema mutationType
]

{ #category : #accessing }
GtGQLMutationPathAccessor >> write: aStopType paths: aCollection [
	aStopType mutationPaths: aCollection
]
