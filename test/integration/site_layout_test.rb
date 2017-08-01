require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout elements" do
    get root_path
    assert_template 'static_pages/index'
    assert_select "title", "ToDo"
    assert_select "button", count: 2
    assert_select "a[target=_blank]", "GitHub"
  end
end
