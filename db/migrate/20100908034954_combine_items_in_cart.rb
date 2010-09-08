class CombineItemsInCart < ActiveRecord::Migration
  def self.up
    # replace multiple items for a single product in a cart with a single item that has the appropriate quantity
    Cart.all.each do |cart|
      # find the number of each product in the cart
      sums = cart.line_items.group(:product_id).sum(:quantity)
      
      # result is a hash with of product_id => quantity pairs (eg: { 2=>2, 3=>1, 4=>5 }
      sums.each do |product_id, quantity|
        if quantity > 1
          # remove individual items and replace with single that has the quantity
          cart.line_items.where(:product_id => product_id).delete_all
          cart.line_items.create(:product_id => product_id, :quantity => quantity)
        end #end if
      end #end sums.each
    end #end cart.line_items
  end #end self.up

  def self.down
    # reverse process by splitting items into individual entries with quantities of 1
    LineItem.where("quantity>1").each do |line_item|
      line_item.quantity.times do
        LineItem.create :cart_id => line_item.cart_id, :product_id => line_item.product_id, :quantity => 1
      end
      # now that we've added the singles, destroy the original
      line_item.destroy
    end 
  end
  
end
