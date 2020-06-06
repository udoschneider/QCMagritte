*qc-magritte-session
model
	self mainPresenter
		ifNil: [ ^nil ]
		ifNotNil: [ :pres | ^pres model ]