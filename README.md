# PaperTrailManager

[![CI](https://github.com/DamageLabs/paper_trail_manager/actions/workflows/test.yml/badge.svg)](https://github.com/DamageLabs/paper_trail_manager/actions/workflows/test.yml)

Browse, view, and revert changes to records in Ruby on Rails applications using the [paper_trail](https://github.com/paper-trail-gem/paper_trail) gem.

## Requirements

- **Ruby** >= 3.1
- **Rails** >= 6.1, < 8.0
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

## Configuration

Create an initializer (e.g. `config/initializers/paper_trail_manager.rb`) to customize behavior.

### Authorization

Control when reverts are allowed:

```ruby
PaperTrailManager.allow_revert_when do |controller, version|
  controller.current_user&.admin?
end
```

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
| 6.1   | 12.0      | kaminari, will_paginate |
| 7.0   | 12.0      | kaminari, will_paginate |
| 7.0   | 15.0      | kaminari, will_paginate |
| 7.1   | 15.0      | kaminari, will_paginate |

CI runs each combination across Ruby 3.1, 3.2, and 3.3.

### Adding Support for New Versions

1. Update the `Appraisals` file with new version combinations
2. Run `appraisal generate && appraisal install`
3. Fix any breaking changes
4. Submit a pull request

## License

MIT — see [LICENSE.txt](LICENSE.txt) for details.

## History

This project was originally developed by [Igal Koshevoy](https://github.com/igal). Igal passed away on April 9th, 2013, and [Tony Guntharp](https://github.com/fusion94) took over maintenance of the project.
