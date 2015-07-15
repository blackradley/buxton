# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'
if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
gem 'rails', "3.2.21"
gem 'haml'
gem "mysql2"
gem "jquery-rails"
# gem 'jquery-colorbox-rails'

#gem 'rmagick', :require => 'RMagick'
gem 'pdf-writer', git: "https://github.com/Hermanverschooten/pdf-writer.git"
gem 'newrelic_rpm'
# gem "devise", "= 1.5.2"
gem 'formtastic', "< 1.9.0"
gem 'airbrake'
gem 'rails3-jquery-autocomplete'
gem 'devise_security_extension'
gem 'right_aws'
gem 'rack-ssl', :require => 'rack/ssl'
gem 'whenever'
gem 'will_paginate', "~> 3.0.pre2"
gem 'sass'
gem 'rake'
gem 'acts_as_list'


group :assets, :development do
  gem 'sprockets'
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier',     '>= 1.0.3'
end

group :test do
  gem 'test-unit'
  gem 'factory_girl', "1.3.3"
  gem 'shoulda'
  gem 'mocha'
  gem "test_after_commit"
end

group :development do
  # gem "rcov_rails"
  gem 'mail_safe'
  gem 'rvm-capistrano'
  gem 'db_fixtures_dump'
end
