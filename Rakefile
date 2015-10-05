require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_spec.rb', 'test/**/*_test.rb']
end

task :console do
  exec 'pry -r also_energy -I ./lib'
end

task :default => :test
