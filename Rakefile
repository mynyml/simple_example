# --------------------------------------------------
# tasks mostly copied from thin's Rakefile
# http://github.com/macournoyer/thin/tree/master
# --------------------------------------------------
require 'rake/gempackagetask'
require 'pathname'
require 'yaml'

RUBY_1_9  = RUBY_VERSION =~ /^1\.9/
WIN       = (RUBY_PLATFORM =~ /mswin|cygwin/)
SUDO      = (WIN ? "" : "sudo")
ROOT      = Pathname(__FILE__).dirname.expand_path

def gem
  RUBY_1_9 ? 'gem19' : 'gem'
end

def all_except(paths)
  Dir['**/*'] - paths.map {|path| path.strip.gsub(/^\//,'').gsub(/\/$/,'') }
end

def gitignored
  ROOT.join('.gitignore').read.strip.split("\n").compact.map {|line| line.strip }
end

spec = Gem::Specification.new do |s|
  s.name            = 'simple_example'
  s.version         = '0.1'
  s.summary         = "Add easy fancy-pants examples to your projects."
  s.description     = "Add easy fancy-pants examples to your projects."
  s.author          = "Martin Aumont"
  s.email           = 'mynyml@gmail.com'
  s.homepage        = ''
  s.has_rdoc        = true
  s.require_path    = "lib"
  s.files           = all_except(gitignored << 'generate_examples_results.rb')

  s.add_dependency 'ruby2ruby'
  s.add_dependency 'ParseTree'
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end


desc "Remove package products"
task :clean => :clobber_package

desc "Update the gemspec for GitHub's gem server"
task :gemspec do
  Pathname("#{spec.name}.gemspec").open('w') {|f| f << YAML.dump(spec) }
end

desc "Install gem"
task :install => [:clobber, :package] do
  sh "#{SUDO} #{gem} install pkg/#{spec.full_name}.gem"
end

desc "Uninstall gem"
task :uninstall => :clean do
  sh "#{SUDO} #{gem} uninstall -v #{spec.version} -x #{spec.name}"
end

