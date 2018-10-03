class ShippingCalculator

  def self.calculate_shipping_and_handling(number_of_radios, shipment_priority)
    #        first class   priority  priority express
    # 1-pack    5.95         12.95      38.45
    # 2-pack                 7.95       38.45
    # 3-pack                 8.95       44.05

    case shipment_priority
    when 'economy'
      # Economy packs over 1 have to go priority due to weight
      case number_of_radios
      when 1 then 5.95
      when 2 then 7.95
      when 3 then 8.95
      end
    when 'priority'
      case number_of_radios
      when 1 then 12.95
      when 2 then 7.95
      when 3 then 8.95
      end
    when 'express'
      case number_of_radios
      when 1 then 38.45
      when 2 then 38.45
      when 3 then 44.05
      end
    end
  end
end
