require 'rake/gempackagetask'

task :default do
  all_tasks = Rake::application.tasks
  width = all_tasks.select { |t| t.comment }.collect { |t| t.name.length }.max
  all_tasks.each do |t|
    if t.comment
      printf "rake %-#{width}s  # %s\n", t.name, t.comment
    end
  end
end

desc "Runs all tests for 'required'"
task :test do
  load 'tests/required_test.rb'
end

spec = Gem::Specification.new do |s| 
  s.name = "required"
  s.version = "0.1.1"
  s.author = "Arild Shirazi"
  s.email = "ashirazi@codesherpas.com"
  s.homepage = "http://blog.codesherpas.com/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Provides the ability to 'require' many or all files within " +
      "directories, using a simple statement."
  s.description = <<DESCRIPTION
Required, a utility to require all files in a directory
Required provides the ability to require all files within a directory, with options for file inclusion/exclusion based on pattern matching, as well as recursive descent. An array of all the files that were loaded (‘require’ only loads a file the first time) are returned.

Quick start
First pull in the ‘required’ module:

    require 'required'
To pull in all ruby files in a directory (this excludes subdirectories):

    required "some/path/to/dir"
Same as before, but require the files in reverse alphanumeric order:

    required "some/path/to/dir", :sort => lambda { |x, y| y <=> x}
To pull in files from multiple directories:

    required ["some/path/to/dir", "another/path/another/dir"]
Or to recurse through subdirectories, requiring all files along the way:

    required "lib", {:recurse => true}
Same as before, but exclude ruby files tagged as "_old":

    required "lib", {:recurse => true, :exclude => /_old/}
    # Will not require "lib/extensions/string_old.rb"
Same as before, but only require ruby files tagged with "_new":

    required "lib", {:recurse => true, :include => /_new/}
DESCRIPTION
  s.files = FileList["lib/**/*"].to_a
  s.require_path = "lib"
  # s.autorequire = "name"
  s.test_files = FileList["test/**/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  # s.add_dependency("dependency", ">= 0.x.x")
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 
