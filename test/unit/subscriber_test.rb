require 'test_helper'

class SubscriberTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "not account" do
    assert !users(:good_email).is_a?(Account)
  end
  
  test "methods not for account" do
    assert_respond_to(users(:good_email), :has_account?)
    assert !users(:good_account).respond_to?(:has_account?)
  end
  
  test "subscribed? always true" do
    assert users(:good_email).subscribed?
  end
  
end
