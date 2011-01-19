class Calculator::Colissimo::SoColissimoHomeSigned < Calculator::Colissimo
  def self.description
    "So Colissimo - Domicile avec signature"
  end
  
  def compute(line_items)
    order = line_items.first.order
    
    w = weight(order)
    
    ht_price = case w
    when 0..0.25
      5.6
    when 0.25..0.5
      6.35
    when 0.5..0.75
      7.04
    when 0.75..1
      7.59
    when 1..2
      8.29
    when 2..3
      8.99
    when 3..4
      9.69
    when 4..5
      10.39
    when 5..6
      11.09
    when 6..7
      11.84
    when 7..8
      12.59
    when 8..9
      13.34
    when 9..10
      14.09
    when 10..15
      15.80
    when 15..30
      21.20
    end
    
    vat = (Calculator::Vat.default_rates ? Calculator::Vat.default_rates.first.amount : 0)
    
    return ht_price + (vat * ht_price)
  end
end
