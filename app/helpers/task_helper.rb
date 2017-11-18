module TaskHelper
	def calculate_shipping_and_handling(number_of_radios, shipment_priority)
	#        first class   priority  priority express  
	# 1-pack    5.95         12.95      25.95 
	# 2-pack                 7.95       27.95 
	# 3-pack                 8.95       29.95 

	  case shipment_priority
	  when 'economy'
	    # Economy packs over 1 have to go priority due to weight
	    case number_of_radios
	    when 1
	      5.95
	    when 2
	      7.95
	    when 3
	      8.95
	    end
	  when 'priority'
	    case number_of_radios
	    when 1
	      12.95
	    when 2
	      7.95
	    when 3
	      8.95
	    end
	  when 'express'
	    case number_of_radios
	    when 1
	      25.95
	    when 2
	      27.95
	    when 3
	      29.95
	    end
	  end 
	end
end
