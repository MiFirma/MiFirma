require 'bundler'
Bundler::GemHelper.install_tasks

require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => :test

desc 'Test the typus plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate plugin documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Typus'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Deploy test/fixtures/rails_app"
task :deploy do
  system "cd test/fixtures/rails_app && cap deploy"
end

RUBIES = %w[1.8.7 ree 1.9.2 jruby].join(",")

namespace :setup do

  desc "Setup test environment"
  task :test_environment do
    system "rvm install #{RUBIES}"
  end

  desc "Setup CI Joe"
  task :cijoe do
    system "git config --replace-all cijoe.runner 'rake test:rubies'"
  end

end

namespace :test do

  task :rubies do
    system "rvm #{RUBIES} rake"
  end

end
