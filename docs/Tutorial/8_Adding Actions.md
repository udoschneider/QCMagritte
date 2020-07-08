# Adding Actions

Magritte describes mostly entities and their fields. The actions
theseentities can perform can be described in a similar way (the
behavior of objects

## Actions for the whole entity

In this chapter we will go into some more details of the descriptions,
and some of the properties.

An action that is relevant for the whole entity, can be added as a
container action.

A tutorial chapter can switch to its first page

containerActions: aContainer
\<magritteContainer\>
^aContainer
addCommand: 'Start' condition: \[ :row | row canStart \] action: \[ :row
| row start \];
yourself

## Actions for a field

An action that is relevant for one field only, can be added by setting
commands: in the description.

The command works in the context of the description, so to work on the
domain object use a block.

