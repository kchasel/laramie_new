require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def setup
    NotificationMailer.default_url_options = { :host => 'www.nlralliance.org' }
  end
  
  test "the truth" do
    assert true
  end
  
  test "index is assistance" do
    assert_recognizes({:controller => 'subscribers', :action => 'assistance'}, {:path => 'subscribers' })
  end
  
  test "thanks" do
    get :thanks
    assert_redirected_to({:action => 'assistance'})
    
    get(:thanks, nil, nil, {:subscriber => users(:good_email)})
    assert assigns(:email)
    assert_equal flash[:subscriber], users(:good_email)
    assert_template "thanks"
  end
  
  test "unsubscribe" do
    get :unsubscribe
    assert !assigns(:deleted)
    
    post :unsubscribe
    assert_template "unsubscribe"
    
    post(:unsubscribe, {:email => users(:not_subscribed_account)})
    assert_equal "The e-mail you entered is not in our system.", flash[:notice]
    
    post(:unsubscribe, {:email => users(:good_email).email})
    assert_redirected_to({:action => "removed"})
  end
  
  test "create no params" do
    get :create
    assert_redirected_to({:action => "assistance"})
  end
  
  test "create existing subscriber" do
    
    assert_no_difference("User.count") do
      get(:create, {:subscriber => { :email => users(:good_email).email } } )
    end
    assert_redirected_to({:action => 'already_subscribed', :id => users(:good_email).id})
  end
    
  test "create new subscriber" do
    assert_difference("User.count") do
      assert_difference('ActionMailer::Base.deliveries.size') do
        get(:create, { :subscriber => { :email => "123@abc.com" } } )
      end
    end
    assert_redirected_to({:action => "thanks"})
  end
    
  test "subscribe existing account" do
    assert_difference("User.listhost_count") do
      assert_difference 'ActionMailer::Base.deliveries.size' do
        get(:create, {:subscriber => { :email => users(:not_subscribed_account).email } } )
      end
    end
    assert_redirected_to({:action => "thanks"})
  end
  
end
