# Hello world

When learning a new programming language it is traditional to start with
a "Hello World\!" application (see
http://en.wikipedia.org/wiki/Hello\_world\_program). We will follow that
practice and use this oppertunity to introduce you to the programming
enviornment and the Smalltalk programming language.

## Launch QCMagritte

Start by launching the QCMagritte One-Click Experience executable as
described in chapter **installation**. This will open a copy of
**seaside.image** using Pharo. "open windows"

## Playground

A playground provides a text area in which you can evaluate expressions
and (optionally) display or inspect the results. Since this might be
your first exposure to Smalltalk code, we'll give a brief introduction
to evaluating Smalltalkcode in a Playground. (If you already know
Smalltalk or are just impatient, you can skim or skip this part\!)

To open a playground press anywhere in the environment and you should
get the world menu. The second option from the top opens a playgound.

Click in this newly opened window and then type the following:

```smalltalk
5 factorial.
```

Press the green arrow (the play button, with mouse over text do it and
go) and you should get an inspector on the result, showing that `5
factorial` is `120`.

## MainClass

In QCMagritte, the basic application class is a subclass of
`QCApplication`. We will start with a bootstrap template, and subclass
from `QCBootstrapApplication`, so we have decent layout and do not have to
focus on that. In the System Browser, click on any line in the first
column to get a new class-creation template. In the text area replace
the existing text (beginning with `Object subclass: \#NameOfSubclass`)
with the following and save it (**\<Ctrl\>+\<S\>**).

The System Brower can also be found in the world menu (top item).

```smalltalk
QCBootstrapApplication subclass: #HelloWorldApplication
    instanceVariableNames: ''
    classVariableNames: ''
    category: 'Tutorial-Web'
```

Unfortunately, copying from this document in your web browser and
pasting into Pharo might not preserve the formatting. If this is a
problem, you should use a simple text editor (such as Notepad on
Windows, TextEdit on the Mac, or MousePad on Linux) as an intermediate
paste/copy location.

Depending on your environment, you might find that **\<Alt\>+\<S\>** (or
**\<Apple\>+\<S\>** on the Mac) can be used instead of **\<Ctrl\>+\<S\>**. This
should result in a new line with **Hello-World** alphabetically inserted
into the class category list (the first column) and the single line
**HelloWorld** in the second column.

The first thing to note here is that we have created a subclass of
`QCBootstrapApplication` by sending a message to the class
`QCBootstrapApplication`, not by editing a text file and then sending it
through a compiler and then starting an application. In Smalltalk we do
not program "by editing text files", but by interacting with existing
objects in an existing, active, object-based environment using tools
that are in that environment. If we were to save this modified object
space as an image, and then restart from that image, the class would
still exist.

## Title

For all QCMagritte applications, there are two required fields that need
to be filled out. First we need to give our application a title by
implementing the method `title`. To add an instance method to our
`HelloWorld` class, ensure that the instance side of the class is selected
(the class button is not checked and the method categories not bold. If
needed click on the class button), then click in the third column (the
method categories list) on **no messages**. This will change the text area
from a description of the class to a method template. Type the following
method definition.

```smalltalk
title
    ^'Hello world!'
```

In Smalltalk, methods start with the name of the method (the message
selector) and the name of any arguments. The remainder of a method
consists of Smalltalk expressions that are evaluated when the method is
called. Just as all expressions return an object, all methods return an
object (which, of course, the caller is free to ignore). By default, the
method returns the receiver, but any expression following the
"circumflex accent", usually referred to as "up arrow" or "caret" (`^`),
will be returned as the expression's result. (This up arrow is one of
Smalltalk's two operators. See step "Assignment" for the assignment
operator.)

## Save method

When you save your first method (using **\<Ctrl\>+\<S\>**), Pharo asks for
your name so it can keep stock of by whom and when the method was last
edited. In the following dialog box enter your name (with no punctuation
characters) and press **\<Enter\>** or click the OK button:

The result should be a System Browser that has a method category of **as
yet unclassified** and lists your method as **title**. The green arrow
pointing up next to the method name in the fourth column is an indicator
that you have overridden a superclass method. The third column also will
contain the **--all--** category to allow selecting all methods.

## Registration

Now we need to inform Seaside that this new component can be used as a
root component. In order to do this we need to tell the class what name
to use when it registers itself as an application. Switch to the
Playground and evaluate the following text by clicking anywhere in the
line and typing **\<Ctrl\>+\<D\>** (for "do-it"). If you have trouble, go
back to the beginning of this chapter.

```smalltalk
HelloWorldApplication registerForDevelopmentAt: 'HelloWorld'.
```

## Browse

If the above steps were successful, you should be able to open a web
browser on http://localhost:8080/browse. The browse Installed
Applications page gives you a list of the top-level links being served
from by this web server, including our new HelloWorld application.

Open your HelloWorld application and see that is shown in a bootstrap
template. On the top left you can now go back to your "starting" point
of the application. As we have nothing else implemented, it indicates we
need a model to proceed.

## Add Time

The QCMagritte application framework is model driven. This means the our
application needs to have a described model, to actually do something.
Because we do not have a model yet, it renders an error message. For now
we will not create a model, but take a shortcut and override the
`renderErrorOn:` instead.

Go to your class browser and create the following method on the class
`HelloWorldApplication`:

```smalltalk
renderErrorOn: html
    | now |
    now := DateAndTime now.
    html
        heading: 'Current time';
        text: now;
        yourself
```

This code introduces some new syntax. Line 2 defines a method temporary
variable, `now`, that is declared by placing it between vertical bars
(or pipe characters). In Smalltalk (like Perl, Python, PHP, and others),
variables are dynamically typed (as opposed to the static typing of
languages like C and Java where types must be declared at compile time).
This means that all we need to do is specify the name and this will
reserve space for the object reference.

Line 3 is an expression that introduces the second of Smalltalks two
operators (the return operator was mentioned in step \#8). The
assignment operator or colon-equals (`:=`) is used to take the object
returned by the expression on the right and place a reference to it in
the variable defined on the left.

Lines 4-7 are a single expression. Since extra whitespace is ignored in
Smalltalk you can add new lines and tabs for cosmetic styling. Next,
recall that expressions are made up of receivers and messages and that
there are three types of messages: unary, binary, and keyword (evaluated
in that order). On line 5 the keyword message `heading:` that is sent to
`html` with a String as an argument. Normally this line would en with a
period (which would indicate the end of an expression), but this message
ends with a semicolon.

This semicolon indicates a "message cascade," meaning that that what
follows is not a full expression (which would require an object
reference to designate the receiver), but another message to the
receiver of the most recent message. The receiver of the last message
was the object referenced by the method argument html, so the next
message will be sent to the same object. The next message is also a
keyword message, `text:` also takes one argument, the variable `now`.

Finally, we have the `yourself` message that is sent to the receiver of
the most recent message. The `yourself` message calls a method that
simply returns the receiver. In our case, since we ignore the returned
object, this message send is nothing more than (a slightly inefficient)
cosmetic filler so that the previous line can end with a semicolon
rather than a period (which would probably be the more common approach
for most Smalltalkers). This programming style allows you to come back
later and add another line or rearrange the lines without having to
change the line ending character.

## Test

Now return to your web browser and refresh a few times and watch the
time change.

## End

At this point you can return to Pharo and save the image and quit (as
described in the previous Chapter "installation").

To go to the next chapter: close this tutorial item (go back up), and
press next to open the next chapter.
