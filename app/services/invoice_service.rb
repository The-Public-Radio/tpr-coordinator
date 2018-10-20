class InvoiceService
  def self.generate_for_retailers
    adapter = QuickbooksAdapter.new

    Retailer.where(generate_invoice: true).all.each do |retailer|
      Rails.logger.info "Generating invoice for #{retailer.name}"

      invoice = Invoice.for_retailer(retailer)

      if invoice
        adapter.create_invoice(invoice)
        invoice.mark_orders_as_invoiced!
      end
    end

    nil
  end
end
