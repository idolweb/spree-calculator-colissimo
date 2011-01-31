require File.dirname(__FILE__) +"/../../test_helper"

class ColissimoTest < ActiveSupport::TestCase
  def setup
    @calculator = Calculator::Colissimo.new
  end
  
  test "weight" do
    @order = orders(:physical_order_zone_a)
    
    assert_equal 0.1, @calculator.weight(@order)
  end
end
