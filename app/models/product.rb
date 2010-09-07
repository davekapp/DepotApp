class Product < ActiveRecord::Base
  default_scope :order => "title"
  
  has_many :line_items
  
  before_destroy :ensure_not_referenced_by_any_line_item
  
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01 }
  validates :title, :uniqueness => true
  validates :image_url, :format => {
    :with     => %r{\.(gif|jpg|png)$}i,
    :message  => "must be an URL for a GIF, JPG, or PNG image."
  }
  validates :title, :length => {:minimum => 5}
  
  # don't allow a product to be destroyed if there are still line items that reference it
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      return true
    else
      errors[:base] << "#{line_items.count} line items present"
      return false
    end
  end
end
