# frozen_string_literal: true

# PaperTrailManager configuration
# See: https://github.com/DamageLabs/paper_trail_manager

# Control who can view the changes index.
# PaperTrailManager.allow_index_when do |controller|
#   controller.current_user.present?
# end

# Control who can view individual change details.
# Defaults to the allow_index rules if not set separately.
# PaperTrailManager.allow_show_when do |controller, version|
#   controller.current_user.present?
# end

# Control who can revert changes.
# PaperTrailManager.allow_revert_when do |controller, version|
#   controller.current_user&.admin?
# end

# Configure how to look up users referenced in PaperTrail's whodunnit column.
# PaperTrailManager.whodunnit_class = User
# PaperTrailManager.whodunnit_name_method = :name

# Specify a method to identify items on the index page.
# PaperTrailManager.item_name_method = :name

# Customize the user path helper (set to nil to disable user links).
# PaperTrailManager.user_path_method = :user_path

# When embedding inside another Rails engine:
# PaperTrailManager.base_controller = 'MyEngine::ApplicationController'
# PaperTrailManager.route_helpers = MyEngine::Engine.routes.url_helpers
# PaperTrailManager.layout = 'my_engine/application'
