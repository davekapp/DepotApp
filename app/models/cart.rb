class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  
  def add_product(product_id)
    current_item = line_items.where(:product_id => product_id).first
    price_changed = false 
    if current_item # not null, have item
      current_item.quantity += 1
      if current_item.price != Product.find(product_id).price
        price_changed = true
        current_item.price = current_item.product.price
      end
    else
      current_item = LineItem.new(:product_id => product_id, :price => Product.find(product_id).price)
      line_items << current_item
    end
    return current_item, price_changed
  end
  
  def total_price
    line_items.to_a.sum {|item| item.total_price}
  end
  
  def total_items
    line_items.sum(:quantity)
  end
end
