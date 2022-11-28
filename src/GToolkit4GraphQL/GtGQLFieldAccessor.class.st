Class {
	#name : #GtGQLFieldAccessor,
	#superclass : #MAAccessor,
	#instVars : [
		'fieldName',
		'fieldAccessor'
	],
	#category : #'GToolkit4GraphQL-Magritte'
}

{ #category : #testing }
GtGQLFieldAccessor class >> isAbstract [
	^ false
]

{ #category : #comparing }
GtGQLFieldAccessor >> = anObject [
	^ super = anObject
		and: [ self fieldAccessor = anObject fieldAccessor
				and: [ self fieldName = anObject fieldName ] ]
]

{ #category : #testing }
GtGQLFieldAccessor >> canRead: aModel [
	self fieldAccessor ifNil: [ ^ false ].

	^ aModel
		fieldNamed: self fieldName
		ifPresent: [ :aValue | self fieldAccessor canRead: aValue ]
		ifAbsent: [ ^ true ]
]

{ #category : #testing }
GtGQLFieldAccessor >> canWrite: aModel [
	self fieldAccessor ifNil: [ ^ false ].

	^ aModel
		fieldNamed: self fieldName
		ifPresent: [ :aValue | self fieldAccessor canWrite: aValue ]
		ifAbsent: [ ^ true ]
]

{ #category : #accessing }
GtGQLFieldAccessor >> defaultLabelFor: aDescription [
	^ self fieldName asString normalizeCamelCase capitalized
]

{ #category : #accessing }
GtGQLFieldAccessor >> fieldAccessor [
	^ fieldAccessor
]

{ #category : #'api - initialization' }
GtGQLFieldAccessor >> fieldAccessor: anAccessor [
	fieldAccessor := anAccessor asAccessor
]

{ #category : #'api - initialization' }
GtGQLFieldAccessor >> fieldDescription: aDescription [
	self fieldAccessor: aDescription accessor
]

{ #category : #accessing }
GtGQLFieldAccessor >> fieldName [
	^ fieldName
]

{ #category : #accessing }
GtGQLFieldAccessor >> fieldName: anObject [
	fieldName := anObject
]

{ #category : #'magritte-accessing' }
GtGQLFieldAccessor >> fieldNameDescription [
	<magritteDescription>
	^ MASymbolDescription new
		accessor: #fieldName;
		required: true;
		yourself
]

{ #category : #comparing }
GtGQLFieldAccessor >> hash [
	^ super hash bitXor: (self fieldAccessor hash bitXor: self fieldName hash)
]

{ #category : #accessing }
GtGQLFieldAccessor >> name [
	^ self fieldName
]

{ #category : #model }
GtGQLFieldAccessor >> read: aModel [
	self fieldAccessor ifNil: [ ^ nil ].

	^ aModel
		fieldNamed: self fieldName
		ifPresent: [ :aValue | self fieldAccessor read: aValue ]
		ifAbsent: [ nil ]
]

{ #category : #printing }
GtGQLFieldAccessor >> storeOn: aStream [
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' fieldName: ';
		store: self fieldName;
		in: [ :theStream | self fieldAccessor storeOn: theStream ];
		nextPut: $)
]

{ #category : #model }
GtGQLFieldAccessor >> write: aModel [
	self fieldAccessor ifNil: [ ^ self ].

	aModel
		fieldNamed: self fieldName
		ifPresent: [ :aValue | self fieldAccessor write: aValue ]
		ifAbsent: [ nil ]
]
