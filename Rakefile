#require "bundler/gem_tasks"
#require "rspec/core/rake_task"

require "rake/testtask"

#RSpec::Core::RakeTask.new(:spec)

task :default => :test

Rake::TestTask.new do |t|
	t.libs << "test"
	t.test_files = FileList['test/test*.rb']
	t.verbose = true
end
