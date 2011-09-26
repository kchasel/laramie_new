require 'test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  def setup
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{Laramie::CONFIG[:username]}:#{Laramie::CONFIG[:pw]}")
  end
  
  test "doesn't work when not admin" do
    @request.env["HTTP_AUTHORIZATION"] = nil
    get :index
    assert_response 401
  end
  
  test "show only when id" do
    get :show, :id => "1"
  end
  
  
end
