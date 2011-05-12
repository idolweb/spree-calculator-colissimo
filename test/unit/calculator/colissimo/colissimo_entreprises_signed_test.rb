require File.dirname(__FILE__) +"/../../../test_helper"

class ColissimoEntreprisesSignedTest < ActiveSupport::TestCase
  def setup
    Spree::ActiveShipping::Config.set(:origin_country => "FR")
    @calculator = Calculator::Colissimo::ColissimoEntreprisesSigned.new
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
  
  test "available for order with more than 30K weight" do
    variants(:t_shirt).update_attribute(:weight, 30.1)
    
    @order = orders(:physical_order_france)
    
    assert !@calculator.available?(@order)
  end
  
  {
    0.1 => 5.68,
    0.3 => 6.45,
    0.6 => 7.14,
    0.9 => 7.70,
    1.5 => 8.41,
    2.5 => 9.13,
    3.5 => 9.88,
    4.5 => 10.63,
    5.5 => 11.38,
    6.5 => 12.13,
    7.5 => 12.88,
    8.5 => 13.63,
    9.5 => 14.38,
    12 => 16.30,
    20 => 21.90,
    40 => 21.90
  }.each do |weight, cost|
    test "cost for #{weight}" do
      @order = orders(:physical_order_france)
      @order.line_items.first.variant.update_attribute(:weight, weight)
    
      assert_equal (cost * 1.196).round(4), @calculator.compute(@order.line_items).round(4)
    end
  end
end
