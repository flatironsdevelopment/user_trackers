Gem::Specification.new do |s|
  s.name        = 'user_trackers'
  s.version     = '0.0.11'
  s.date        = '2019-11-20'
  s.summary     = "Gem for tracking user's activity on a rails app using mixpanel, intercom, slack and database"
  s.description = "Gem for tracking user's activity on a rails app using mixpanel, intercom, slack and database"
  s.authors     = ["Camilo Barraza"]
  s.email       = 'cbarraza11@gmail.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.metadata    = { "source_code_uri" => "https://github.com/camilo-barraza/user_trackers" }
  s.license       = 'MIT'
  s.required_ruby_version = ">= 2.4.0"
  
  s.add_dependency  "sidekiq"
  s.add_dependency  "resque"
  s.add_dependency 'mixpanel-ruby'
  s.add_dependency 'intercom'
  s.add_dependency 'slack-ruby-client'
  s.add_dependency 'uuid'
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rspec"
end