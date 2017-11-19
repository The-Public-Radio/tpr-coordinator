require 'rails_helper'

RSpec.describe TaskHelper, type: :helper do
	context 'calculates the shipping and handling for' do
  	context 'economy shipments with' do
  		let(:shipment_priority) { 'economy' }

	  	specify '1 radio' do
	  		cost = helper.calculate_shipping_and_handling(1, shipment_priority)
	  		expect(cost).to be 5.95
	  	end

	  	specify '2 radios' do
	  		cost = helper.calculate_shipping_and_handling(2, shipment_priority)
	  		expect(cost).to be 7.95
	  	end

	  	specify '3 radios' do
	  		cost = helper.calculate_shipping_and_handling(3, shipment_priority)
	  		expect(cost).to be 8.95
	  	end
	  end

	  context 'priority shipments with' do
  		let(:shipment_priority) { 'priority' }

	  	specify '1 radio' do
	  		cost = helper.calculate_shipping_and_handling(1, shipment_priority)
	  		expect(cost).to be 12.95
	  	end

	  	specify '2 radios' do
	  		cost = helper.calculate_shipping_and_handling(2, shipment_priority)
	  		expect(cost).to be 7.95
	  	end

	  	specify '3 radios' do
	  		cost = helper.calculate_shipping_and_handling(3, shipment_priority)
	  		expect(cost).to be 8.95
	  	end
	  end

	  context 'express shipments with' do
  		let(:shipment_priority) { 'express' }

	  	specify '1 radio' do
	  		cost = helper.calculate_shipping_and_handling(1, shipment_priority)
	  		expect(cost).to be 25.95
	  	end

	  	specify '2 radios' do
	  		cost = helper.calculate_shipping_and_handling(2, shipment_priority)
	  		expect(cost).to be 27.95
	  	end

	  	specify '3 radios' do
	  		cost = helper.calculate_shipping_and_handling(3, shipment_priority)
	  		expect(cost).to be 29.95
	  	end
	  end
  end

  context 'using tprorderprocessing@gmail.com' do
  	it 'logs into gmail' do 
      # Grab configuration
      username = ENV['GMAIL_USERNAME']
      password = ENV['GMAIL_PASSWORD']

      # Assert and return gmail client
      expect(Gmail).to receive(:connect!).with(username, password)

      helper.gmail_client
  	end

  	context 'from tprorderprocessing@gmail.com' do
      let(:stub_gmail_client) { double('gmail', deliver: false ) }
      let(:to) { 'foo@bar.com' }
      let(:subject) { 'test subject' }
      let(:body) { 'test body' }
      let(:attachment) { 'test/csv.csv' }
      let(:email) { double('email') }
      let(:email_params) do
      	email_params = {
					to: to,
  				subject: subject,
  				body: body,
  				add_file: attachment
  			}
      end

  		it 'composes and sends emails from parameters' do  			
  			assert_gmail_connect
  			expect(stub_gmail_client).to receive(:compose).and_return(email) # with(email_params)
  			expect(email).to receive(:deliver)

  			helper.send_email(email_params)
  		end

  		it 'composes emails from parameters' do
  			assert_gmail_connect
  			expect(stub_gmail_client).to receive(:compose).and_yield(email)
  			expect(email).to receive(:to).with(to)
  			expect(email).to receive(:subject).with(subject)
  			expect(email).to receive(:body).with(body)
  			expect(email).to receive(:add_file).with(attachment)

  			helper.compose_email(email_params)
  		end

  		it 'finds and returns unread emails' do
  			stub_inbox = double('inbox')
  			assert_gmail_connect
  			expect(stub_gmail_client).to receive(:inbox).and_return(stub_inbox)
  			expect(stub_inbox).to receive(:find).with(:unread)

  			helper.find_unread_emails
  		end

  		it 'replies to emails' do
  			reply_email = 'foo@bar.com'
  			reply_message = Mail.new 
  			assert_gmail_connect
  			expect(stub_gmail_client).to receive(:deliver).with(reply_message)
  			expect(email).to receive(:reply).and_return(reply_message)
  			expect(reply_message).to receive(:to).with(reply_email)

  			helper.send_reply(email, { to: reply_email })
  		end

  		def assert_gmail_connect
  			expect(Gmail).to receive(:connect!).and_return(stub_gmail_client)
  		end
  	end
  end

  context 'returns a shipment_priority of' do
  	context 'economy' do
	  	let(:priority) { 'economy' }

	  	it 'when given Standard' do
	  		returned_priority = shipment_priority_mapping('Standard and stuff')
	  		expect(returned_priority).to eq priority
	  	end

	  	it 'when given Economy' do
	  		returned_priority = shipment_priority_mapping('stuff and Economy')
	  		expect(returned_priority).to eq priority
	  	end
	  end

	  context 'priority' do
	  	let(:priority) { 'priority' }

	  	it 'when given Preferred' do
	  		returned_priority = shipment_priority_mapping('Preferred')
	  		expect(returned_priority).to eq priority
	  	end

	  	it 'when given Priority' do
	  		returned_priority = shipment_priority_mapping('Priority')
	  		expect(returned_priority).to eq priority
	  	end
	  end

	  context 'express' do
	  	let(:priority) { 'express' }

	  	it 'when given Express' do
	  		returned_priority = shipment_priority_mapping('Express')
	  		expect(returned_priority).to eq priority
	  	end

	  	it 'when given Expedited' do
	  		returned_priority = shipment_priority_mapping('Expedited')
	  		expect(returned_priority).to eq priority
	  	end
	  end
  end
end
