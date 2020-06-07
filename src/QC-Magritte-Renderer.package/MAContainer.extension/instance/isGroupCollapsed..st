*QC-Magritte-Renderer
isGroupCollapsed: aGroup
	^ (self
		propertyAt: #collapsedGroups
		ifAbsentPut: [ self defaultCollapsedGroups ]) includes: aGroup