require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
        :name => "Example User",
        :email => "user@example.com",
        :password => 'foobar',
        :password_confirmation => 'foobar'
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  # NAME
  describe "name validations" do
    it "should create a new instance given valid attributes" do
      User.create!(@attr)
    end

    it "should require a name" do
      no_name_user = User.new(@attr.merge(:name=>''))
      no_name_user.should_not be_valid
    end

    it "should reject names are too long" do
      long_name_user = User.new(@attr.merge(:name => "a" * 51))
      long_name_user.should_not be_valid
    end
  end


  # EMAIL
  describe "email validations" do
    it "should require an email" do
      no_email_user = User.new(@attr.merge(:email=>''))
      no_email_user.should_not be_valid
    end

    it "should accept valid email" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. user@test.f]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end

    it "should reject more than 128 chars length email" do
      long_email      = "A" * 120 + "@example.com"
      long_email_user = User.new(@attr.merge(:email=> long_email))
    end

    it "should reject duplicate email addresses" do
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  end

  # PASSWORD
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).
          should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => 'barfoo')).
          should_not be_valid
    end

    it "should reject short passwords" do
      short_password = 'a' * 5
      User.new(@attr.merge(:password => short_password, :password_confirmation => short_password)).
          should_not be_valid
    end

    it "should reject long passwords" do
      long_password = 'a' * 41
      User.new(@attr.merge(:password => long_password, :password_confirmation => long_password)).
          should_not be_valid
    end
  end

  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if hte passwords don't match" do
        @user.has_password?('test').should be_false
      end
    end

    describe "authentication method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        non_existent_user = User.authenticate("nonexistent", @attr[:password])
        non_existent_user.should be_nil
      end

      it "should return the user on email/password match" do
        user = User.authenticate(@attr[:email], @attr[:password])
        user.should == @user
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

  end

  describe "micropost association" do
    before(:each) do
      @user = User.create(@attr)
      @mp1  = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2  = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status feed" do
      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include a different user's microposts" do
        @mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(@mp3).should be_false
      end

      it "should include the microposts of followed users" do
        other_user = Factory(:user, :email => Factory.next(:email))
        @mp3 = Factory(:micropost, :user => other_user)
        @user.follow!(other_user)
        @user.feed.should include(@mp3)
      end
    end
  end


  describe "relationships" do
    before(:each) do
      @user = Factory(:user)
      @followed = Factory(:user, :email => Factory.next(:email))
    end

    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end

    it "should have a following method" do
      @user.should respond_to(:following)
    end

    it "should have a following? method" do
      @user.should respond_to(:following?)
    end

    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end

    it "should have a unfollow! method" do
      @user.should respond_to(:unfollow!)
    end

    it "should destroy relation with a followed user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end

    it "should have a reverse_relationships method" do
      @user.should respond_to(:reverse_relationships)
    end

    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end

  end

  describe "notifications" do
    before(:each) do
      @user = User.create!(@attr)
    end
  

    it "should respond to notified_new_follower" do
      @user.should respond_to(:notified_new_follower)
    end

    it "should be notified by default" do
      @user.should be_notified_new_follower
    end

    it "should be convertible to notify on new follower" do
      @user.toggle!(:notified_new_follower)
      @user.should_not be_notified_new_follower
    end

  end
end
