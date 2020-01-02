# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app. I used the Sinatra gem to implement this project.
- [x] Use ActiveRecord for storing information in a database. I used the ActiveRecord gem for storing the databases for this project.
- [x] Include more than one model class (e.g. User, Post, Category). I have 2 model classes, the user and item model classes.
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts). I have 1 has_many relationship, User has_many Items.
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User). I have 1 belongs_to relationship, Item belongs_to User.
- [x] Include user accounts with unique login attribute (username or email). The account uses the username as a unique login attribute.
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying. The Item model can be created, shown, edited, and deleted.
- [x] Ensure that users can't modify content created by other users. Created a test to confirm that users can not modify items created by other users.
- [x] Include user input validations. Does not allow a user to create or edit an item with a blank field.
- [ ] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code. See README.md

Confirm
- [x] You have a large number of small Git commits. Over 50 commits.
- [x] Your commit messages are meaningful. Created meaningful commit messages each time.
- [x] You made the changes in a commit that relate to the commit message. Only changed code related to the commit message.
- [x] You don't include changes in a commit that aren't related to the commit message. Only changed code related to the commit message.
