class InvoiceService
  def self.generate_for_retailers
    Retailer.where(generate_invoice: true).all.each do |retailer|
      Rails.logger.info "Generating invoice for #{retailer.name}"

      invoice = Invoice.for_retailer(retailer)
      invoice_csv = InvoiceCSV.new(invoice.orders)

      adapter = QuickbooksAdapter.new
      adapter.create_invoice(retailer, invoice, invoice_csv)
    end

    nil
  end
end
