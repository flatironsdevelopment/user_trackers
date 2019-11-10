Gem::Specification.new do |s|
  s.name        = 'user_trackers'
  s.version     = '0.0.1'
  s.date        = '2010-04-28'
  s.summary     = "user trackers gem"
  s.description = "user trackers gem"
  s.authors     = ["Camilo Barraza"]
  s.email       = 'cbarraza11@gmail.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.homepage    =
    'https://rubygems.org/gems/user_trackers'
  s.license       = 'MIT'
  s.add_dependency  "sidekiq"
  s.add_dependency 'mixpanel-ruby'
  s.add_dependency 'intercom'
  s.add_dependency 'slack-ruby-client'
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
end