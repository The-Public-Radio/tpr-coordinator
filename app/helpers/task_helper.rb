require 'gmail'

module TaskHelper
	attr_reader :gmail_client

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

	def shipment_priority_mapping(priority_string)
		priority_string =	priority_string.downcase
    if priority_string.include?('economy') || priority_string.include?('standard') 
        'economy'
    elsif priority_string.include?('preferred') || priority_string.include?('priority')
        'priority'
    elsif priority_string.include?('express') || priority_string.include?('expedited')
        'express'
    end
  end

  def gmail_client
  	@gmail_client ||= Gmail.connect!(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
  end

  def send_email(email_params)
  	compose_email(email_params).deliver
  end

  def send_reply(email, email_params)
  	# build reply Mail object
  	message = email.reply()
  	# add / overwrite with new parameters
	  email_params.each do |k,v|
			message.send(k, v)
		end
		# send reply
  	gmail_client.deliver(message)
  end

  def compose_email(params)
  	gmail_client.compose do |email|
  		params.each do |k,v|
  			email.send(k, v)
  		end
  	end
  end

  def find_unread_emails
  	gmail_client.inbox.find(:unread)
  end
end
