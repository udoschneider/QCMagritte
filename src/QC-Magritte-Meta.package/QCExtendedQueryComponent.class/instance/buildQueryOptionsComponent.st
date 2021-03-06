initialization
buildQueryOptionsComponent
	| retVal |
	retVal := QCAccordionComponent new.
	retVal addPage: (QCSearchForm onParent: self) label: (QCSearchLabel onParent: self).
	self toManyComponent ifNotNil: [ :comp |
		retVal addPage: (self columnChooserFor: comp) label: (QCMultilanguageString on: 'Choose columns').
		comp
			resetReportCommands;
			addReportCommand: (QCCommand on: 'Hide options' condition: [ self isOptionsVisible ] action: [ self hideOptions ]);
			addReportCommand: (QCCommand on: 'Report options...' condition: [ self isOptionsVisible not ] action: [ self showOptions ]).
		retVal addPage: (self reportOptionsFor: comp) label: 'Report options' ].
	self addCustomOptionsTo: retVal.
	^retVal