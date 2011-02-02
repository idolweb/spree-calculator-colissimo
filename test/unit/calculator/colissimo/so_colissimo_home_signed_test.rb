require File.dirname(__FILE__) +"/../../../test_helper"

class SoColissimoHomeSignedTest < ActiveSupport::TestCase
  def setup
    Spree::ActiveShipping::Config.set(:origin_country => "FR")
    @calculator = Calculator::Colissimo::SoColissimoHomeSigned.new
  end
  
  test "not available for order to italy" do
    @order = orders(:physical_order_zone_a)
    
    assert !@calculator.available?(@order)
  end
  
  test "available for order from france to france" do
    @order = orders(:physical_order_france)
    assert @calculator.available?(@order)
  end
  
  test "not available for order from italy" do
    Spree::ActiveShipping::Config.set(:origin_country => "IT")
    @order = orders(:physical_order_zone_a)
    
    assert !@calculator.available?(@order)
  end
  
  test "not available for order with more than 30K weight" do
    variants(:t_shirt).update_attribute(:weight, 30.1)
    
    @order = orders(:physical_order_france)
    
    assert !@calculator.available?(@order)
  end
  
  COST_BY_WEIGHT = {
    0.25 => 5.60,
    0.5 => 6.35,
    0.75 => 7.04,
    1 => 7.59,
    2 => 8.29,
    3 => 8.99,
    4 => 9.69,
    5 => 10.39,
    6 => 11.09,
    7 => 11.84,
    8 => 12.59,
    9 => 13.34,
    10 => 14.09,
    15 => 15.80,
    30 => 21.20
  }
  
  COST_BY_WEIGHT.each do |weight,cost|
    test "cost for #{weight}" do
      @order = orders(:physical_order_france)
      @order.line_items.first.variant.update_attribute(:weight, weight)
      
      assert_equal (cost * 1.196).round(4), @calculator.compute(@order.line_items).round(4)
    end
  end
  
end
