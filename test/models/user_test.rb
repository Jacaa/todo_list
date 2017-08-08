require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = nil
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = nil
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 256
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.name = "a" * 256
    assert_not @user.valid?
  end
  
  test "email addresses should be unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end
  
  test "email should be rejected with invalid form" do 
    invalid_addresses = %w[user.ex.com user@ex,com user@ex
                           @ex.com user@ex+ex.com user_at_ex.com]
    invalid_addresses.each do |invalid|
      @user.email = invalid
      assert_not @user.valid?, "#{invalid.inspect} should be invalid"
    end    
  end

  test "email should be accepted with valid form" do
    valid_addresses = %w[user@ex.com USER@ex.COM US-ER@ex.foo.com
                         user.foo@bar.com user+foo@bar.com U_ser@ex.com]
    valid_addresses.each do |valid|
      @user.email = valid
      assert @user.valid?, "#{valid.inspect} should be valid"
    end
  end

  test "email should be saved as lower-case" do
    non_lower_case_email = "USER@EX.COM"
    @user.email = non_lower_case_email
    @user.save
    assert_equal non_lower_case_email.downcase, @user.email
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = "      "
    assert_not @user.valid?
  end

  test "password should have proper length" do
    @user.password = @user.password_confirmation = "12345"
    assert_not @user.valid?
  end

  test "remember token should be generated" do
    @user.save
    assert_not_nil @user.remember_token
  end

  test "activation token should be generated" do
    @user.save
    assert_not_nil @user.activation_token
  end

  test "password reset token should be generated" do
    @user.save
    @user.create_password_reset_token
    assert_not_nil @user.reload.password_reset_token
    assert_not_nil @user.reload.password_reset_sent_at
  end
end
