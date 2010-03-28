Dir.chdir File.expand_path(File.dirname(__FILE__) + "/..")
require 'rubygems'
require 'shoulda'
require 'lib/required'

class RequiredTest < Test::Unit::TestCase
  context "The non-recursive mechanism to require a group of files" do
    setup do
      @req_dir = "tests/required_test"
      @required ||= []
      @required += required @req_dir
      # $REQUIRED global will be populated with filename of each file required
    end

    should "accurately report all files that have been required" do
      assert_equal(
          %W(#{@req_dir}/required-1.rb
             #{@req_dir}/required-2.rb
             #{@req_dir}/required\ space\ 3.rb
             ).sort, @required.sort)
    end

    should "require all ruby files (those having a .rb extension)" do
      %W(#{@req_dir}/required-1.rb
         #{@req_dir}/required-2.rb
         #{@req_dir}/required\ space\ 3.rb
         ).each {|f| assert $REQUIRED.include?(f),
                 "#{f} not found in #{$REQUIRED.inspect}"}
    end

    should "ignore non-ruby files" do
      %W(#{@req_dir}/junk space 4.rake
         #{@req_dir}/junk-2
         #{@req_dir}/junk-1.rbt
         #{@req_dir}/junk-3rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end

    should "ignore hidden files (files with a . prefix)" do
      %W(#{@req_dir}/.required-4.rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end

    should "ignore ruby files in subdirectories" do
      %W(#{@req_dir}/sub1
         #{@req_dir}/sub1/required-1.rb
         #{@req_dir}/sub1/required-2.rb
         #{@req_dir}/sub1/required\ space\ 3.rb
         #{@req_dir}/sub1/junk space 4.rake
         #{@req_dir}/sub1/junk-2
         #{@req_dir}/sub1/junk-1.rbt
         #{@req_dir}/sub1/junk-3rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end
  end

  context "The recursive mechanism to require a group of files" do
    setup do
      @req_dir = "tests/required_test"
      @required ||= []
      @required +=  required(@req_dir, true)
      # $REQUIRED global will be populated with filename of each file required
    end

    should "accurately report all files that have been required" do
      assert_equal(
          %W(#{@req_dir}/sub1/required-1.rb
             #{@req_dir}/sub1/required-2.rb
             #{@req_dir}/sub1/required\ space\ 3.rb
             #{@req_dir}/sub1/sub2/required-1.rb
             #{@req_dir}/sub1/sub2/required-2.rb
             #{@req_dir}/sub1/sub2/required\ space\ 3.rb
             ).sort, @required.sort)
    end

    should "require all ruby files in subdirectories" do
      %W(#{@req_dir}/sub1/required-1.rb
         #{@req_dir}/sub1/required-2.rb
         #{@req_dir}/sub1/required\ space\ 3.rb
         #{@req_dir}/sub1/sub2/required-1.rb
         #{@req_dir}/sub1/sub2/required-2.rb
         #{@req_dir}/sub1/sub2/required\ space\ 3.rb
         ).each {|f| assert $REQUIRED.include?(f),
                 "#{f} not found in #{$REQUIRED.inspect}"}
    end

    should "ignore non-ruby files in subdirectories" do
      %W(#{@req_dir}/sub1/junk space 4.rake
         #{@req_dir}/sub1/junk-2
         #{@req_dir}/sub1/junk-1.rbt
         #{@req_dir}/sub1/junk-3rb
         #{@req_dir}/sub1/sub2/junk space 4.rake
         #{@req_dir}/sub1/sub2/junk-2
         #{@req_dir}/sub1/sub2/junk-1.rbt
         #{@req_dir}/sub1/sub2/junk-3rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end

    should "ignore hidden files (files with a . prefix) in subdirectories" do
      %W(#{@req_dir}/.required-4.rb
         #{@req_dir}/sub1/.required-4.rb
         #{@req_dir}/sub1/sub2/.required-4.rb
         #{@req_dir}/sub1/.sub3/required-1.rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end
  end
end
