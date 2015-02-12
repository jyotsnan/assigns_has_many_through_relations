# AssignsHasManyThroughRelations

Rails Engine that provides a management UI to assign models to each other in the case where they are associated in a `has_many` `:through` style relationship. 

For example, given a pair of models `Location` and `User`, we will consider `Location` to be the left side relation and `User` to be the right side relation. This UI provides a 3 column Bootstrap view where the left most column displays all `Location`s where the user can select one from the list. The 2 other columns are the Assigned and Unnassigned columns, respectively. These display `User`s that either have a join model with the selected `Location` or not, respectively. The user can then select `User`s from the Unnassigned column and the form PUT will create the join models necessary to move the Unnassigned `User`s to the middle Assigned column, effectively association the selected `User`s from the right most column to the selected `Location`.

## Example UI
![assigns_has_many_through_relations_screenshot](https://cloud.githubusercontent.com/assets/89930/6175967/0d86cf9e-b2c9-11e4-85d8-79c58d8570d6.png)

In the above example, clicking on "Assign Selected" will move the selected `User`s to the middle column by creating the `locations_user` join model between them and the selected `Location` "Home".

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'assigns_has_many_through_relations'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install assigns_has_many_through_relations

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

## Todo

1. Write specs.
2. Clean up css classes and ids in the partial.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/assigns_has_many_through_relations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
