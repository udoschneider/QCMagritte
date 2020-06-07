*QC-Magritte-Session
ifLoggedIn: aBlock
	self session ifNotNil: [ :ses | ses ifLoggedIn: aBlock ]