require 'rubygems'
require 'shoulda'
require 'require_all'

class RequireAllTest < Test::Unit::TestCase
  context "The non-recursive mechanism to require a group of files" do
    setup do
      # $REQUIRED global will be populated with filename of each file required
      # require_all "#{File.dirname __FILE__}/require_all_test"
      @required ||= []
      @required += require_all("require_all_test")
    end

    should "accurately report all files that have been required" do
      assert_equal(
          %W(require_all_test/required-1.rb
            require_all_test/required-2.rb
            require_all_test/required\ space\ 3.rb
            ).sort, @required.sort)
    end

    should "require all ruby files (those having a .rb extension)" do
      %W(require_all_test/required-1.rb
         require_all_test/required-2.rb
         require_all_test/required\ space\ 3.rb
         ).each {|f| assert $REQUIRED.include?(f),
                 "#{f} not found in #{$REQUIRED.inspect}"}
    end

    should "ignore non-ruby files" do
      %W(require_all_test/junk space 4.rake
         require_all_test/junk-2
         require_all_test/junk-1.rbt
         require_all_test/junk-3rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end

    should "ignore hidden files (files with a . prefix)" do
      %W(require_all_test/.required-4.rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end

    should "ignore ruby files in subdirectories" do
      %W(
          require_all_test/sub1
          require_all_test/sub1/required-1.rb
          require_all_test/sub1/required-2.rb
          require_all_test/sub1/required\ space\ 3.rb
          require_all_test/sub1/junk space 4.rake
          require_all_test/sub1/junk-2
          require_all_test/sub1/junk-1.rbt
          require_all_test/sub1/junk-3rb
          ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end
  end

  context "The recursive mechanism to require a group of files" do
    setup do
      # $REQUIRED global will be populated with filename of each file required
      # require_all "#{File.dirname __FILE__}/require_all_test", true
      @required ||= []
      @required +=  require_all("require_all_test", true)
    end

    should "accurately report all files that have been required" do
      assert_equal(
          %W(require_all_test/sub1/required-1.rb
            require_all_test/sub1/required-2.rb
            require_all_test/sub1/required\ space\ 3.rb
            require_all_test/sub1/sub2/required-1.rb
            require_all_test/sub1/sub2/required-2.rb
            require_all_test/sub1/sub2/required\ space\ 3.rb
            ).sort, @required.sort)
    end

    should "require all ruby files in subdirectories" do
      %W(require_all_test/sub1/required-1.rb
         require_all_test/sub1/required-2.rb
         require_all_test/sub1/required\ space\ 3.rb
         require_all_test/sub1/sub2/required-1.rb
         require_all_test/sub1/sub2/required-2.rb
         require_all_test/sub1/sub2/required\ space\ 3.rb
         ).each {|f| assert $REQUIRED.include?(f),
                 "#{f} not found in #{$REQUIRED.inspect}"}
    end

    should "ignore non-ruby files in subdirectories" do
      %W(require_all_test/sub1/junk space 4.rake
         require_all_test/sub1/junk-2
         require_all_test/sub1/junk-1.rbt
         require_all_test/sub1/junk-3rb
         require_all_test/sub1/sub2/junk space 4.rake
         require_all_test/sub1/sub2/junk-2
         require_all_test/sub1/sub2/junk-1.rbt
         require_all_test/sub1/sub2/junk-3rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end

    should "ignore hidden files (files with a . prefix) in subdirectories" do
      %W(require_all_test/.required-4.rb
         require_all_test/sub1/.required-4.rb
         require_all_test/sub1/sub2/.required-4.rb
         require_all_test/sub1/.sub3/required-1.rb
         ).each {|f| assert ! $REQUIRED.include?(f),
                 "#{f} found in #{$REQUIRED.inspect}"}
    end
  end
end
