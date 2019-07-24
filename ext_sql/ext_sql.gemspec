$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "./../version"
version = MrBackend::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ext_sql"
  s.version     = version
  s.authors     = ["Patrice Lebel"]
  s.email       = ["patleb@users.noreply.github.com"]
  s.homepage    = "https://github.com/patleb/ext_sql"
  s.summary     = "ExtSql"
  s.description = "ExtSql"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency 'activesupport'
  s.add_dependency 'activerecord'
  s.add_dependency 'sql_query'
  s.add_dependency 'ext_rake', version

  s.add_development_dependency 'ext_minitest', version
end
