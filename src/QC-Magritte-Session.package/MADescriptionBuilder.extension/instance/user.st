*QC-Magritte-Session
user
	self session ifNotNil: [ ^ self session user ].
	^ nil