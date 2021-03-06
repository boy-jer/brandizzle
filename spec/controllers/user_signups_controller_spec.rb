require 'spec_helper'

describe UserSignupsController do
  describe "handling GET edit" do
    before(:each) do
      @user = mock_model(User)
      User.stub!(:find_using_perishable_token).and_return(@user)
    end
    
    def do_get
      get :edit, :id => "foo"
    end
    
    it "finds the user by perishable token and assigns it for the view" do
      User.should_receive(:find_using_perishable_token).with("foo").and_return(@user)
      do_get
      assigns[:user].should == @user
    end
    
    it "renders the edit template" do
      do_get
      response.should render_template(:edit)
    end
    
    it "sets the flash message nad redirects to the home page when user not found" do
      User.should_receive(:find_using_perishable_token).with("foo").and_return(nil)
      do_get
      flash[:warning].should_not be_nil
      response.should redirect_to(new_user_session_path)
    end
  end
  
  describe "handling PUT update" do
    before(:each) do
      @user = mock_model(User)
      User.stub(:find_using_perishable_token).and_return(@user)
      
      @user.stub(:attributes=)
      @user.stub(:active=)
    end
    
    def do_put_with_valid_attributes(options={})
      @user.should_receive(:save).and_return(true)
      put :update, :id => "foo", :user => options
    end
    
    it "finds the user by perishable token and assigns it for the view" do
      User.should_receive(:find_using_perishable_token).with("foo").and_return(@user)
      do_put_with_valid_attributes
      assigns[:user].should == @user
    end
    
    it "sets the flash message and redirects to the home page when invalid token" do
      User.stub(:find_using_perishable_token).and_return(nil)
      put :update, :id => "foo"
      flash[:warning].should_not be_nil
      response.should redirect_to(new_user_session_path)
    end
    
    it "assigns the attributes to the user" do
      @user.should_receive(:attributes=).with(hash_including(:password => "foo", :password_confirmation => "bar"))
      do_put_with_valid_attributes(:password => "foo", :password_confirmation => "bar")
    end
    
    it "sets the active flag to true" do
      @user.should_receive(:active=).with(true)
      do_put_with_valid_attributes
    end
    
    it "sets the flash message and redirects to the homepage on success" do
      do_put_with_valid_attributes
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
    
    it "renders the edit template on failure" do
      @user.should_receive(:save).and_return(false)
      put :update, :id => "foo", :user => {}
      response.should render_template(:edit)
    end
  end
end
