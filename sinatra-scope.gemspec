spec = Gem::Specification.new do |s|
  s.name = 'sinatra-scope'
  s.version = '0.1.0'
  s.summary = "Simple nested routes for Sinatra"
  s.description = %{Simple nested routes for Sinatra.}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
  s.has_rdoc = false
  s.rubyforge_project = 'sinatra-scope'
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.rdoc_options << '--title' <<  'Sinatra::Scope -- Simple nested routes for Sinatra'
  s.author = "Nathan Herald"
  s.email = "nathan@myobie.com"
  s.homepage = "http://github.com/myobie/sinatra-scope"
  s.requirements << 'sinatra'
  s.add_dependency('sinatra')
  s.add_dependency('activesupport', '~> 3.0.0')
  s.add_dependency('i18n', '~> 0.5.0')
end
