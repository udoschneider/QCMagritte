# Technical Details

For those who like some more background, we will dive into some
technical details of Magritte and QCMagritte. This is an optional
chapter, that will make it easier to follow the rest of the tutorial.

## Smalltalk background

I probably should start to some of the properties of smalltalk here, as
well as of Seaside. Important tools are the debugger, refactoring
possibilities, preserving state, adding libraries and such. There are
already quite a few good tutorials on these topics. So I will skip this
for new.

I personally liked the tutorial of Seaside done by James Foster
(http://seaside.gemtalksystems.com/tutorial.html) best. This is a very
good tutorial that explains such concepts.

## Descriptions

A typical magritte-description has a type (implicit), accessor, label
and priority.

```smalltalk
descriptionCompleted
    <magritteDescription>
    ^MABooleanDescription new
    accessor: #completed;
    label: 'Completed';
    priority: 300;
    beReadonly;
    yourself
```

The first line is a so-called pragma, allowing the magritte framework to
know it needs to proces the method as a description.

The type of this variable is a "boolean", thus a `MABooleanDescription` is
returned. The boolean can be accessed by using the accessor method
`completed` (and implicit the setter is set to `#completed:`). When displayed
it should be labeld "Completed" and the priority is 300.

The priority determines where it is displayed. Why don't you try
modifying the priority to `-1` to see the result.

The last setting that is made in the description is "readonly", stating
it can only be read, and the setter should not be called.

## Boolean description

Let's take this boolean description as a start-point to dive in deeper
into the framework. Select the classname `MABooleanDescription` by
double clicking it, and press **crtl-B** (Or **cmd-B** on a mac) to browse this
class.

Please note the following method:

```smalltalk
labelForOption: anObject
    anObject == true
        ifTrue: [ ^ self trueString ].
    anObject == false
        ifTrue: [ ^ self falseString ].
    ^ self undefined
```

This method clearly is the central object that determines how this
object is displayed. When you follow the local implementations you will
notice that all defaults are on the class side and can be overridden by
setting properties. These properties all have accesser methods, and
description that describe how they behave (with default and all).

Now go back to the method `descriptionCompleted` and select the entire
statement that returns the boolean description. Press **crtl-I** to open an
inspector on this object. Note that all properties like priority and
readonly are set in a dictionary `properties`. This mechanism allows the
framework to be extended easily by things not native to magritte, such
as magritte-seaside.

Finally, type `self magritteDescription` in the left bottom pane of the
inspector, select this and inspect. It will now open an inspector on the
magritte description of the boolean description. It gives you a list of
all properties that can be set, with default values and such. You will
find that most Magritte classes are documented using Magritte.

## Defaults

The default values of Magritte can be found on the class side of each
class. As we have seen, we have a default for the boolean for the `true`
and the `false`.

Let's make our description more accurate stating that for completed we
need a "yes" and a "no" instead of a "true" and a "false". Add the
following property lines to the description:

```smalltalk
trueString: 'yes';
falseString: 'no';
```

Now start a new session and see that all items now have a nice
desciption.

We furthermore want the description only to be shown when it is already
set. We do this by inserting a precondition in the `descriptionCompleted`.
When the title is not set properly: return nil.

Now go and look at the result by adding another todo-item. And then look
at the details. The new todo item should no longer have a "completed"
property, while an existing todo item has.

Unfortunately this also removes the "completed" from the list. Since we
now want to learn about the technical details of Magritte, and not yet
QC Magritte, I give the fix here without much explanation. We need to
set a defaultMagritteTemplate to the TodoItemClass, using following
code.

```smalltalk
defaultMagritteTemplate
    ^self new
        title: 'template';
        yourself
```

Before this takes in effect, we also need to reset the default template
using: `TodoItem resetDefaultTemplate`.

## Using components

For the boolean description you can find another default in the method
`defaultComponentClasses` in the categorie
**\*magritte-seaside-defaults**, indicating that this default is in an
extension for Seaside. It determines the default components that can be
used to display this object using seaside.

```smalltalk
defaultComponentClasses
    ^ Array with: MACheckboxComponent with: MASelectListComponent with: MARadioGroupComponent
```

It actually lists 3 default classes that can be used to display a
boolean. The first is used when nothing else is configured. Let's try
out setting the component class. First browse the senders and note that
there is a description that uses the `defaultComponentClasses` as the
valid options to select from. To experiment with this component class,
add a new boolean description "priority".

```smalltalk
descriptionPriority
    <magritteDescription>
    ^MABooleanDescription new
        accessor: #priority;
        label: 'Priority';
        trueString: 'high';
        falseString: 'low';
        priority: 350;
        componentClass: MARadioGroupComponent;
        yourself
```

Don't forget to add accessors and give it a try starting a new session.
You should see that this boolean is rendered differently. This allows
you to also use a custom (sub)class to render the component exactly how
it should be rendered.

## Builders

Following the guideline, make it work, make it right, make it fast, the
code now needs to be made right, because for a number of reasons the
code `componentClass: MARadioButtonComponent` does not belong there.

First of all it breaks our nice domain model, and pollutes it with
display code. This only works if I display the thing with Seaside. So
for making it work this is fine, but not in your final code.

Secondly, you usually want to use the same component for displaying a
boolean. Having to add this code for all boolean descriptions is code
duplication, with all disadvantages of code duplication.

So we are going to clean this code up, by using a builder. First we need
to define a builder class. This builder class belongs in the web-part,
so we define our builder-class as follows:

```smalltalk
MADescriptionBuilder subclass: #TodoListBuilder
    instanceVariableNames: ''
    classVariableNames: ''
    package: 'Tutorial-Web'
```

This builder belongs in the subpackage **Web** as it determines how things
look. Now we need to install this builder in the model. We use as a
category **\*Tutorial-Web** to indicate it is an extension method and
belongs in the package **Web**.

```smalltalk
tutorialBuilder: aCollection
    <magritteBuilder>
    aCollection add: TodoListBuilder
```

Now finally we need to implement the converter. Don't forget to add a
super call, since we do not want to break the visitor, visiting all
nodes.

```smalltalk
visitBooleanDescription: aBooleanDescription
    aBooleanDescription componentClass: MARadioGroupComponent.
    super visitBooleanDescription: aBooleanDescription
```

Remove the original `componentClass:` call in the description, and see the
radiogroup is still inserted.

