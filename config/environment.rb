# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
FirstApp::Application.initialize!

# I18n for will_paginate Gem
WillPaginate::ViewHelpers.pagination_options[:previous_label] = I18n.t("menu.pagination_previous")
WillPaginate::ViewHelpers.pagination_options[:next_label]     = I18n.t("menu.pagination_next")