*QC-Magritte-Language
defaultLanguage
	^ self
		propertyAt: #defaultLanguage
		ifAbsent: [ QCMultilanguageString curLanguage ]