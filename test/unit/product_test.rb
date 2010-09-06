require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "product titles must be at least five characters long" do
    product = products(:ruby)
    assert product.valid?
    
    product.title = "four"
    assert product.invalid?
    assert_equal "is too short (minimum is 5 characters)", product.errors[:title].join("; ")
    
    product.title = "five5"
    assert product.valid?
  end
  
  test "price must be positive" do
    product = Product.new(:title => "Some Book",
                          :description => "It's just some book.",
                          :image_url => "somebook.jpg"
                         )
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    
    product.price = 1.0
    assert product.valid?
  end
  
  def new_product_from_image_url(url)
    Product.new(:title => "Some Book",
                :description => "It's just some book.",
                :price => 1.5,
                :image_url => url
               )
  end
  
  test "image_url does not accept invalid names" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.JpG FreD.jPG http://a.b.c/x/y/z/freD.GiF }
    bad = %w{ fred.doc fred.gif/more fred.gif.more fred.gi fred.gif_ fred }
    
    ok.each do |ok_name|
      assert new_product_from_image_url(ok_name).valid?, "#{ok_name} should be valid is being flagged as invalid"
    end
    
    bad.each do |bad_name|
      assert new_product_from_image_url(bad_name).invalid?, "#{bad_name} should be invalid but is being accepted as valid"
    end
  end
  
  test "title for a product must be unique" do
    product = Product.new(:title => products(:ruby).title, # already used by the :ruby book
                          :description => "blahblah",
                          :price => 2.50,
                          :image_url => "blahblah.jpg"
    )
    
    assert !product.save
    assert_equal I18n.translate("activerecord.errors.messages.taken"), product.errors[:title].join('; ')
  end
  
end
