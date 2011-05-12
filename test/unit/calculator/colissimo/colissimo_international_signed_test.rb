require File.dirname(__FILE__) +"/../../../test_helper"

class ColissimoInternationalSignedTest < ActiveSupport::TestCase
  def setup
    @calculator = Calculator::Colissimo::ColissimoInternationalSigned.new
  end
  
  test "description" do
    assert_not_nil Calculator::Colissimo::ColissimoInternationalSigned.description
  end
  
  test "available for order to italy" do
    @order = orders(:physical_order_zone_a)
    
    assert @calculator.available?(@order)
  end
  
  test "not available for order to france" do
    @order = orders(:physical_order_france)
    
    assert !@calculator.available?(@order)
  end
  
  test "not available for order from italy" do
    Spree::ActiveShipping::Config.set(:origin_country => "IT")
    
    @order = orders(:physical_order_zone_a)
    
    assert !@calculator.available?(@order)
  end
  
  test "not available for order with more than 20K weight" do
    variants(:t_shirt).update_attribute(:weight, 20.1)
    
    @order = orders(:physical_order_zone_a)
    
    assert !@calculator.available?(@order)
  end
  
  ZONE_A_COST_BY_WEIGHT = {
    1.0 => 16.05,
    2.0 => 17.65,
    3.0 => 21.30,
    4.0 => 24.95,
    5.0 => 28.60,
    6.0 => 32.25,
    7.0 => 35.90,
    8.0 => 39.55,
    9.0 => 43.20,
    10.0 => 46.85,
    15.0 => 53.85,
    20.0 => 60.85
  }
  
  ZONE_A_COST_BY_WEIGHT.each do |weight,cost|
    test "zone A < #{weight}" do
      @order = orders(:physical_order_zone_a)
      @order.line_items.first.variant.update_attribute(:weight, weight)
      
      assert_equal (cost * 1.196).round(4), @calculator.compute(@order.line_items).round(4)
    end
  end
  
  ZONE_B_COST_BY_WEIGHT = {
    1.0 => 19.40,
    2.0 => 21.30,
    3.0 => 25.75,
    4.0 => 30.20,
    5.0 => 34.65,
    6.0 => 39.10,
    7.0 => 43.55,
    8.0 => 48.00,
    9.0 => 52.45,
    10.0 => 56.90,
    15.0 => 67.10,
    20.0 => 77.30
  }
  
  ZONE_B_COST_BY_WEIGHT.each do |weight,cost|
    test "zone B < #{weight}" do
      @order = orders(:physical_order_zone_b)
      @order.line_items.first.variant.update_attribute(:weight, weight)
      
      assert_equal (cost * 1.196).round(4), @calculator.compute(@order.line_items).round(4)
    end
  end
  
  ZONE_C_COST_BY_WEIGHT = {
    1.0 => 22.50,
    2.0 => 30.10,
    3.0 => 39.50,
    4.0 => 48.90,
    5.0 => 58.30,
    6.0 => 67.70,
    7.0 => 77.10,
    8.0 => 86.50,
    9.0 => 95.90,
    10.0 => 105.30,
    15.0 => 128.80,
    20.0 => 152.30
  }
  
  ZONE_C_COST_BY_WEIGHT.each do |weight,cost|
    test "zone C < #{weight}" do
      @order = orders(:physical_order_zone_c)
      @order.line_items.first.variant.update_attribute(:weight, weight)
      
      assert_equal (cost * 1.196).round(4), @calculator.compute(@order.line_items).round(4)
    end
  end
  
  ZONE_D_COST_BY_WEIGHT = {
    1.0 => 25.40,
    2.0 => 38.10,
    3.0 => 50.80,
    4.0 => 63.50,
    5.0 => 76.20,
    6.0 => 88.90,
    7.0 => 101.60,
    8.0 => 114.30,
    9.0 => 127.00,
    10.0 => 139.70,
    15.0 => 164.70,
    20.0 => 189.70
  }
             
  ZONE_D_COST_BY_WEIGHT.each do |weight,cost|
    test "zone D < #{weight}" do
      @order = orders(:physical_order_zone_d)
      @order.line_items.first.variant.update_attribute(:weight, weight)
      
      assert_equal (cost * 1.196).round(4), @calculator.compute(@order.line_items).round(4)
    end
  end
  
end
