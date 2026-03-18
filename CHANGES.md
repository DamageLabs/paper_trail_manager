Changes to `paper_trail_manager`
================================

* 0.8.0
    * Fix `allow_show?` calling `allow_index_block` instead of `allow_show_block` — `allow_show_when` configuration was previously silently ignored (security fix)
    * Fix gemspec `authors` field being overwritten by misplaced `email` assignment
    * Fix `PER_PAGE` constant (50) not being used as default pagination
    * Fix broken HTML structure in show view (nested `<tr>` tags) and index view (unwrapped `<td>`)
    * Add date range filtering to changes index via `from` and `to` query parameters
    * Add date filter UI with date inputs, filter button, and clear link
    * Add authorization integration tests (unauthorized index/show/revert, non-existent records)
    * Add unit tests for ChangesHelper methods (text_or_nil, changes_for, change_item_types, version_reify)
    * Add specs for JSON and Atom response formats with filter coverage
    * Add date range filter tests
    * Drop support for Rails < 7.0
    * Drop Rails 6.1 from CI matrix (incompatible with Ruby 3.1+)
    * Fix `rails new` asset pipeline error in CI for Rails 7.0/7.1
    * Fix `Psych::DisallowedClass` error on revert tests (Ruby 3.1+ YAML deserialization)
    * Add support for Ruby 3.1, 3.2, and 3.3
    * Add support for PaperTrail 12.x and 15.x

* 0.7.0
    * Add support for Rails 5 and 6
    * Add support for paper_trail 5.x – 10.x
    * Drop support for Rails < 4.1
    * Drop support for Ruby < 2.5

* 0.6.0
    * Add support for linking changes to user records via `PaperTrailManager.whodunnit_name_method` and `PaperTrailManager.user_path_method`
    * Add new `PaperTrailManager.item_name_method` configuration option
    * Add support for paper_trail 4.x
    * Refactoring, code simplification, and performance improvements

* 0.5.0
    * Add support for pagination with [Kaminari](https://github.com/amatsuda/kaminari) in addition to [will_paginate](https://github.com/mislav/will_paginate).
    * **[!]** Removed direct dependency on will_paginate. You must now include either `will_paginate` or `kaminari` in your Gemfile.
    * Fix a bug with route generation when paper_trail_manager is used within another Rails engine.

* 0.4.0
    * Allow configuration of ChangesController's parent class, route helpers, and layout

* 0.3.0
    * Support Rails 3.2, 4.0, 4.1, and 4.2
    * Drop support for Rails 3.0 and 3.1
    * Improve test suite across multiple Rails versions

* 0.2.0
    * Add support for Rails 3.1 and 3.2, while retaining support for Rails 3.0.
    * Add test suite to check engine against multiple versions. This test suite is derived from Mike Dalessio's "loofah-activerecord" gem, available at https://github.com/flavorjones/loofah-activerecord

* 0.1.6
    * Fix `Gemfile.lock` issue with 0.1.5.

* 0.1.5
    * Fix exceptions typically caused by bots submitting invalid pagination parameters. Now all pagination parameters are sanitized.
    * Restrict use to Rails 3.0.x because newer versions are not compatible. Will try to add support for newer Rails releases later.
    * Update test/development dependencies.
    * Add travis-ci support.

* 0.1.4
    * Fix `changes_row` CSS, was `#{EVENT},` with a trailing comma. Kept it for backwards compatibility, and added `#{EVENT}` and `change_event_#{EVENT}` classes.
    * Add sample CSS stylesheet: `spec/dummy/public/stylesheets/changes.css`.


* 0.1.3
    * Fix deprecation warnings for Rails Engines paths. [Nate Bird]
    * Add homepage to included demo application that provides links and usage instructions.

* 0.1.2
    * Switch template format from `haml` to `erb` to eliminate extra dependencies and improve compatibility. [Reid Beels]

* 0.1.1
    * Fix `rake spec` to work with `factory_girl` 2.0.x gem.

* 0.1.0
    * Fix database database query to be more SQL compatible. [Linus Graybill]
    * Fix Gemfile to reduce run-time dependencies and relax their version requirements.

* 0.0.0
    * Initial release.
