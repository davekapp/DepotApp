class StoreController < ApplicationController
  
  def index
    @products = Product.all
    @time = Time.now.strftime("%H:%M %D")
  end

end
