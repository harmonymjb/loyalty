require 'test_helper'

class StoresControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stores_create_url
    assert_response :success
  end

end
