# PaperTrailManager

[![CI](https://github.com/DamageLabs/paper_trail_manager/actions/workflows/test.yml/badge.svg)](https://github.com/DamageLabs/paper_trail_manager/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/paper_trail_manager.svg)](https://rubygems.org/gems/paper_trail_manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ruby](https://img.shields.io/badge/Ruby-3.1%2B-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-7.0%2B-red.svg)](https://rubyonrails.org/)

Browse, view, and revert changes to records in Ruby on Rails applications using the [paper_trail](https://github.com/paper-trail-gem/paper_trail) gem.

## Requirements

- **Ruby** >= 3.1
- **Rails** >= 7.0, < 8.0
- **PaperTrail** >= 12.0
- A pagination library: [will_paginate](https://github.com/mislav/will_paginate) or [Kaminari](https://github.com/kaminari/kaminari)

## Installation

Add to your `Gemfile`:

```ruby
gem 'paper_trail_manager'
```

If you don't already use a pagination library, add one:

```ruby
gem 'kaminari'
# or
gem 'will_paginate'
```

Install:

```sh
bundle install
```

Add the route to `config/routes.rb`:

```ruby
resources :changes, controller: 'paper_trail_manager/changes'
```

Restart your server and visit `/changes` to browse, view, and revert your changes.

### Stylesheet (optional)

A default stylesheet is included. Add to your layout or application CSS:

```erb
<%= stylesheet_link_tag 'paper_trail_manager/changes' %>
```

Or require it in `app/assets/stylesheets/application.css`:

```css
/*= require paper_trail_manager/changes */
```

The styles are low-specificity and easy to override in your own stylesheet.

## Configuration

Create an initializer (e.g. `config/initializers/paper_trail_manager.rb`) to customize behavior.

### Authorization

Control access to the index, show, and revert actions independently:

```ruby
# Control who can view the changes index
PaperTrailManager.allow_index_when do |controller|
  controller.current_user.present?
end

# Control who can view individual change details (defaults to allow_index rules)
PaperTrailManager.allow_show_when do |controller, version|
  controller.current_user&.admin? || version.whodunnit == controller.current_user&.id&.to_s
end

# Control who can revert changes
PaperTrailManager.allow_revert_when do |controller, version|
  controller.current_user&.admin?
end
```

> **Note:** If you only call `allow_index_when`, the same block is used as the default for `allow_show_when`. Call `allow_show_when` separately to override show authorization independently.

### Whodunnit

Configure how to look up users referenced in PaperTrail's `whodunnit` column:

```ruby
PaperTrailManager.whodunnit_class = User
PaperTrailManager.whodunnit_name_method = :nicename  # defaults to :name
```

### Item Names

Specify a method to identify items on the index page:

```ruby
PaperTrailManager.item_name_method = :nicename
```

### User Links

Customize (or disable) the user path helper:

```ruby
PaperTrailManager.user_path_method = :admin_path  # defaults to :user_path
PaperTrailManager.user_path_method = nil           # no user link
```

### Pagination

The index page defaults to 50 items per page. Override via query parameter:

```
/changes?per_page=25
```

### Engine Integration

When embedding PaperTrailManager inside another Rails engine:

```ruby
PaperTrailManager.base_controller = "MyEngine::ApplicationController"
PaperTrailManager.route_helpers = MyEngine::Engine.routes.url_helpers
PaperTrailManager.layout = 'my_engine/application'
```

## Development

Setup:

```sh
git clone https://github.com/DamageLabs/paper_trail_manager.git
cd paper_trail_manager
bundle install
```

Running tests:

```sh
appraisal rake
```

The first run downloads gems for each Rails version in the test matrix, which may take a while.

### Test Matrix

Tests run against multiple combinations via [Appraisal](https://github.com/thoughtbot/appraisal):

| Rails | PaperTrail | Pagination |
|-------|-----------|------------|
| 7.0   | 12.0      | kaminari, will_paginate |
| 7.0   | 15.0      | kaminari, will_paginate |
| 7.1   | 15.0      | kaminari, will_paginate |

CI runs each combination across Ruby 3.1, 3.2, and 3.3 (18 jobs total).

### Adding Support for New Versions

1. Update the `Appraisals` file with new version combinations
2. Run `appraisal generate && appraisal install`
3. Fix any breaking changes
4. Submit a pull request

## Recent Changes (0.8.0)

- **Security fix:** `allow_show?` now correctly delegates to `allow_show_block` (was incorrectly using `allow_index_block`)
- **Bug fix:** Gemspec `authors` field was being overwritten by `email`
- **Bug fix:** `PER_PAGE` constant (50) now used as pagination default
- **CI:** Dropped Rails 6.1 (incompatible with Ruby 3.1+), fixed Psych deserialization, added asset pipeline skip
- **Tests:** Added unit tests for authorization block delegation
- Modernized for Ruby 3.1–3.3 and Rails 7.0–7.1

See [CHANGELOG.md](CHANGELOG.md) for full history.

## License

MIT — see [LICENSE.txt](LICENSE.txt) for details.

## History

This project was originally developed by [Igal Koshevoy](https://github.com/igal). Igal passed away on April 9th, 2013, and [Tony Guntharp](https://github.com/fusion94) took over maintenance of the project.
