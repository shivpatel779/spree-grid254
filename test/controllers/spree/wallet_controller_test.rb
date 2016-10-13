require 'test_helper'

class Spree::WalletControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get credit_money" do
    get :credit_money
    assert_response :success
  end

end
