*QC-Magritte-Session
requestContext
	"Answer the current WARequestContext instance."

	[ ^ WACurrentRequestContext value ]
		on: WARequestContextNotFound
		do: [ :ex | ^ nil ]