# Bootstrap3FormBuilder

*Supports Bootstrap 3* 

This gem adds a helper to all of your views called `bootstrap_form_for`, which generates a form for a given model object
and fields with HTML and CSS markup that works with the [Twitter bootstrap](http://getbootstrap.com/)  
library.

## Install
Add to your gemfile:

```ruby
gem "bootstrap3_form_builder"
```

After bundling the gem run 

```console
rails g bootstrap3_form_builder:install
```

This will create a partial called error_messages that will contain formatted errors on the object the form is for. This
generator also takes an option to use HAML (it uses erb by default):

```console
rails g bootstrap3_form_builder:install -t haml
```

## Usage

Lets say you have a Person model:

```ruby
class Person < ActiveRecord::Base
	validates :shirt_size, inclusion: { in: %w(small medium large) }
	validates :name, length: { minimum: 2 }, presence: true
	validates :bio, length: { maximum: 500 }
	validates :password, length: { in: 6..20 }
	validates :registration_number, length: { is: 6 }
	validates :points, numericality: true
	validates :games_played, numericality: { only_integer: true }
	validates :legacy_code, format: { with: /\A[a-zA-Z]+\z/ }
end
```

You can use the `bootstrap_form_for` helper method like so:

```ruby
<%= bootstrap_form_for(@user) do |f| %>
  <%= f.text_field :name %>
  <%= f.password_field :password %>
  <%= f.text_field :shirt_size %>
  <%= f.text_field :bio %>
  <%= f.text_field :registration_number %>
  <%= f.number_field :points %>
  <%= f.number_field :games_played %>
  <%= f.text_field :legacy_code %>

  <%= f.submit "Submit" %>
<% end %>
```

This will generate HTML like this:

```html
<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline">
	<input name="utf8" type="hidden" value="✓">
	<input name="authenticity_token" type="hidden" value="tqtYKs7inP4AvZdQKYYCcTbEvvAgJ/VLy4hmj2BclMo="></div>
  <div class="form-group">
  	<label class="" for="user_name">Name</label>
  	<input class="form-control" id="user_name" name="user[name]" pattern=".{2,}" required="required" title="Name - 2 characters minimum" type="text">
  </div>
  <div class="form-group">
  	<label class="" for="user_password">Password</label>
  	<input class="form-control" id="user_password" name="user[password]" pattern=".{6,20}" title="Password - 6 to 20 characters" type="password">
  </div>
  <div class="form-group">
  	<label class="" for="user_shirt_size">Shirt size</label>
  	<input class="form-control" id="user_shirt_size" name="user[shirt_size]" pattern="(small|medium|large)" title="Shirt size - Must be one of the following: small, medium, large" type="text">
  </div>
  <div class="form-group">
  	<label class="" for="user_bio">Bio</label>
  	<input class="form-control" id="user_bio" name="user[bio]" pattern=".{0,500}" title="Bio - 500 characters maximum" type="text">
  </div>
  <div class="form-group">
  	<label class="" for="user_registration_number">Registration number</label>
  	<input class="form-control" id="user_registration_number" name="user[registration_number]" pattern=".{6,6}" title="Registration number - Must be exactly 6 characters" type="text">
  </div>
  <div class="form-group">
  	<label class="" for="user_points">Points</label>
  	<input class="form-control" id="user_points" name="user[points]" pattern="\d*" step="any" title="Points" type="number">
  </div>
  <div class="form-group">
  	<label class="" for="user_games_played">Games played</label>
  	<input class="form-control" id="user_games_played" name="user[games_played]" pattern="\d*" step="1" title="Games played" type="number">
  </div>
  <div class="form-group">
  	<label class="" for="user_legacy_code">Legacy code</label>
  	<input class="form-control" id="user_legacy_code" name="user[legacy_code]" pattern="\A[a-zA-Z]+\z" title="Legacy code is not a valid format" type="text">
  </div>

  <input class="btn btn-default" name="commit" type="submit" value="Submit">
</form>
```

It automatically groups your inputs, creates labels, gives a button class to your submit button, and applies the given validations using the HTML pattern and required attributes.

It also adds some options to all of the form helpers (`form.text_field`, `form.text_area`, etc)

* :label - Lets you define a custom label
* :label_class - Lets you define a custom class for your clabel
* :help_block - A block of text that should appear below your input
* :help_inline - A line of text that should appear next to your input
* :input_class - By Default this is 'form-control'
* :input_container_class - Nothing by default. If specified, will wrap your input with a div with the given class
* :input_prefix - Adds a div containing the given text, with class input-group-addon, before the input
* :input_suffix - Adds a div containing the given text, with class input-group-addon, after the input

For example:

```ruby
<%= form.text_field :name, :label => "Nickname", :label_class => "important", 
:help_block => "What do your friends call you?", :input_container_class => "col-sm-10", 
:input_prefix => "Mrs.", :input_suffix => "The Greatest" %>
```

Would create:

```html
<div class="form-group">
	<label class="important" for="user_name">Nickname</label>
	<div class="input-group col-sm-10">
		<div class="input-group-addon">Mrs.</div>
		<input class="form-control" help_block="What do your friends call you?" id="user_name" input_container_class="col-sm-10" input_prefix="Mrs." input_suffix="The Greatest" label="Nickname" label_class="important" name="user[name]" pattern=".{2,}" required="required" title="Nickname - 2 characters minimum" type="text">
		<div class="input-group-addon">The Greatest</div>
	</div>
	<p class="help-block">What do your friends call you?</p>
</div>
```

##Configuration

When you run the install generator it will create an initializer at 

```console
config/initializers/bootstrap3_form_builder.rb
```

Here you can customize certain aspects of the form builder. Check the generated file for the most up to date documentation
and example options.



This project uses MIT-LICENSE.