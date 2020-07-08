# Todo List

At this point we are going to start building a simple application to
demonstrate some basic QCMagritte functionality and introduce you to
more Smalltalk and Pharo as we go along. The application will allow you
to maintain a simple todo list, that allows new items to be added and
existing items to be "completed". Instead of starting with a user
interface, we will start with a domain model that holds a todo item.

## Todo item

Start the QCMagritte One-Click Experience and in the System Browser
click on an item in the first column to get a new class-creation
template. Edit the template to match the following and save the text.

QCObject subclass: \#TodoItem
instanceVariableNames: 'title description completed'
classVariableNames:''
category:'Tutorial-Model'

This creates a new subclass of QCObject named "TodoItem", gives it three
instance variabes ("title", "description" and "completed") and puts it
in the "Tutorial-Model" category.

## Accessors

Next we will define a couple of‘accessor (or‘getter) methods that simply
return the value of the instance variable. (The method return is
signaled by the up arrow or caret at the beginning of an expression.)
These methods are necessary because in proper Smalltalk there is no
direct structural access to the instance variables (or properties or
fields) of an object. This language design enforces encapsulation and
allows the implementation of an object to change (perhaps the ‘price’ is
calculated every time it is requested rather than saved with the
object). Note that these are two separate methods.

To get to a method creation template, click on ‘Todo-List-Model’ in the
first column, click on ‘TodoItem’ in the second column, click on ‘-- all
--‘ in the third column, click in the text area at the bottom of the
system browser, and finally select all using \<Ctrl\>+\<A\> (or click in
the text area after the end of the last line). Enter the first method
(two lines), save (using \<Ctrl\>+\<S\>), and then select all, delete,
and enter the second method (two lines), and save.

title
^title

description
^description

completed
^completed ifNil: \[ false \]

When an instance variable is not initialized it is nil by default. We
send the message "ifNil:" to this variable, and if this variable is nil
the block that is passed is evaluated. Evaluation gives the result
false. If the variable is something else, the message "ifNil:" returns
the variable itself.

## Setters

Next we will define the setters’that store the value in the instance
variable. As documentation we will put the name of the expected type in
the variable name

title: aString
title := aString

description: aString
^description := aString

completed: aBoolean
completed := aBoolean

## Descriptions

Now that we can access our variables properly we need to add
descriptions to our class. These descriptions will be marked with a
"pragma" (annotation) that allows the framework to recognize these
methods. The syntax for a pragma is "\<" the annotation "\>"

descriptionTitle
\<magritteDescription\>
^MAStringDescription new
accessor: \#title;
label: 'Title';
priority: 100;
beRequired;
yourself

We state here that the title has a type of String. The accessor links it
to the getter "title" and setter "title:". The label is shown to the
user in front of the field, to make it recognizable. Finally the
priority determines the order in which the fields are shown. We use 100
by default for the first item to be shown. Also we indicate that the
title is a required field and should be filled out by the user.

descriptionDescription
\<magritteDescription\>
^MAMemoDescription new
accessor: \#description;
label: 'Description';
priority: 200;
yourself

A Memo is a longer string. Since different components should be used to
display and edit long strings, for magritte this is considered a
different type.

descriptionCompleted
\<magritteDescription\>
^MABooleanDescription new
accessor: \#completed;
label: 'Completed';
priority: 300;
yourself

Finally, our completed variable is of type boolean. It can either be
true or false.

## Model

We now have a class that we can show. We need to put this class into a
model. The model will be a single access point for the application where
all objects are stored. As we use the Bootstrap template, we will use
QCBootstrapApplicationModel as our base class for our model

QCBootstrapApplicationModel subclass: \#TodoListModel
instanceVariableNames: 'todoItems'
classVariableNames: ''
category: 'Tutorial-Model'

For the todoListItems we also create a getter and a setter.

todoItems
^todoItems ifNil: \[ todoItems := OrderedCollection new \]

Note that we need to initialize the todoItems so we can add items to
it.

todoItems: aCollection
todoItems := aCollection

## Items Description

Also, for our model we need to create a description for the todo list
items. In our description we will link it to our class we created at the
beginning of this chapter.

descriptionTodoItems
\<magritteDescription\>
^MAToManyRelationDescription new
label: 'Todo';
accessor: \#todoItems;
priority: 200;
classes: { TodoItem };
yourself

The type of the todo list is a "to many relation" to the classes
"TodoItem". Note that the "{" "}" creates an array of the things that
are listed in between.

## Link to application

Finally we need to link our model to the application. As this is simply
a demo, we will bind it to the Welcome application we already have made.
Here we override the "model" method.

model
^TodoListModel default

In QCApplicationModel we have defined a class variable "default". This
class variable is created once for all subclasses. We use this class
variable as our singleton, so we can access our model from all
sessions.

## First version

Now we can check to see if our website is working. Go to "Hello World"
in the browser and press reload. It should add "Todo" in the menu, and
since this is the first item, automatically select it.

You should see the following screen:

Now we are going to test this application by adding some todo items.
Just fill them out however you like.

