require 'test_helper'

class RefrigeratorControllerTest < ActionDispatch::IntegrationTest
  test "should get Status" do
    get refrigerator_Status_url
    assert_response :success
  end

end
