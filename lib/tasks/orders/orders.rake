namespace :orders do
  desc "Orders tasks"
  task import_orders_from_email: :environment do
  	gmail_client = login_to_gmail
  end

  def login_to_gmail
  	Gmail.connect!(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
  end
end
