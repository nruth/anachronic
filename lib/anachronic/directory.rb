module Anachronic
  class Directory
    require 'set'
    require 'fileutils'
    attr_reader :snapshot, :dir
    
    def initialize(path)
      @dir = Dir.new(path)
      
      FileUtils.cd(@dir.path) do |pwd|
        @snapshot = Set.new
        @snapshot.merge recurse_over_dir
      end
    end
    
    def to_path
      @dir.path
    end
    
    def name_diff(compare_to)
      self.snapshot ^ compare_to.snapshot
    end
    
  private
    def recurse_over_dir
      shallow_contents = Set.new

      Dir.glob("*") do |shallow_filename|
        shallow_contents << shallow_filename
        
        if File.directory? shallow_filename
          FileUtils.cd(shallow_filename) do |pwd|
            expanded_names = recurse_over_dir.collect { |name| pwd + File::Separator + name}
            shallow_contents.merge expanded_names
          end
        end
      end
      
      shallow_contents
    end
  end
end