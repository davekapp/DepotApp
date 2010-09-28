Order.transaction do
  (1..100).each do |i|
    Order.create( :name => "Customer_#{i}", :address => "#{i} Main Street",
                  :email => "mr_or_mrs#{i}@example.com", :pay_type => "Check" )
  end
end