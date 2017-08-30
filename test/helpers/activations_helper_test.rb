require 'test_helper'

class ActivationsHelperTest < ActionView::TestCase
  include SessionsHelper

  def setup
    @user = users(:jack)
  end
  
  test "should save submitted email to session" do
    save_email @user
    assert submitted_email_was_saved?
  end
end