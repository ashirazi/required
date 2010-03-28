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

spec = Gem::Specification.new do |s| 
  s.name = "required"
  s.version = "0.1.0"
  s.author = "Arild Shirazi"
  s.email = "ashirazi@codesherpas.com"
  s.homepage = "http://blog.codesherpas.com/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Provides the ability to require all files within a directory, " +
      "with an option for recursive descent."
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
