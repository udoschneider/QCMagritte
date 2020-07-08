| tutorialDirectory qcMagritteDirectory |
qcMagritteDirectory := FileLocator home / 'Documents' / 'Development' / 'QCMagritte'.
tutorialDirectory := (qcMagritteDirectory / 'docs' / 'Tutorial')
	ensureCreateDirectory;
	yourself.
QCTutorialModel default chapters
	withIndexCollect: [ :chapter :index | 
		| content |
		content := WAHtmlCanvas builder
			render: [ :html | 
				html heading
					level: 1;
					with: chapter title.
				html paragraph with: chapter description.
				chapter tutorials
					do: [ :tutorial | 
						html heading
							level: 2;
							with: tutorial title.
						html paragraph with: tutorial description.
						tutorial explanation renderOn: html ] ].
		tutorialDirectory / (index asString , '_' , chapter title) , 'html' writeStreamDo: [ :stream | stream nextPutAll: content ] ].
QCTutorialLibrary deployFiles.
FileLocator imageDirectory / QCTutorialLibrary name 	moveTo: tutorialDirectory