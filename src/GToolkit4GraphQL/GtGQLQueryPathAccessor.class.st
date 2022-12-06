Class {
	#name : #GtGQLQueryPathAccessor,
	#superclass : #GtGQLPathAccessor,
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #'api - accessing' }
GtGQLQueryPathAccessor >> startType [
	<return: #GtGQLObject>
	^ self builder schema queryType
]

{ #category : #'api - writing' }
GtGQLQueryPathAccessor >> write: aStopType paths: aCollection [
	aStopType queryPaths: aCollection
]
