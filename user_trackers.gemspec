Gem::Specification.new do |s|
  s.name        = 'user_trackers'
  s.version     = '0.0.41'
  s.date        = '2019-11-20'
  s.summary     = "Gem for tracking user's activity on a rails app using mixpanel, intercom, slack and database"
  s.description = "Gem for tracking user's activity on a rails app using mixpanel, intercom, slack and database"
  s.authors     = ["Camilo Barraza"]
  s.email       = 'cbarraza11@gmail.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.metadata    = { "source_code_uri" => "https://github.com/flatironsdevelopment/user_trackers" }
  s.license       = 'MIT'
  s.required_ruby_version = ">= 2.4.0"
  
  s.add_dependency  "sidekiq", ">= 5.0.0"
  s.add_dependency  "resque", ">= 2.0.0"
  s.add_dependency 'mixpanel-ruby', ">= 2.0.0"
  s.add_dependency 'intercom', ">= 3.0.0"
  s.add_dependency 'slack-ruby-client', "~> 0.14.0"
  s.add_dependency 'uuid', ">= 2.0.0"
  s.add_development_dependency "rake", ">= 10.0"
  s.add_development_dependency "rspec", ">= 3.9.0"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "rails", '~> 5.2.1'
end