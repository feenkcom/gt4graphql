"
I link link {{gtClass:GtGQLType}} instances.
#Interfaces
I link {{gtClass:GtGQLInterface}} with {{gtClass:GtGQLObject}} using {{gtMethod:GtGQLInterface >> #possibleTypes}}..
Connections are preserved in {{gtMethod:GtGQLObject >> #implementedInterfaces}}. 
#Unions
I link {{gtClass:GtGQLUnion}} with {{gtClass:GtGQLObject}} using {{gtMethod:GtGQLUnion>>#possibleTypes}}.
Connections are preserved in {{gtMethod:GtGQLObject>>#partOfUnions}}.

"
Class {
	#name : #GtGQLTypeLinker,
	#superclass : #Object,
	#instVars : [
		'schema',
		'interfaceReferences',
		'unionReferences',
		'typeReferences'
	],
	#category : #'GToolkit4GraphQL-Builders'
}

{ #category : #'private - building' }
GtGQLTypeLinker >> addTypeReference: aTypeReference [
	| aTargetType |
	aTargetType := aTypeReference targetType.
	self typeReferencesAt: aTargetType putReference: aTypeReference.

	(aTargetType isUnion or: [ aTargetType isInterface ])
		ifTrue: [ aTargetType possibleTypes
				do: [ :aPossibleType | self typeReferencesAt: aPossibleType putReference: aTypeReference ] ]
]

{ #category : #'api - applying' }
GtGQLTypeLinker >> apply [
	self applyInterfaces.
	self applyUnions.
	self applyTypeReferences.
]

{ #category : #'api - applying' }
GtGQLTypeLinker >> applyInterfaces [
	interfaceReferences
		keysAndValuesDo: [ :aType :implementedInterfaces | aType implementedInterfaces: implementedInterfaces asArray ]
]

{ #category : #'api - applying' }
GtGQLTypeLinker >> applyTypeReferences [
	typeReferences
		keysAndValuesDo: [ :aTargetType :aReference | aTargetType typeReferences: aReference asArray ]
]

{ #category : #'api - applying' }
GtGQLTypeLinker >> applyUnions [
	unionReferences
		keysAndValuesDo: [ :aType :itsUnions | aType partOfUnions: itsUnions asArray ]
]

{ #category : #'private - accessing' }
GtGQLTypeLinker >> baseInterfaces [
	^ self schema baseInterfaces
]

{ #category : #'private - accessing' }
GtGQLTypeLinker >> baseTypes [
	^ self schema baseTypes
]

{ #category : #'private - accessing' }
GtGQLTypeLinker >> baseUnions [
	^ self schema baseUnions
]

{ #category : #'api - building' }
GtGQLTypeLinker >> build [
	self buildInterfaceReferences.
	self buildUnionReferences.
	self buildTypeReferences.
]

{ #category : #'api - building' }
GtGQLTypeLinker >> buildInterfaceReferences [
	interfaceReferences := Dictionary new.

	self baseInterfaces
		do: [ :aSourceInterface | 
			aSourceInterface possibleTypes
				do: [ :aTargetType | 
					interfaceReferences
						at: aTargetType
						ifPresent: [ :aCollection | aCollection add: aSourceInterface ]
						ifAbsentPut: [ OrderedCollection with: aSourceInterface ] ] ]
]

{ #category : #'api - building' }
GtGQLTypeLinker >> buildTypeReferences [
	typeReferences := Dictionary new.

	self baseTypes
		do: [ :aSourceType | 
			aSourceType isComposite
				ifTrue: [ aSourceType fields
						do: [ :aSourceField | 
							| aTargetType aTypeReference |
							aTargetType := aSourceField type baseType.
							aTypeReference := GtGQLTypeReference new
									targetType: aTargetType;
									sourceType: aSourceType;
									sourceField: aSourceField.
							self addTypeReference: aTypeReference.

							(aSourceField isField and: [ aSourceField hasArguments ])
								ifTrue: [ aSourceField arguments
										do: [ :aSourceArgument | 
											| aTargetArgumentType anArgumentReference |
											aTargetArgumentType := aSourceArgument type baseType.
											anArgumentReference := GtGQLArgumentTypeReference new
													targetType: aTargetArgumentType;
													sourceType: aSourceType;
													sourceField: aSourceField;
													sourceArgument: aSourceArgument.

											self addTypeReference: anArgumentReference ] ] ] ] ]
]

{ #category : #'api - building' }
GtGQLTypeLinker >> buildUnionReferences [
	unionReferences := Dictionary new.

	self baseUnions
		do: [ :aSourceUnion | 
			aSourceUnion possibleTypes
				do: [ :aTargetType | 
					unionReferences
						at: aTargetType
						ifPresent: [ :aCollection | aCollection add: aSourceUnion ]
						ifAbsentPut: [ OrderedCollection with: aSourceUnion ] ] ]
]

{ #category : #'gt - extensions' }
GtGQLTypeLinker >> gtInterfaceReferencesFor: aView [
	<gtView>
	interfaceReferences ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Interface References';
		priority: 21;
		items: [ interfaceReferences keys asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :aType | 
			interfaceReferences
				at: aType
				ifPresent: [ :aCollection | aCollection asSortedCollection: [ :a :b | a name < b name ] ]
				ifAbsent: [ #() ] ];
		column: 'Referenced Type'
			text: [ :aType | aType gtTypeReferencesViewReferencedTypeText ];
		column: 'Interfaces'
			text: [ :aType | self gtInterfaceReferencesViewInterfacesTextFor: aType ]
			weight: 2
]

{ #category : #'gt - extensions' }
GtGQLTypeLinker >> gtInterfaceReferencesViewInterfacesTextFor: aType [
	aType isInterface ifTrue: [ ^ '' ].

	^ interfaceReferences
		at: aType
		ifPresent: [ :aCollection | 
			| aSortedInterfaces |
			aSortedInterfaces := aCollection
					asSortedCollection: [ :a :b | a name < b name ].
			String
				streamContents: [ :aStream | 
					aSortedInterfaces
						do: [ :anInterface | aStream nextPutAll: anInterface name ]
						separatedBy: [ aStream nextPutAll: ', ' ] ] ]
		ifAbsent: [ '' ]
]

{ #category : #'gt - extensions' }
GtGQLTypeLinker >> gtTypeReferencesFor: aView [
	<gtView>
	typeReferences ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Type References';
		priority: 20;
		items: [ typeReferences keys asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :anObject | 
			| aType |
			aType := (anObject isKindOf: GtGQLType)
					ifTrue: [ anObject ]
					ifFalse: [ anObject sourceType ].

			typeReferences
				at: aType
				ifPresent: [ :aCollection | 
					aCollection
						asSortedCollection: [ :a :b | a sourceType name < b sourceType name ] ]
				ifAbsent: [ #() ] ];
		column: 'Referenced Type'
			text: [ :aType | aType gtTypeReferencesViewReferencedTypeText ]
]

{ #category : #'gt - extensions' }
GtGQLTypeLinker >> gtUnionReferencesFor: aView [
	<gtView>
	unionReferences ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Union References';
		priority: 22;
		items: [ unionReferences keys asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :aType | 
			unionReferences
				at: aType
				ifPresent: [ :aCollection | aCollection asSortedCollection: [ :a :b | a name < b name ] ]
				ifAbsent: [ #() ] ];
		column: 'Referenced Type'
			text: [ :aType | aType gtTypeReferencesViewReferencedTypeText ];
		column: 'Unions'
			text: [ :aType | self gtUnionReferencesViewUnionTextFor: aType ]
			weight: 2
]

{ #category : #'gt - extensions' }
GtGQLTypeLinker >> gtUnionReferencesViewUnionTextFor: aType [
	aType isUnion ifTrue: [ ^ '' ].

	^ unionReferences
		at: aType
		ifPresent: [ :aCollection | 
			| aSortedInterfaces |
			aSortedInterfaces := aCollection
					asSortedCollection: [ :a :b | a name < b name ].
			String
				streamContents: [ :aStream | 
					aSortedInterfaces
						do: [ :anInterface | aStream nextPutAll: anInterface name ]
						separatedBy: [ aStream nextPutAll: ', ' ] ] ]
		ifAbsent: [ '' ]
]

{ #category : #'private - accessing' }
GtGQLTypeLinker >> queryType [
	^ self schema queryType
]

{ #category : #accessing }
GtGQLTypeLinker >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLTypeLinker >> schema: anObject [
	schema := anObject
]

{ #category : #'private - building' }
GtGQLTypeLinker >> typeReferencesAt: aTargetType putReference: aTypeReference [
	typeReferences
		at: aTargetType
		ifPresent: [ :aCollection | aCollection add: aTypeReference ]
		ifAbsentPut: [ OrderedCollection with: aTypeReference ]
]
