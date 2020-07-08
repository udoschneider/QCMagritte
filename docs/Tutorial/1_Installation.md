# Installation

For our first QCMagritte project we will use the “QCMagritte One-Click
Experience” in Pharo. If this tutorial came with a DVD, copy
‘QCMagritte.app’ to your desktop and skip to step "Launch". Otherwise,
follow steps "Download" and "Unpack" to download Seaside from the web.

## Download

This tutorial is a work in progress. When this tutorial is complete it
is to include a link that gives a "one-click" image with QCMagritte
installed. The first item should contain a link where you can download
the "packed" one-click image. Please click on details for further info.

<div>

For now we will summarize the chapter "installation" as follows:
download a QCMagritte image and make sure you can launch it.  

Also at some points there are references to images. The images are not
yet included in the tutorial and should be added.  

Finally, as this is work in progress, you might need to "reset" this
tutorial to get a new version. I included a button here to do so.  

</div>

## Unpack

Locate and unzip the file (if the download process did not unzip it for
you). This will create a folder with a name similar to “QCMagritte.app”
that you should place in a convenient location (such as the desktop).

<div>

</div>

## Launch

Find the executable appropriate for your operating system: Mac, Windows,
or Linux. On the Macintosh, the folder will appear as a starfish icon
representing an application package. On Windows, the folder can be
opened to find various items, including a shortcut named ‘QCMagritte’.
On Linux, the folder can be opened to find various items, including
‘QCMagritte.sh’. Double click on the appropriate icon to launch the
executable.

<div>

</div>

## Pharo image

When you launch the executable, you are actually starting a web server
in Pharo Smalltalk. (Currently, do-it ZnZincServerAdaptor startOn:
8080).

<div>

In the world menu, select Tools\>Seaside Control Panel  

![](/files/QCTutorialLibrary/SeasideMenu.png)

An empty control panel comes up. In the top pane, right click to add an
adapter. Select the ZnZincServerAdaptor  

![](/files/QCTutorialLibrary/AddAdapter.png)

Select the port to use. In this tutorial we'll assume port 8080.  

![](/files/QCTutorialLibrary/SelectPort.png)

The adaptor is added, but it is not yet started.  

![](/files/QCTutorialLibrary/StoppedAdaptor.png)

Select the adaptor and start it  

![](/files/QCTutorialLibrary/StartedSeaside.png)

As we continue through this tutorial, we will refer to this executable
as “Pharo” to distinguish it from the Seaside code framework that Pharo
contains. Like most Smalltalk dialects, Pharo runs as a “virtual
machine” on your host operating system. You should see a new main
window containing three smaller windows. This main window gives you a
graphical user interface into an object space loaded into memory from
the file ‘seaside.image’ that was part of the earlier download. This
‘image’ is a copy of one with QCMagritte and a simple web server
already loaded. The inner windows will be the same on all three
platforms and will not look like windows created by other applications
on your platform. One of the windows, labeled “QCMagritte 1.x.y”
contains a comment telling you that a web server is already running and
you can point your web browser to http://localhost:8080/ to give it a
try.  

</div>

## Test download

Open a web browser on http://localhost:8080/ to confirm that things are
up and running correctly. You can poke around a bit here, but don’t get
too distracted at this point. We’ll be exploring QCMagritte in more
detail in Chapter 2: Hello world

<div>

</div>

## Save image

As we go along, we will be creating and editing code and other objects
in the Pharo object space. To make the change persistent, you need to
make a snapshot of the current object space—creating a new “image”
(following a camera metaphor). To do this, left-click on the background
(or desktop) to bring up the World menu and select ‘save’ from the menu.
This will write out your changes to the default ‘seaside.image’ file
that will be read when you next launch the QCMagritte One-Click
Experience.

<div>

</div>

## Save image as...

Smalltalkers refer to the above action as “saving the image,” and this
is a handy way to preserve your changes and the environment. Think of it
as a suspend action (or hibernate) for your computer. When you come back
and restart your computer the same windows will be open in the same
location with the same contents. If you are about to try something that
might cause a problem, you could save the image before taking the risky
action. Then, if things go bad you can quit without saving (see step
\#10 below) and simply reopen the saved image to get back to the prior
state. Alternatively, you can change the name of the saved image by
selecting the ‘save as…’ menu item.

<div>

</div>

## Save as dialog...

This will open a dialog asking for a name for the new image. Name the
new image ‘backup.image’ and click OK or press \<Enter\>. This gives us
a ‘clean’ or ‘virgin’ image that can be restored without downloading
everything again from the web or copying from a CD/DVD.

<div>

</div>

## Back up

To see the new file, open the application folder ‘Contents’ then
‘Resources’ (on the Mac you will need to right-click on the
Application icon and select ‘Show Package Contents’). If you ever want
to start over, simply delete ‘Seaside.changes’ and ‘Seaside.image,’ copy
‘backup.changes’ and ‘backup.image,’ and rename the copies to
‘Seaside.changes’ and ‘Seaside.image’ (note that capitalization might
be important, depending on your platform).

<div>

</div>

## Quit

Now we are ready to quit the application. Left click on the background
to bring up the (now familiar) World menu and select the last item,
‘quit.’ In the ‘Save changes before quitting?’ dialog, select ‘No’ to
quit without saving (since we already saved two images of the current
object space).

<div>

To go to the next chapter: close this tutorial item (go back up), and
press next to open the next chapter.  

</div>
