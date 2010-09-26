require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @ruby = products(:ruby)
    @update = {
      :title    =>  "Lorem Ipsum",
      :description => "So awesome",
      :image_url   => "lorem.jpg",
      :price       => 19.95
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, :product => @update
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, :id => @product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product.to_param
    assert_response :success
  end

  test "should update product" do
    put :update, :id => @product.to_param, :product => @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => @ruby.to_param #using ruby book as it has no line items, whereas :one _does_ and should not be deletable
    end

    assert_redirected_to products_path
  end
  
  test "should not destroy products with line items" do
    assert_difference('Product.count', 0) do
      delete :destroy, :id => @product.to_param
    end

    assert_redirected_to products_path
  end
  
end
