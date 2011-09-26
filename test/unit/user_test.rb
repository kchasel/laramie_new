require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "subscriber types" do
    s = Subscriber.new
    assert_kind_of(User, s)
    assert_kind_of(Subscriber, s)
  end
  
  test "subscriber is not account" do
    s = Subscriber.new
    assert !s.kind_of?(Account)
  end
  
  test "no save subscriber without email" do 
    assert !Subscriber.new().save
  end
  
  test "save subscriber with only email" do
    assert users(:good_email).save
  end
  
  test "no save bad email subscriber" do
    assert !Subscriber.new(:email => "abc@alksdjf").save
  end
  
  test "no duplicates" do
    s = users(:good_email)
    assert s.save
    n = Subscriber.new(:email => users(:good_email).email)
    assert(n.invalid?)
  end
  
  test "account without type fails" do
    assert users(:good_account).update_attribute(:type, nil)
    assert(users(:good_account).invalid?)
  end
  
  test "count" do
    assert_equal(User.count, 4)
    assert_equal(Account.subscriber.count + Subscriber.count, User.listhost_count)
  end
  
  test "subscribed? method" do
    assert users(:good_account).subscribed?
    assert users(:good_email).subscribed?
    assert !users(:not_subscribed_account).subscribed?
  end
  
  test "delete subscriber if account with e-mail added" do
    s = users(:replace_s)
    a = Account.new(:email => s.email, :firstname => "Lance", :lastname => "Account", :password => "123456", :password_confirmation => "123456")
    assert a.save
    assert_nil Subscriber.find_by_email(s.email)
  end
  
  test "no type" do
    assert !User.new(:email => "abc@123.com").save, "User saved w/o type"
  end
  
end
