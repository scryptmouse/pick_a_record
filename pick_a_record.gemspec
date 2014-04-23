$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pick_a_record/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pick_a_record"
  s.version     = PickARecord::VERSION
  s.authors     = ["Alexa Grey"]
  s.email       = ["devel@mouse.vc"]
  s.homepage    = "https://github.com/scryptmouse/pick_a_record"
  s.summary     = "Pick a random record and cache the result for display."
  s.description = "Pick a random record and cache the result for display."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'calculi', '~> 0.0.1'
  s.add_dependency 'rails', '>= 3.2.13'
  s.add_dependency 'redis-objects', '>= 0.8.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'timecop'
end
