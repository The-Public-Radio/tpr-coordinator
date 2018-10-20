namespace :invoices do
  desc "send all invoices"
  task send_all: :environment do
    InvoiceService.generate_for_retailers
  end
end
