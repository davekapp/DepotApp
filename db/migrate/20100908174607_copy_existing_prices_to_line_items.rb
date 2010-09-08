class CopyExistingPricesToLineItems < ActiveRecord::Migration
  def self.up
    # give all line items a price based on the existing product price
    LineItem.all.each do |item|
      item.price = item.product.price
      item.save
    end
  end

  def self.down
    # can't back this one out properly, as there's no way to know what the "correct" product price is based on what differing line items say
  end
end
