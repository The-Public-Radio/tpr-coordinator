namespace :radios do
  desc "Send a daily count of the number of radios that have been made tasks"
  task send_radios_created_today_email: :environment do
    include TaskHelper

    # Get all radios that were created today and have a frequency (only radios attached to orders)
    radio_count = Radio.where("created_at >= ? AND frequency IS NOT ?", (Time.now - 24.hours), nil).count
    emails = ENV['EMAILS_TO_NOTIFY_OF_IMPORT'].split(',')
    emails.each do |email|
      Rails.logger.info("Notifying #{email} of radios ordered today")
      email_params = {
        to: email,
	      subject: "TPR Coordinator: #{radio_count} radios were ordered today",
	      body: "There were #{radio_count} radios ordered today"
      }
    
      TaskHelper.send_email(email_params) 
    end
  end
end