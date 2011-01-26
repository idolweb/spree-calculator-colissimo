class Calculator::Colissimo::ColissimoInternationalSigned < Calculator::Colissimo
  # Zones trouvées sur : http://www.emencia.net/fr/ecs/lalogistique/transporteurs/zonescolissimo
  ZONE_A = %w(AT BE CY DE DK EE ES FI GB GG GI GR HU IE IS IT JE LI LT LU LV MT NL NO PT SE SM VA)
  ZONE_B = %w(BG CZ HR MA PL RO RU SI SK TN TR UA)
  ZONE_C = %w(AL BH CA DJ DZ EG GL IL LB SN TF US ZA)
  ZONE_D = %w(AE AG AI AN AQ AR AU BB BO BR BS BZ CL CN CR DM DO EC FJ FK FO GD GF GT HK HN ID IN JP KH KY LA LC MG MH MO MP MR MS MV MX MY NC NF NI NZ PA PE PF PG PH PM PN PR PY QA SA SB SC SG SH ST SV TH TT TV UY VC VE VN VU WS)
  
  # Tarifs trouvés sur : http://www.colissimo.fr/particuliers/envoyer_un_colis/decouvrir_loffre_colissimo/Tarifs_colissimo/att00002941/colis_a4_france_coulok.pdf
  
  def self.description
    "Colissimo - Home delivery"
  end
  
  def available?(object)
    iso = object.ship_address.country.iso
    
    is_in_zone = ZONE_A.include?(iso) || ZONE_B.include?(iso) || ZONE_C.include?(iso) || ZONE_D.include?(iso)
    
    return Spree::ActiveShipping::Config[:origin_country] == "FR" && is_in_zone && weight(object) <= 20
  end
  
  def compute(line_items)
    order = line_items.first.order
    
    w = weight(order)
    iso = order.ship_address.country.iso
    
    ht_price = if ZONE_A.include?(iso)
      compute_zone_a(w)
    elsif ZONE_B.include?(iso)
      compute_zone_b(w)
    elsif ZONE_C.include?(iso)
      compute_zone_c(w)
    elsif ZONE_D.include?(iso)
      compute_zone_d(w)
    end
    
    vat = (Calculator::Vat.default_rates ? Calculator::Vat.default_rates.first.amount : 0)
    
    return ht_price + (vat * ht_price)
  end
  
  def compute_zone_a(weight)
    case weight
    when 0..1
      16.05
    when 1..2
      17.65
    when 2..3
      21.30
    when 3..4
      24.95
    when 4..5
      28.60
    when 5..6
      32.25
    when 6..7
      35.90
    when 7..8
      39.55
    when 8..9
      43.20
    when 9..10
      46.85
    when 10..15
      53.85
    when 15..20
      60.85
    end
  end

  def compute_zone_b(weight)
    case weight
    when 0..1
      19.40
    when 1..2
      21.30
    when 2..3
      25.75
    when 3..4
      30.20
    when 4..5
      34.65
    when 5..6
      39.10
    when 6..7
      43.55
    when 7..8
      48.00
    when 8..9
      52.45
    when 9..10
      56.90
    when 10..15
      67.10
    when 15..20
      77.30
    end
  end
  
  def compute_zone_c(weight)
    case weight
    when 0..1
      22.50
    when 1..2
      30.10
    when 2..3
      39.50
    when 3..4
      48.90
    when 4..5
      58.30
    when 5..6
      67.70
    when 6..7
      77.10
    when 7..8
      86.50
    when 8..9
      95.90
    when 9..10
      105.30
    when 10..15
      128.80
    when 15..20
      152.30
    end
  end
  
  def compute_zone_d(weight)
    case weight
    when 0..1
      25.40
    when 1..2
      38.10
    when 2..3
      50.80
    when 3..4
      63.50
    when 4..5
      76.20
    when 5..6
      88.90
    when 6..7
      101.60
    when 7..8
      114.30
    when 8..9
      127.00
    when 9..10
      139.70
    when 10..15
      164.70
    when 15..20
      189.70
    end
  end
  
end
