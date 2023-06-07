Extension { #name : #LeHtmlVisitor }

{ #category : #'*GToolkit4GraphQL' }
LeHtmlVisitor >> visitGQLSnippet: aLeGQLSnippet [

	context html
		tag: #div
		attributes: #('class' 'snippet textual-snippet code-snippet graphql-snippet')
		do: [
			context html
				tag: #pre
				attributes: #('class' 'no_bottom_margin')
				with: aLeGQLSnippet operation. ].
				
	aLeGQLSnippet input trimBoth ifNotEmpty: [ 
		context html
			tag: #div
			attributes: #('class' 'snippet textual-snippet code-snippet graphqlinput-snippet')
			do: [				
				context html
					tag: #pre
					attributes: #('class' 'no_bottom_margin')
					with: aLeGQLSnippet input  ] ].
	
	^ self visitContent: aLeGQLSnippet
]
