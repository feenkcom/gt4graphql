Class {
	#name : #GtGQLMagritteBuilder,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Magritte'
}

{ #category : #private }
GtGQLMagritteBuilder class >> containerPragma [
	^ MAPragmaBuilder containerPragma
]

{ #category : #'instance creation' }
GtGQLMagritteBuilder class >> for: anObject [
	^ self new for: anObject
]

{ #category : #private }
GtGQLMagritteBuilder >> build: anObject cache: cache [
	| container |
	container := cache at: anObject put: (self buildContainer: anObject).
	
	^ container
		addAll: (self buildDescriptions: anObject);
		yourself.

]

{ #category : #private }
GtGQLMagritteBuilder >> buildContainer: anObject [
	| containerPragmas containerPragma containerSelector extensionSelectors container |
	
	containerPragmas := Pragma 
		allNamed: self class containerPragma 
		from: anObject class to: Object.
		
	containerPragma := containerPragmas detect: [ :each | each method numArgs = 0 ].
	containerSelector := containerPragma method selector.

	extensionSelectors := (containerPragmas 
		select: [ :each | each method numArgs = 1 ]) 
		collect: [ :each | each method selector ]. 

	MADynamicDescribedObject use: anObject during: [	
		container := anObject perform: containerSelector.
		extensionSelectors do: [ :each | 
			anObject perform: each with: container ] ].

	^ container
]

{ #category : #private }
GtGQLMagritteBuilder >> buildDescriptions: anObject [
	^ Array
		streamContents: [ :aStream | 
			| anIndex |
			anIndex := 1.
			anObject fields
				keysAndValuesDo: [ :aKey :aValue | 
					| aFieldDescriptions |
					aFieldDescriptions := MAPragmaBuilder for: aValue.

					aFieldDescriptions
						do: [ :eachDescription | 
							eachDescription priority: anIndex.
							eachDescription label: aKey.
							eachDescription
								accessor: (GtGQLFieldAccessor new
										fieldName: aKey;
										fieldDescription: eachDescription).

							anIndex := anIndex + 1 ].

					aStream nextPutAll: aFieldDescriptions ] ]
]

{ #category : #'description building' }
GtGQLMagritteBuilder >> for: anObject [
	| cache |
	cache := MADynamicDescriptionCache value.
	
	MADynamicDescriptionCache use: cache during: [
		^ cache at: anObject ifAbsentPut: [ self build: anObject cache: cache ] ]
]
