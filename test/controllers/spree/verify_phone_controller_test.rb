require 'test_helper'

class Spree::VerifyPhoneControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get verify" do
    get :verify
    assert_response :success
  end

end
