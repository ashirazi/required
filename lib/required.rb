module Kernel

  # Searches through the given directory or array of directories, and will
  # `require` all ruby files found. Recursion flag will traverse subdirectories
  # to `require` ruby files (.rb suffix) within them. Returns an array of files
  # that were actually loaded in the order which they were loaded.
  #
  # Note: required files are loaded only once.
  def require_all(directories, recurse=false)
    loaded_files = []
    directories.each do |directory|
      next unless File.directory? directory
      loaded_files << require_within(directory)

      next unless recurse
      sub_dirs = Dir["#{directory}/*"].select { |d| File.directory? d }
      sub_dirs.each { |sub_dir| loaded_files << require_all(sub_dir, true) }
    end
    loaded_files.flatten
  end

  private
  def require_within(directory)
    next unless File.directory? directory
    loaded_files = []
    ruby_files = Dir["#{directory}/*.rb"].reject{ |f| File.directory? f }
    ruby_files.each { |file| loaded_files << file if require file }
    loaded_files
  end


end
