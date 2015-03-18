require "bundler/setup"
require "bundler/gem_tasks"

task :default => [:spec]

#
# Testing
#

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = [
    "--format documentation",
    "--color",
  ]
end

RSpec::Core::RakeTask.new(:spec_current) do |t|
  t.rspec_opts = [
    "--format documentation",
    "--color",
    "--tag current"
  ]
end

#
# Documentation
#

require "yard"
require "yard/rake/yardoc_task"

# rake yard
YARD::Rake::YardocTask.new do |t|
  t.files = [
    "lib/{,**}/*.rb"
  ]
end

