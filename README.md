# AssignsHasManyThroughRelations

Rails Engine that provides a management UI to assign models to each other in the case where they are associated in a `has_many` `:through` style relationship. 

For example, given a pair of models `Location` and `User`, we will consider `Location` to be the left side relation and `User` to be the right side relation. This UI provides a 3 column Bootstrap view where the left most column displays all `Location`s where the user can select one from the list. The 2 other columns are the Assigned and Unnassigned columns. These display `User`s that either have a join model with the selected `Location` or not, respectively. The user can then select `User`s from the Unnassigned column and the form PUT will create the join models necessary to move the Unnassigned `User`s to the middle Assigned column, effectively associating the selected `User`s from the right most column to the selected `Location`.

## What You Get
![assigns_has_many_through_relations_screenshot](https://cloud.githubusercontent.com/assets/89930/6175967/0d86cf9e-b2c9-11e4-85d8-79c58d8570d6.png)

In the above example, clicking on "Assign Selected" will move the selected `User`s to the middle column by creating the `locations_user` join model between them and the selected `Location` "Home". 

You'll notice there's a Filter text input, this will filter the corresponding list as you type. Hitting ESC will clear the text field.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'assigns_has_many_through_relations'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install assigns_has_many_through_relations

## Dependencies

1. [Twitter Bootstrap](http://getbootstrap.com) (if you want the UI to be pre-styled).
2. [jQuery](http://jquery.com/download) (for the list Filter).

## Usage

Declare the routes:

```ruby
YourApp::Application.routes.draw do
  AssignsHasManyThroughRelations.routes_for :locations, :users, self
end
```

Declare the plugin and options in your models:

```ruby
class Location < ActiveRecord::Base
  extend AssignsHasManyThroughRelations::ModelConcern
  assigns_has_many_relationships_with :location, :user
end

class User < ActiveRecord::Base
  has_many :locations_users, dependent: :delete_all
  has_many :locations, through: :locations_users
end
```

And a controller to handle the requests:

```ruby
class LocationsUsersController < ApplicationController
  extend AssignsHasManyThroughRelations::ControllerConcern
  assigns_has_many_relationships_with :location, :user
end
```

Finally, render the management UI partial in a view template in `app/views/locations_users/index.html.erb`:

```html
<div id="locations_users">
  <h1>Assign Users To Location</h1>

  <%= render '/assigns_has_many_through_relations' %>
</div>
```

You'll have to provide the user with a link to `locations_users_path`. And that's it. Now you'll be able to assign and unassign `User`s to `Location`s.

**Note:** _currently the left side model has to respond_to `name` for a nice display name, and the right side model has to respond to `full_name`. This will be configurable soon._

## Configuration

You can configure the engine in an initializer. The given examples are the defaults except for `auth_filter` that won't run if you don't set it.

```ruby
# config/initializers/assigns_has_many_through_relations.rb

AHMTR.configure do
  # A controller authorization method to call as you would a controller macro.
  #
  # e.g like Cancan's authorize_resource (https://github.com/CanCanCommunity/cancancan/wiki/Authorizing-Controller-Actions)
  auth_filter :authorize_resource

  # The scope that loads the left side models.
  #
  # e.g. in the case where you declare assigns_has_many_relationships_with :location, :user
  # then this scope would essentially load:
  #   Location.users
  left_relation_scope do |left_relation_class, current_user|
    left_relation_class.all
  end

  # The scope that loads the selected left side model's right relations.
  #
  # e.g. in the case where you declare assigns_has_many_relationships_with :location, :user
  # then this scope would essentially load:
  #   @location.users
  selected_right_relation_scope do |left_side_model, right_relation_class, current_user|
    left_side_model.users
  end

  # The scope that loads all the non selected left side model's reight relations.
  #
  # e.g. in the case where you declare assigns_has_many_relationships_with :location, :user
  # then this scope would essentially load:
  #   User.all - @location.users
  available_right_relation_scope do |right_relation_class, right_models, current_user|
    right_relation_class.all - right_models
  end
end
```

## Todo

1. Write specs.
2. Configurable model name method.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/assigns_has_many_through_relations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
