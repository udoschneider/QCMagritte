magritte-description
descriptionItems
	<magritteDescription>
	^MAToManyRelationDescription new
		label: 'Selected items';
		accessor: #items;
		beDefinitive;
		classes: { QCSelection };
		reference: (QCSelection on: self magritteTemplate) magritteDescription;
		priority: 100;
		tabDisplay: false;
		startEditAll: true;
		canExport: false;
		yourself