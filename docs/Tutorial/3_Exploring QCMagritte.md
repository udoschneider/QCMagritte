# Exploring QCMagritte

Before we proceed, we will explore some of the features of QCMagritte.

## Seaside and Magritte

QCMagritte is build on top of 2 frameworks: Seaside and Magritte. On
Seaside there are several tutorials, and they can be found on the
official Seaside website: http://www.seaside.st. If you are new to Smalltalk
and Seaside, it might be a good idea to follow a tutorial on Seaside
first. We will not explain the concepts of Seaside in the tutorial, as
there are several good tutorials on this topic that can be found on the
seaside website.

If you want to know more about Seaside at this point, we recommand you
follow the tutorial of James Foster
(http://seaside.gemtalksystems.com/tutorial.html). Note that this
tutorial reuses parts of his tutorial, with a different focus. His focus
is Seaside and how to deploy it on Gemstone. This tutorial will only
cover QCMagritte.

The second framework that is used is Magritte. As this framework has
less documentation, we will cover the concepts of Magritte in this
tutorial as well.

## Examples

QCMagritte is shipped with a few examples. Go to
http://localhost:8080/qcmagritte. Here you can see all demo's that are
installed together with QCMagritte. These demo's gives an impression of
some of the things we will come across.

## Details

This tutorial should teach you the most important features of
QCMagritte. As you can see, you can go to details. Press details to see
the details of this item.

Some things will be shown in the details that do not show in the
overview. By default the explanation is only visible in the details. If
you have used the **start** button to start this chapter, you will have
skipped the overview of the chapter **Exploring QCMagritte**. You can open
the overview of the chapter by clicking on the list icon in the
homepage. Open the overview of the chapter, as the next item concerns
the overview.

## Overview

Since the overview is for most applications the first entry point, this
is an important screen for the user. This overview can be changed by the
user. Why don't you try to add the explanation to the overview, you just
saw in the details. If you need a hint, go to the details to see the
explanation

For adding an extra column you should go to the report options ... and
click on choose columns. Here you can drag the columns to be
(in)visible.

## Menu

The menu shows all pages. When you open the details, it adds a "subpage"
as a child of the current page.

The menu is rendered as an ordered list by the `QCTreePageChoice` and
subclasses. The new child is added with an announcement (`QCShowDetails`).
In the `QCApplication` this announcement is handled and here the new page
is added. Opening the same object twice will select that object and not
open the same object again.

You can test how the menu behaves when you open multiple chapters and/or
tutorials at the same time.

## Application

This tutorial is written as a QCMagritte application. We will discuss
some of the things we have done in this application.

First note that the package **QC-Magritte-Tutorial** has 3 "subpackages":
**component**, **model** and **web**.

In **web** we have all classes that are responsible for showing the website.
As we use the bootstrap template here, we only need an application
`QCTutorialApplication` and we have a bit of custom layout done in the
library `QCTutorialLibrary`.

Notice that on the instance side we have only implemented 2 methods: the
`model` and the `title`. Both methods are overrides as indicated with the
green arrow. The title is shown in the top left corner, the model is
linked to the tutorial itself.

When you press the button **class side** in your class browser, you can
see there are 4 methods overridden on the class side. The
`applicationName` determines where this application is installed, the
`description` is shown in title of the browser window, the `initialize`
makes sure this application gets installed on load and finally, the
`registerDevelopmentAt:` adds our custom "tutorial" library.

## Model

The main model of the tutorial application is the `QCTutorialModel`. It
has a lot of methods, because all texts are included in this class.

We will limit our explanation to the **magritte-descriptions** in the class.
Please note that the `QCTutorialModel` has one **magritte-description**: the
description that points to the chapters.

```smalltalk
descriptionChapters
    <magritteDescription>
    ^MAToManyRelationDescription new
        label: 'Chapters';
        accessor: #chapters;
        priority: 100;
        sorted: true;
        classes: { QCChapter };
        yourself
```

It defines that we have a number of "chapters" of type `QCChapter` in
our model.

## Chapter

When you look at the **magritte-description** of the class `QCChapter` it
has a number of tutorials. When you look at the website, a chapter also
has a title and a description.

A magritte description is build up, using the hierarchy of the object.
As a chapter is a tutorial item, the **magritte-descriptions** of the
tuturial items are also processed. Here you can find the descriptions of
the title, description and priority.

The description of the priority is a bit of an odd one, as this one is
not visible. You should be able to make it visible, using the report
options in the overview of the chapters. Here you can also see that
there are more description in the hierarchy of a `QCChapter`.

## Tutorial

The tutorial also has a special description: explanation. Explanation is
of a special type, to allow for different layout. We have added a custom
component to render an explanation.
