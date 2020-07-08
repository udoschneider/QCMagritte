# User management

Now that we have a todolist with projects, the next logical step would
be adding users and allowing users to manage their own things. So in
this chapter we will add users, a login, a team to the project, and
basic security. This chapter is work in progress

## Users

First we are going to define our own users. Just try and add a user role
and a user to the system. You will notice that there are still some
things to be configured.

First of all we need to define that classes that have rights in our
system. By default you can set rights to the user overview.

QCUser subclass: \#TodoUser
instanceVariableNames: ''
classVariableNames: ''
category: 'Tutorial-Model'

We also customize the user role.

QCModifyableUserRole subclass: \#TodoUserRole
instanceVariableNames: ''
classVariableNames: ''
category: 'Tutorial-Model'

Now we can create a customized user overview. We have 2 overrides in the
class:

userClasses
^{ TodoUser }

userRoles
^{ TodoUserRole }

As we create our users and roles using QC Magritte, the useroverview has
a magritte description for both. We specify here the classes that can be
expected and created by the user. We now add the user overview to the
model. We add an instance variable for this with accessors and the
following magritte description:

descriptionUserOverview
\<magritteDescription\>
^MAToOneRelationDescription new
label: 'Users';
accessor: \#userOverview;
priority: 50;
classes: { TodoUserOverview };
beRequired;
yourself

Go back to your application and see how it looks. Did you remember to
add the initialization code for the userOverview?

Remeber that this is the barre minimum for user management. You probably
want to have a user name for the users as well. Extend the user with a
first name and a sur name. Now override the method "username" to display
the first name. This method is determine what name is displayed when you
are logged in.

## Rights

Having defined users is only the first step. Just try and add a user
role and a user to the system. You will notice that there are still some
things to be configured.

First of all we need to define that classes that have rights in our
system. By default all classes marked with "hasUserRights" will appear
in the list. We probably want to narrow this list further. For this we
override the "allModelClasses"

allModelClasses
^(RPackage organizer packageNamed: 'Tutorial-Model') classes

In smalltalk we can inspect all classes in the system. They are
organized in "packages". In order to create a list of all classes we
have modelled, we can limit ourself to the pacakge "Tutorial-Model". Go
back to the site and check what rights we can add to a role now.

As you can see, not all classes are shown. Only the classes with the
flag "hasUserRights" will show up. We will add the TodoProjects and
TodoItems to the list, by adding the following method to the class side
of these classes

hasUserRights
^true

Now go back to the site and check again. Now it is time to put security
in place. Set the following method in your application model:

users
^self userOverview users

As you can see, we only link our users to the users in our user
overview. If we have added an admin user, we will have user management.
Now see how it looks like. If you did not add an admin user, do so now.
And then reset the session.

## Security

Having an admin will start the user management. Having user management
means you can login. This was added to the header of the page. Also not
everything is visible any more. We cannot add users or projects.

User management works as follows: an admin can see all things and modify
them. A guest with no login can see all objects that have no security
set. Since we set security to the projects and not to the todo items,
people will be able to add todo items.

Notice that the project is removed properly. A todo item may have a
project, but this project is not visible in the overview. Also opening
the details, the project will not show up. Guests will not be able to
modify the project of the todo item, because he is not allowed to read
projects.

Now we are going to create a Reader, someone who is allowed to see
projects but nothing more. Login with your admin user, and create a role
with the title "Reader". Add the right "R" (read) for the modelclass
"TodoProject" to this role. Now create a user ("reader") with only the
role "Reader" and login with the new user. Here you can see that this
user is allowed to see projects, and can change the project in the todo
items. But he cannot add projects or change projects. Notice that he can
still add todo items to a project, by assigning a todo item to a certain
project.

Now we are going to create a Project managemer. He is allowed to create,
change and update projects. Updating only concerns the title. Login as
admin again, and create a role "manager" with the rights "C" (create),
"R" (read) and "U" (update) for the modelclass "TodoProject". Also give
him the right "R" on TodoUser. Do not give him the right "D" (destroy).
Also create a user with this role and see that he can add projects. He
will not be able to see users, as this is in the menu "UserOverview" and
he does not have rights on this.

We finally want to add a "useradmin", that is allowed to create users,
reset passwords and assign roles. Note that for this we have to add 3
rights. For the useroverview (R), for the users (CRU) and for the roles
(R). Now try and add a user with both the role useradmin and reader. See
that this person can read projects and add users.

## Team

You can see that QC Magritte has the "normal" user management system
using CRUD rights available. Now we are going to make things more
complex, by creating a team to a project. This team should of course be
able to see everything on his/her project, but not on other projects.

Note: there is a problem here in the bootstrap template ... work in
progress

First we are going to add a description for the team members in the
project. Since the team members are actually the normal users, we are
going to use the following description:

descriptionTeamMembers
\<magritteDescription\>
^QCToManyOptionRelationDescription new
label: 'Team';
accessor: \#teamMembers;
priority: 350;
classes: { TodoUser };
options: \[ self allProjectUsers \];
yourself

And since we only want the "normal" users to be part of the project we
use this as the accessor:

allProjectUsers
^self model users select: \[ :each | each isAdminUser not \]

Now go back to the browser and check how it works out. Notice that the
manager can now select users and add them to his team and remove them
again. He cannot see the roles of these users, as he does not have any
rights on the roles. He can change the details of the user (not the
userid) and if he adds himself, he can change his own password here.

## Custom security

We want team members to be able to modify their project

## Json

We want to export json.

## Save and quit

Remember to save your packages in monticello and save and quit your
image.

