require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :products
  fixtures :carts
  
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "may add a single item to a cart" do
    assert carts(:empty).line_items.count == 0
    
    carts(:empty).add_product( products(:ruby).id )
    assert carts(:empty).line_items.count == 1
    assert carts(:empty).line_items.where(:product_id => products(:ruby).id).first.quantity == 1    
  end
  
  test "may add multiple individual items to a cart" do
    assert carts(:empty).line_items.count == 0
    
    carts(:empty).add_product( products(:ruby).id )
    carts(:empty).add_product( products(:rails).id )
    assert carts(:empty).line_items.count == 2
    assert carts(:empty).line_items.where(:product_id => products(:ruby).id).first.quantity == 1
    assert carts(:empty).line_items.where(:product_id => products(:rails).id).first.quantity == 1
  end
  
  test "may add multiples of the same item to a cart" do
    assert carts(:empty).line_items.count == 0
    
    # add_product returns [line_item, price_changed], and we want to call save on the line_item, so use [0] to get it
    carts(:empty).add_product( products(:ruby).id )[0].save
    carts(:empty).add_product( products(:rails).id )[0].save
    carts(:empty).add_product( products(:ruby).id )[0].save
    
    assert carts(:empty).line_items.count == 2
    assert carts(:empty).line_items.where(:product_id => products(:ruby).id).first.quantity == 2, "Expected 2 but got " +
      "#{carts(:empty).line_items.where(:product_id => products(:ruby).id).first.quantity}"
    assert carts(:empty).line_items.where(:product_id => products(:rails).id).first.quantity == 1
  end
  
end
