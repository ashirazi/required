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
  s.version = "0.1.3"
  s.author = "Arild Shirazi"
  s.email = "ashirazi@codesherpas.com"
  s.homepage = "http://github.com/ashirazi/required"
  s.platform = Gem::Platform::RUBY
  s.summary = "Required is a utility to require all files in a directory."
  s.description = <<DESCRIPTION
Required is a utility to require all files in a directory.

Why would one want to require a whole bunch of files at once? I have used this
gem on 2 projects to:
  - require dozens of jar files when working on a JRuby project
  - pull in all files before running code coverage (rcov), to find code that
      is otherwise dead/untouched

Options for required include the ability to recursively descend through
subdirectories, include/exclude files based on pattern matching, and to specify
the order of requires based on filename.  An array of all the files that were
loaded is returned.

Quick example:
  require 'required'
  required "some/path/to/dir"

See the README for more examples, and description of options.
DESCRIPTION
  s.files = FileList["lib/**/*"].to_a
  s.require_path = "lib"
  # s.autorequire = "name"
  s.test_files = FileList["tests/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  # s.add_dependency("dependency", ">= 0.x.x")
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 
