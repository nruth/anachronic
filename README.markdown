anachronic
----------

Directory content snapshots w/ comparison functionality to track filename & existence changes in testing. Developed for cucumber & rspec.

Enables easy implementation of this kind of cucumber scenario:

    Scenario: completely delete an image
      Given I record the state of "public/system"
      And a site image exists
      Then the file contents of "public/system" should have changed
      When I go to the site_image's page
      And I press "Delete Image"
      Then the site image should be deleted
      When I go to the site_images page
      Then I should not see "Metal Box"
      Then the file contents of "public/system" should be as they were
  
Where the steps of interest are:
    
    Given I record the state of "public/system"
    Then the file contents of "public/system" should have changed
    Then the file contents of "public/system" should be as they were

And are as simple as:

    Given /^I record the state of "([^\"]*)"$/ do |path|
      @snapshot = Anachronic::Directory.new(path)
    end

    Then /^the file contents of "([^\"]*)" should have changed$/ do |path|
      @snapshot.name_diff(Anachronic::Directory.new(path)).should_not be_empty
    end

    Then /^the file contents of "([^\"]*)" should be as they were$/ do |path|
      diff = @snapshot.name_diff(Anachronic::Directory.new(path))
      diff.should be_empty, "#{diff.inspect}"
    end
    
Where this code sits in vendor/plugins/anachronism.

Gem to follow, when I get it to work.

Missing Functionality / Planned Features
------------------------------------------------------------
  
* Does not detect file size, timestamp, or content changes
* Does not show whether files were +'d or -'d (think diff)

Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.  
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2009 Nicholas Rutherford. See LICENSE for details.
