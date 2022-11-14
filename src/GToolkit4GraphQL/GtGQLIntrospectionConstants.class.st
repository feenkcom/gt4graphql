Class {
	#name : #GtGQLIntrospectionConstants,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'api - constants' }
GtGQLIntrospectionConstants class >> essentialTypeQuery [
	^ self typeRefFragment
		, '

fragment EssentialField on __Field {
	__typename
	name
	type {
		...TypeRef
	}
	args {
		__typename
		name
		type {
			...TypeRef
		}
		defaultValue
	}
}

fragment EssentialType on __Type {
		__typename
		kind
		name
		ofType {
			...TypeRef
		}
		fields {
			...EssentialField
		}
	}

query SchemaFields($name: String = "__Type") {
	__type(name: $name) {
		...EssentialType
	}
}'
]

{ #category : #'api - constants' }
GtGQLIntrospectionConstants class >> typeRefFragment [
	^ 'fragment TypeRef on __Type {
	__typename
	kind
	name
	ofType {
		__typename
		kind
		name
		ofType {
			__typename
			kind
			name
			ofType {
				kind
				name
				ofType {
					kind
					name
					ofType {
						kind
						name
						ofType {
							kind
							name
							ofType {
								kind
								name
							}
						}
					}
				}
			}
		}
	}
}'
]
