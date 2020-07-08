# Adding projects

We continue with our todo application. We want to expand it to link
these todo items to projects.

## Renaming application

Since our application is starting to become a serious application, we
are going to rename it into `TodoApplication`.

First we are going to rename the class, using the refactoring tools of
Smalltalk. Right-click on the project to get the menu, and select
rename... input: "TodoApplication" in the dialog.

Secondly we are going to change the `title` and the `applicationName`. Note
that the application name is a method on the class side. For this we
need to check the box "class side" in the system browser. Then add the
following method:

```smalltalk
applicationName
    ^'TodoList'
```

Notice that the green triangle indicates you have overridden an existing
method. Also don't forget to switch back to the instance side.

Since we now have an application name, we can register this application
with `TodoApplication registerForDevelopment`. Now go back to the
website and browse the installed applications. Notice that we have added
**TodoList**, and that the **HelloWorld** application is also still there. When
you open the HelloWorld application, it points to our changed class of
`TodoApplication`. We want to remove this application, using the
configuration app of seaside. Go to http://localhost:8080/config and
remove the HelloWorld application.

## Projects

It is very common to have a todo list per project. So we start by adding
projects to our model.

First we need to define a project. For now we only put in a title for
the project.

```smalltalk
QCParentObject subclass: #TodoProject
    instanceVariableNames: 'title'
    classVariableNames: ''
    category: 'Tutorial-Model'
```

After creating the project we use the refactoring menu to add the
accessors for the `title`. Open the menu on `TodoProject`, and select
**Refactoring**, **Class Refactoring**, **generate accessors**. And accept the
suggested accessors.

As you can see there is now a new method category **accessors**. It is
good practice in smalltalk to put all methods in an appropriate method
category. Getters and setters belong in **accessors**, Magritte
descriptions in **magritte-descriptions**, actions in **actions**, etc. You
can let the system help you by trying to put the methods automatically
in a good category. Also drag and drop works here.

We continue by defining a description for the title. We can simply copy
paste this from the `TodoItem`.

```smalltalk
descriptionTitle
    <magritteDescription>
    ^MAStringDescription new
        accessor: #title;
        label: 'Title';
        priority: 100;
        beRequired;
        yourself
```

We also add the projects to the model. Important here is that the
accessor contains an initializer, so we list the code for this here.
Don't forget you also need a setter.

```smalltalk
projects
    ^projects ifNil: [ projects := OrderedCollection new ]
```

And the description for the projects:

```smalltalk
descriptionProjects
    <magritteDescription>
    ^MAToManyRelationDescription new
        label: 'Projects';
        accessor: #projects;
        priority: 300;
        classes: { TodoProject };
        yourself
```

When you start a new session, our projects should appear in the menu.
Add a few projects, so we have some data. Also do not forget to
implement the displayName.

## Migration

We are now going to extend our todo items with a project. Since the
project comes from the model, we also going to need a backlink to the
model.

We are going to add the following accessor to `TodoItem`. When you try to
save this method, it automatically gives you a few suggestions what to
do with project. Select it to be an instance variable. Also add a setter
for the project.

```smalltalk
project
    ^project
```

Now we are going to change the object definition to have a different
supperclass: `QCParentObject`. `QCParentObject` knows its parent, and the QC
Magritte framework make sure that new items are created with a
backlink,

```smalltalk
QCParentObject subclass: #TodoItem
    instanceVariableNames: 'title description completed project'
    classVariableNames: ''
    category: 'Tutorial-Model'
```

Before we proceed we have to realize that our current todo items do not
yet know their parent. We can solve this in two ways. First we could
simply throw away our current data by performing `TodoListModel reset`
in a workspace. But for the tutorial, we our going to take this
oppertunity, to teach you something about migration. Since migration of
data is a common problem when maintaining an application, we have also
put some support in the framework for this. We add the following method
to `TodoListModel`:

```smalltalk
sanitizeForUpgrade
    self todoItems do: [ :each | each parent: self ].
    super sanitizeForUpgrade
```

