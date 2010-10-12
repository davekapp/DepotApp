require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    dave = users(:dave)
    post :create, :name => dave.name, :password => "secret"
    assert_redirected_to admin_url
    assert_equal dave.id, session[:user_id]
  end

  test "should fail to login with incorrect credentials" do
    dave = users(:dave)
    post :create, :name => dave.name, :password => "wrong_password"
    assert_redirected_to login_url
  end
  
  test "should logout" do
    delete :destroy
    assert_redirected_to store_url
    assert_equal nil, session[:user_id]
  end

end
