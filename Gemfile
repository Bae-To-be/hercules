# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.0.0'

# Added by rails
gem 'importmap-rails', '>= 0.3.4'
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.0.alpha2'
gem 'stimulus-rails', '>= 0.4.0'
gem 'turbo-rails', '>= 0.7.11'
# gem "redis", "~> 4.0"
gem 'bootsnap', '>= 1.4.4', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
# Use Sass to process CSS
gem 'sassc-rails', '~> 2.1'
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_optim'
gem 'image_optim_pack'
gem 'image_processing', '~> 1.2'

# custom
gem 'array_enum'
gem 'aws-sdk-s3', require: false
gem 'jwt'
gem 'koala'
gem 'oj'
gem 'rails_admin', '2.0'
gem 'skylight'

group :development, :test do
  # Start debugger with binding.b [https://github.com/ruby/debug]
  gem 'debug', '>= 1.0.0', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console', '>= 4.1.0'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler", ">= 2.3.3"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'spring'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara', '>= 3.26'
  gem 'factory_bot'
  gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  gem 'vcr'
  gem 'webdrivers'
  gem 'webmock'
end
