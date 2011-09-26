require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "subscribed" do
    assert users(:good_account).subscribed?
    assert !users(:not_subscribed_account).subscribed?
  end
  
end
