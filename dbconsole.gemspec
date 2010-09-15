spec = Gem::Specification.new do |s|
  s.name = 'dbconsole'
  s.version = '1.0.0'
  s.summary = "REPL for databases supported by ActiveRecord"
  s.description = %{REPL console for accessing and querying databases supported by ActiveRecord}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = 'dbconsole'
  s.has_rdoc = true
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.rdoc_options << '--title' <<  'DB-Console -- A simple, powerful database console'
  s.author = "Jason Madigan"
  s.email = "jason@jasonmadigan.com"
  s.homepage = "http://jasonmadigan.com"
end