Now if we call the method `TodoListModel sanitizeForUpgrade` the
framework will follow the magritte descriptions and execute on all
objects this method. Note that we call our `super` after we do our own
sanitize code, because the ApplicationModel will walk the entire tree.
Why don't you take a look how this is implemented.

```smalltalk
TodoListModel sanitizeForUpgrade.
```

When you have looked at the code, you will have seen, that there was a
visitor called. In Magritte a lot of things are solved with visitors.
For more information on visitors look up the visitor pattern
(http://en.wikipedia.org/wiki/Visitor\_pattern).

## Ownership

Now we are finally ready to add the magritte description between the
todo item and the todo project. The relation we are going to make
between todolist items and projects is an interesting one. Because the
model is the owner of the projects, we want a "SingleOption" of the
projects. But at the same time we want to indicate that the project is
an object that can be opened and edited.

We have a special type of description for this added in QCMagritte:

```smalltalk
descriptionProject
    <magritteDescription>
    ^QCToOneOptionRelationDescription new
        label: 'Project';
        accessor: #project;
        priority: 250;
        options: self allProjects;
        classes: { TodoProject };
        yourself
```

And don't forget to add the accessor function `allProjects`:

```smalltalk
allProjects
    self model ifNil: [ ^#() ].
    ^self model projects
```

Now that it is a parentObject, we know what the model is and can
therefor access the projects. As a good practice, we want to avoid
errors, because of data corruption. First of all we protect this method
by checking if we can find the model. Secondly we prefer using the model
over the parent, because although now our parent is the model, in the
future we might want to decide to change ownership, and this would mean
that our parent no longer is the model. Now go back to the website and
select for a few todoitems the project.

If you missed out on some parts, it might be that your implementation is
incomplete. Don't panic when some error occurs, the Seaside framework
will help us fix the error. Since we installed the application for
development, a debugger should pop up in your image that points you to
the error. You can try to fix the errors, while in the debugger.

## Todos

Now we want to see the open todo items also in the projects.

So we are going to add the same construction in a project. Here we are
going to add the todo items as a magritte description.

```smalltalk
descriptionTodoItems
    <magritteDescription>
    ^MAToManyRelationDescription new
        label: 'Todo''s';
        accessor: #todos;
        priority: 250;
        classes: { TodoItem };
        beDefinitive;
    yourself
```

Note that we have a double quote in the todo's. This is because the
quote is normally an end of a string, and this is the escape sequence to
add a quote. For now we added the property `beDefinitve`, to disallow
adds and removals from this list.

We also have to implement the todo's, so here we need to be able to
access the model. The model needs the project to determine the todos for
this project.

```smalltalk
todos
    ^self model todosFor: self
```

And in the model we perform a simple select.

```smalltalk
todosFor: aProject
    ^self todoItems select: [ :each | each notComplete and: [ each project = aProject ] ]
```

Since the magritte framework also sends the message `todos:` on save, we
need this method as well. We can ignore this for now, just add the
method.

```smalltalk
todos: aCollection
```

Now go back to the site and look if it worked.

## Overview and details

Currently a new menu item is added for each detail view that is opened.
Since a detailview does not need the width of the entire screen, we want
to change that. We want to display the detailview next to the overview.
And if we have a smaller screen-size, we want to display it below the
overview.

First we are going to take a look at where the detailview is created. We
have to look at `QCApplication initialize` for this.

```smalltalk
initialize
    super initialize.
    self initializeMenu.
    " subscribe to events to display details "
    self on: QCShowDetails do: [ :ann | self showDetails: ann ].
    self on: QCShowQuery do: [ :ann | self showQuery: ann ]
```

We see that we are registering to 2 announcements (events):
`QCShowDetails` and `QCShowQuery`. We are currently interested in the first
`QCShowDetails`. When the announcement is fired, we call the
`showDetails:` method with the announcement that is fired. First we are
going to put a `halt` in between there to see what is happening. Add the
following method to your `TodoApplication`.

```smalltalk
showDetails: anAnnouncement
    self halt.
    ^super showDetails: anAnnouncement
```

Now go back to the website and click on **details** for an item. Then go
back to the image, and you should have a debugger that stopped on the
halt we just added. Explore the announcement. You can see that there is
one parameter, the object that we need to display. Let the code continue
for now.

First we are going to make some room for the page. Since an
`QCApplication` is a `QCPageChoice`, at some point the
`renderCurrentPageOn:` is called to render the current page. There we
are going to split the page in two columns. We override this method as
follows:

```smalltalk
renderCurrentPageOn: canvas
    canvas tbsRow: [
        canvas tbsColumn
            mediumSize: 6;
            with: [ super renderCurrentPageOn: canvas ].
        canvas tbsColumn
            mediumSize: 6;
            with: [ self renderDetailPageOn: canvas ] ]
```

```smalltalk
renderDetailPageOn: canvas
    canvas heading: 'Details'
```

Go back to the website and see how it looks.

Now we need to replace the `showDetails:` method. First look at the code
to see what is done by default. Now we are going to store a details page
ourselves, instead of adding it (that adds it as a child of the current
page. Edit the `showDetails:` as follows:

```smalltalk
showDetails: anAnnouncement
    detailsPage := self createPageFor: anAnnouncement target
```

Now we have 3 things left to do before this works. We need an accessor
for the details page, and we have to actually show the page, by
modifying the renderDetailPageOn: canvas. We leave this up to you.
Finally we need to change the `children` method, as we have to tell
seaside we have an extra child page. Modify the children page as
follows:

```smalltalk
children
    ^self detailsPage
    ifNil: [ super children ]
    ifNotNil: [ super children copyWith: self detailsPage ]
```

## Announcements

When we look at the result, we see that there are several problems with
our current implementation.

First of all, we see that the details should not be used for all
objects. We can open projects in the todo-list, and that might not be
such a good idea. Also changing the menu will change the left page, but
will leave the details page as is. So we have implemented this in the
wrong place. We are going to redirect this to the overview.

First we need our own overview class, so we can add the code for the
columns and render the detail view here. Add the class `TodoOverview` as a
subclass of `QCBootstrapOverview` in the category **Tutorial-Web**. We need to
link this class to the `TodoApplication`. We do this by overriding the
overview class:

```smalltalk
overviewClass
    ^TodoOverview
```

Now we are going to move all methods with our modifications. Simply use
drag and drop to move the following methods: `renderDetailPageOn:`,
`detailsPage` and `children`. We copy the method: `showDetails:`.

The `renderCurrentPageOn:` needs a small change after moving, so we
copy/paste this method and rename it to `renderContentOn:`, and also
modify the reference to the `super`.

Finally we need to add the `createPageFor:` method on `TodoOverview`, as
this method is called, and is implemented in `QCApplication`. As an
overview does not inherit from `QCApplication` we need the implement this
here. Also we need some initialization.

```smalltalk
createPageFor: anObject
    ^(QCBootstrapDetailView on: self target: anObject)
        canClose: true;
        yourself
```

```smalltalk
initialize
    super initialize.
    self on: QCShowDetails do: [ :ann | self showDetails: ann ]
```

The last method will subscribe the overview component to the event:
`QCShowDetails`. Now go back to the website and check the behavior. You
will notice that when you press on a details, it still does not work. A
details page keeps a reference to the previous page. It does so, by
asking the parent for the current page. In the debugger create this
method and supply the following answer:

```smalltalk
currentPage
    ^self detailsPage
```

We could also have chosen simply to return `nil`, but we will use this
later in the tutorial. Notice on the website that the behavior has not
changed. But now we are nearly there. Instead of creating one details
page in the application, we now have 3 details pages, created by the
overviews. But instead of creating 3, we should create only a details
view, when the overview is displaying the element. So we change the
`showDetails:` method once more:

```smalltalk
showDetails: anAnnouncement
    (self isShown: anAnnouncement target)
        ifTrue: [ detailsPage := self createPageFor: anAnnouncement target ]
```

```smalltalk
isShown: anObject
    ^self report rows includes: anObject
```

An overview holds a reference to the report that shows the objects.

Now try to open the details of an open todo item. You can see that it is
opened in 2 places: in todo's and in All items, but no longer in
projects. Now when we open the details of a project, by clicking on a
project, we still have not the desired result, as the details are opened
on an invisible page. So we go back to the `showDetails:` in the class
`TodoApplication`. Change the code to:

```smalltalk
showDetails: anAnnouncement
    (self currentPage showsObject: anAnnouncement target)
        ifFalse: [
            super showDetails: anAnnouncement ]
```

So we revert to our old `showDetails:`, with a modification to test if
it is visible on the current page, as there may be multiple pages where
the object will be shown. Now we are going to add the following method
to your new overview, since our overview will now also show the details
of the objects:

```smalltalk
showsObject: anObject
    ^(super showsObject: anObject) or: [ self isShown: anObject ]
```

```smalltalk
isShown: anObject
    ^self report rows includes: anObject
```

Now see how it looks like.

## Active record

We are not completely satisfied with the result. First of all, it is a
waste of space when the details are not shown. Secondly, the user can
and should be helped more, to make it more visible for the user what
record is shown. And have you tried pressing cancel or save? It does not
do what the user would expect.

The first one is easy. We simply need to check in the overview if the
details page exists, and if not revert to the original
`renderContentOn:`. This will change our rendering code into:

```smalltalk
renderContentOn: canvas
    canvas tbsRow: [
        self detailsPage ifNil: [ ^super renderContentOn: canvas ].
        canvas tbsColumn
            mediumSize: 6;
            with: [ super renderContentOn: canvas ].
        canvas tbsColumn
            mediumSize: 6;
            with: [ self renderDetailPageOn: canvas ] ]
```

The second line tests if the `detailsPage` is `nil`, and if so it calls the
`super`. But here we put in a trick: we return the value of the `super`,
causing the rest of the method not to be processed any more.

The second thing we are going to do, is to fix the "close". When you
look at the code of the `QCAppComponent`, there is a `closeOn:`
implemented. This methods checks if its parent exists, and if so, it
asks its parent to close itself. Here we created the details component
with as parent the overview. So we should simply implement on the
`TodoOverview` the method `close:` as follows:

```smalltalk
close: aPage
    (self detailsPage = aPage) ifTrue: [ detailsPage := nil ]
```

To be certain it is the right page we are closing, we check if it is
indeed our details page. It should not occur for any other pages, but
for robustness we ignore this error.

If you look at the implementors of `close:` you see that there are three
implementors of this method in the QCMagritte framework. The methods all
three work the same: find the page, and if found close this page. But
because all three classes have a different structure for the pages they
store, the implementations are all different.

Now we want to add one more detail to make the user interface better. We
want to make the row that is shown in details active. Since we have a
link to our report in our overview, we add the code for this here. This
makes the new implementation of the `showDetails:` in `TodoOverview`:

```smalltalk
showDetails: anAnnouncement
    (self isShown: anAnnouncement target)
        ifTrue: [
            detailsPage := self createPageFor: anAnnouncement target.
            self report setActive: anAnnouncement target ]
```

## Monticello

Untill now we have only saved our work in our image. This is perfectly
fine to start with, but when you want to be able to deploy your
application you need to export your code outside of your image. This is
a good time to start doing so.

For exporting code we our going to use a tool called Monticello. There
is a manual on Monticello in Pharo by example
(http://pharobyexample.org). I will limit my explanation to your task at
hand: save your tutorial application. Open a Monticello browser from the
world menu. Since we are only interested in Tutorial, we are going to
type this in the top left input screen. Now you should see the two
packages you created here: **Tutorial-Model** and **Tutorial-Web**. The **\***
before the text indicates there are unsaved changes.

Select one of the package and then press the button: **+Repository**. Now
you can select where you want to save it. We will select a directory
(local folder) for now. Select the folder on your system where you want
to save it and press ok. Now we still need to save the package, so press
the button "Save" to actually save the package. You get a dialog
requesting a comment for this save. We our going to put in "initial
version" and then press accept.

We need to repeat this process for the second package. Add a repository,
then press save. Now in the dialog you also have the option **old log
messages...**. Use this button to enter the same comment, then press
accept to commit this package to. Look at the folder you selected and
see that there are two files created here, both with the extension
`.mcz` These files can be loaded into any smalltalk image.

Now save your image and proceed with the next chapter

