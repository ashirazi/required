Dir.chdir File.expand_path(File.dirname(__FILE__) + "/..")
require 'rubygems'
require 'shoulda'
require 'lib/required'

class RequiredTest < Test::Unit::TestCase
  
  def reset_required_test_files
    my_test_files = $".select { |r| r =~ /required_test/ }
    my_test_files.each { |r| $".delete r }
    $REQUIRED = []
    # $REQUIRED global will be populated with filename of each file required
  end

  context "Non-recursive required" do
    setup do
      reset_required_test_files
      @req_dir = "tests/required_test"
      @required = required @req_dir
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

  context "Non-recursive, exclude pattern required" do
    setup do
      reset_required_test_files
      @req_dir = "tests/required_test"
      @required = required(@req_dir, :exclude => /-2/)
    end

    should "require only ruby files matching an include pattern" do
      %W(#{@req_dir}/required-2.rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} unexpectedly found in #{$REQUIRED.inspect}"}
    end

    should "not require ruby files that do not match the include pattern" do
      %W(#{@req_dir}/required-1.rb
         #{@req_dir}/required\ space\ 3.rb
         ).each {|f| assert $REQUIRED.include?(f),
                 "#{f} not found in #{$REQUIRED.inspect}"}
    end
  end

  context "Non-recursive, include pattern required" do
    setup do
      reset_required_test_files
      @req_dir = "tests/required_test"
      @required = required(@req_dir, :include => /-2/)
    end

    should "require only ruby files matching an include pattern" do
      %W(#{@req_dir}/required-2.rb
         ).each {|f| assert $REQUIRED.include?(f),
                 "#{f} not found in #{$REQUIRED.inspect}"}
    end

    should "not require ruby files that do not match the include pattern" do
      %W(#{@req_dir}/required-1.rb
         #{@req_dir}/required\ space\ 3.rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} unexcpectedly found in #{$REQUIRED.inspect}"}
    end
  end

  context "Non-recursive, exclude and include pattern required" do
    setup do
      reset_required_test_files
      @req_dir = "tests/required_test"
      @required = required(@req_dir, {:include => /required-/, :exclude => /2/})
    end

    should "require only ruby files matching an include pattern" do
      %W(#{@req_dir}/required-1.rb
         ).each {|f| assert $REQUIRED.include?(f),
                 "#{f} not found in #{$REQUIRED.inspect}"}
    end

    should "not require ruby files that do not match the include pattern" do
      %W(#{@req_dir}/required-2.rb
         #{@req_dir}/required\ space\ 3.rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} unexcpectedly found in #{$REQUIRED.inspect}"}
    end
  end

  context "Recursive required" do
    setup do
      reset_required_test_files
      @req_dir = "tests/required_test"
      @required =  required(@req_dir, :recurse => true)
    end

    should "accurately report all files that have been required" do
      assert_equal(
          %W(#{@req_dir}/required\ space\ 3.rb
             #{@req_dir}/required-1.rb
             #{@req_dir}/required-2.rb
             #{@req_dir}/sub1/required-1.rb
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
