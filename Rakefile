require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'

task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  # Put spec opts in a file named .rspec in root
end

desc "Run tests"
Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = false
end

desc "Starts the game"
task :start do
  require './lib/mech_rl'
  MechRL::GameWindow.instance.show
end

task :playground do
  require './lib/mech_rl'
  window = MechRL::GameWindow.instance
  window.views.push MechRL::View::Game.new
  window.show
end

