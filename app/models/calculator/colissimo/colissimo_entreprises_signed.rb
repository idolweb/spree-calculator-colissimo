class Calculator::Colissimo::ColissimoEntreprisesSigned < Calculator::Colissimo
  def self.description
    "Colissimo Entreprises - Livraison contre signature (Expert F)"
  end
  
  def available?(object)
    return Spree::ActiveShipping::Config[:origin_country] == "FR" && object.ship_address.country.iso3 == "FRA"
  end
  
  def compute(line_items)
    order = line_items.first.order
    
    w = weight(order)
    
    ht_price = if w < 0.25
      5.68
    elsif w < 0.5
      6.45
    elsif w < 0.75
      7.14
    elsif w < 1
      7.70
    elsif w < 2
      8.41
    elsif w < 3
      9.13
    elsif w < 4
      9.88
    elsif w < 5
      10.63
    elsif w < 6
      11.38
    elsif w < 7
      12.13
    elsif w < 8
      12.88
    elsif w < 9
      13.63
    elsif w < 10
      14.38
    elsif w < 15
      16.30
    else
      21.90
    end
    
    vat = (Calculator::Vat.default_rates ? Calculator::Vat.default_rates.first.amount : 0)
    
    return ht_price + (vat * ht_price)
  end
end
