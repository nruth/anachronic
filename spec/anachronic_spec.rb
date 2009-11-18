require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Anachronic
  describe "Directory" do
    before(:each) do
      @path = 'test'
      FileUtils.mkdir @path
    end

    after(:each) do
      FileUtils.remove_dir(@path)
    end

    it "encapsulates a Dir" do
      anachronism = Anachronic::Directory.new(@path)
      anachronism.dir == Dir.new(@path)
    end
    
    it "rejects non-directory paths" do
      lambda {Anachronic::Directory.new('not_a_directory')}.should raise_error
    end      

    describe "#name_diff" do
      it "shows no changes when no changes made" do
        anachronism = Anachronic::Directory.new(@path)
        anachronism.name_diff(Anachronic::Directory.new(@path)).should be_empty
      end

      it "lists shallow changes" do
        anachronism = Anachronic::Directory.new(@path)
        FileUtils.touch File.join(@path, 'new_file')
        anachronism.name_diff(Anachronic::Directory.new(@path)).should include('new_file')
      end
      
      it "lists recursive/directory changes" do
        anachronism = Anachronic::Directory.new(@path)        
        FileUtils.makedirs(File.join(@path,'newdir','deeper','and_deeper'))
        anachronism.name_diff(Anachronic::Directory.new(@path)).should include('newdir')
        anachronism.name_diff(Anachronic::Directory.new(@path)).should include(File.join('newdir','deeper'))
        anachronism.name_diff(Anachronic::Directory.new(@path)).should include(File.join('newdir','deeper','and_deeper'))
      end
      
      it "tracks removed files" do
        FileUtils.touch File.join(@path, 'new_file')
        anachronism = Anachronic::Directory.new(@path)        
      end
      
      it "tracks removed directories" do
        FileUtils.makedirs(testdir = File.join(@path,'newdir','deeper','and_deeper'))
        anachronism = Anachronic::Directory.new(@path)        
        FileUtils.remove_dir(testdir)
        anachronism.name_diff(Anachronic::Directory.new(@path)).should_not include('newdir')
        anachronism.name_diff(Anachronic::Directory.new(@path)).should_not include(File.join('newdir','deeper'))
        anachronism.name_diff(Anachronic::Directory.new(@path)).should     include(File.join('newdir','deeper','and_deeper'))
      end
    end


    it "should reimplement == to compare filenames"

    it "#to_path returns a path string; for Ruby 1.9"
    
    it "symlinks?"
    it "hard links?"

    it "can be mixed into Dir.class for factory use as Dir#anachronism"
  end
end
