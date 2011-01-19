class Calculator::Colissimo < Calculator
  def self.register
    super
    ShippingMethod.register_calculator(self)
    ShippingRate.register_calculator(self)
  end
  
  def weight(order)
    weight = order.line_items.inject(0) do |weight, line_item|
      weight + (line_item.variant.weight ? (line_item.quantity * line_item.variant.weight * multiplier) : 0)
    end
  end
end