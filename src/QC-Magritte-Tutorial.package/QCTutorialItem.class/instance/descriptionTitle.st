magritte-description
descriptionTitle
	<magritteDescription>
	^MAStringDescription new
		priority: 100;
		label: 'Title';
		accessor: #title;
		comment: 'The title of this chapter.';
		beReadonly;
		visibleInReport: true;
		yourself