Note that the user can double-click an item to edit this item inline in
the report (same as the edit-button). Also adding will simply "add" the
items, and removing will need a confirmation before the remove is
actually committed. So the user can always undo his action quite
easily.

Also there is a button where we can go to the details. This will open a
new page where you can edit the item as well.

## Display name

When you click on the details of an item, it opens a new page. But the
title of this page is still a bit silly: it states: "a TodoItem". This
is because in smalltalk the default "toString" implementation provides
us with this. We want to change this name into the title.

In the framework it suffices to change the displayName. This will change
all strings that are for the user visible. We add the following method
to TodoItem.

displayName
^self title ifNil: \[ 'New item' \]

We could have simply used "^title". We believe this is not a good
practice, as we could later add a "lazy" initialization of the title. We
therefore use "self title", such that any code we put in the accessor
method (title) will be triggered. We also add a default, that is used
when the title is not set.

When you go back to the website you can simply reload the page. It will
automatically update the title of the page. This also means that when
the title of a todo item changes, this will also be reflected in the
page title.

## Completed

From the perspective of the user, the column completed is a bit odd. We
can add items that are already completed, and simply check this box. We
should do something about this.

First of all we are going to disallow the user to change this value by
hand. We are going to make this column readonly. We do this by adding
the message: "beReadonly" in the cascade of the description readonly.
This method should look like this after editing:

descriptionCompleted
\<magritteDescription\>
^MABooleanDescription new
accessor: \#completed;
label: 'Completed';
priority: 300;
beReadonly;
yourself

But we still want to be able to complete a todo item. We do this by
adding actions to the todo item. We add the following method:

containerActions: aContainer
\<magritteContainer\>
^aContainer
addCommand: 'Complete' action: \#complete;
addCommand: 'Reopen' action: \#reopen;
yourself

Here we see a new pragma: "magritteContainer". Because the method has a
parameter it indicates it should be called with the container that is
created. It is called before we add our descriptions. Here we add our
commands.

There is a second special thing here we want to note: \#complete is a
symbol. This is a constant in Smalltalk. In Smalltalk we can use these
symbols to call methods on objects.

The command here means that the method complete will be called when the
user presses on the action "complete", that is both visible in the
overview and the details. This means we need to implement these methods
as well:

complete
completed := true

reopen
completed := false

Go back to the website and test how this looks. There is a good chance
that reloading won't change a thing, because the component is already
initialized with the magritte-description. We will go into the technical
about this later, for now: if the webpage has not changed, press the
"new session" button on the bottom left.

## Conditions

Now we have links to complete and reopen an item, but this still is a
bit awkward. The links are shown always, independant of the state.

We are going to add a condition to the commands. This is quite simple as
we only need to fill out the parameter for this.

containerActions: aContainer
\<magritteContainer\>
^aContainer
addCommand: 'Complete' condition: \#notComplete action: \#complete;
addCommand: 'Reopen' condition: \#isComplete action: \#reopen;
yourself

Of course we need to implement the two method's that are referenced here
too.

isComplete
^self completed

notComplete
^self completed not

Save these methods and go back to the website and see the changes. Since
we always edit the descriptions, and the description methods are called
on creation of the components, we need a new component to actually see
these changes. A new session will start everything new, so it will
create a new component. As we proceed, you will notice that for some
changes you only have to refresh the page, while for others you will
need a new session. Keep this in mind when developing your
application.

## Open items

Finally we are going to make one last change to complete this chapter.

We are going to add a second description to our model. Instead of
showing all todo items, we only want to show the incomplete todo items.
Since this method looks very much like our first description, we first
select the description. First we are going to save this as a different
method by changing the first line into: "descriptionOpenItems", and then
save.

By saving the same method under a different name, we automatically have
a copy of the method. Now we change the accessor of this copy into:
\#openItems", set the priority into 100 and the label to "Open todo's".
The result should look like this:

descriptionOpenItems
\<magritteDescription\>
^MAToManyRelationDescription new
label: 'Open items';
accessor: \#openItems;
priority: 100;
classes: { TodoItem };
yourself

In the original method we change the label into: "All items" and the
priority into 200. Finally we need to implement the new accessors.

openItems
^self todoItems select: \[ :each | each notComplete \]

The "select:" method returns a collection with only the items for those
the block will evaluate to "true".

openItems: aCollection
self openItems do: \[ :each |
(aCollection includes: each) ifFalse: \[ self todoItems remove: each \]
\].
aCollection do: \[ :each |
(self todoItems includes: each) ifFalse: \[ self todoItems add: each \]
\]

When you edit a collection in Magritte, Magritte assigns the whole
collection to the object after the change. So you will not notice any
individual add or remove actions. So we need to implement here the
difference. First we check for all removals, then we check for all new
items.

## Open items

When all went successfull there are now two menu items: one showing the
todo list, and one showing all items, including the items that are
completed. When you press the button completed, it should be removed
from the todolist; and re-opening an item should add it to the todolist.

Save and quit the image and proceed with the next chapter.
