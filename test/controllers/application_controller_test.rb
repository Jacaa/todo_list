require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
 test "should get index" do
   get root_url
   assert_select "body", text: "Hello"
 end
end
