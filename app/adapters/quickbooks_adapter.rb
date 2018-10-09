class QuickbooksAdapter
  RADIO_DESCRIPTION = 'Radios'
  SHIP_DESCRIPTION = 'Shipping & Handling'

  def create_invoice(retailer, invoice, csv)
    created_invoice = upload_invoice(retailer, invoice)
    upload_and_attach_csv(retailer, created_invoice.id, csv)
  end

  private

  def credentials
    @credentials ||= begin
                       credentials = QuickbooksCredential.first
                       credentials.refresh!
                       credentials
                     end
  end

  def upload_invoice(retailer, invoice)
    qbo_invoice = Quickbooks::Model::Invoice.new
    qbo_invoice.customer_id = retailer.quickbooks_customer_id
    qbo_invoice.txn_date = Date.today

    qbo_invoice.line_items << build_line_item(ENV['QBO_RADIO_ITEM_ID'], RADIO_DESCRIPTION, 1, invoice.radio_total)
    qbo_invoice.line_items << build_line_item(ENV['QBO_SHIP_ITEM_ID'], SHIP_DESCRIPTION, 1, invoice.shipping_total)

    service = Quickbooks::Service::Invoice.new
    service.access_token = credentials.oauth_client
    service.company_id = credentials.realm_id
    service.create(qbo_invoice)
  end

  def build_line_item(item_id, description, quantity, unit_price)
    line_item = Quickbooks::Model::InvoiceLineItem.new
    line_item.amount = quantity * unit_price
    line_item.description = description
    line_item.sales_item! do |detail|
      detail.unit_price = unit_price
      detail.quantity = quantity
      detail.item_id = item_id
    end
    line_item
  end

  def upload_and_attach_csv(retailer, invoice_id, csv)
    tmp = Tempfile.new('invoice')
    tmp.write(csv.generate)
    tmp.close

    meta = Quickbooks::Model::Attachable.new
    today = Date.today
    meta.file_name = "#{retailer.source}_#{today.strftime('%Y_%m_%d')}.csv"
    meta.content_type = 'text/csv'
    entity = Quickbooks::Model::BaseReference.new(invoice_id, type: 'Invoice')
    meta.attachable_ref = Quickbooks::Model::AttachableRef.new(entity)
    meta.attachable_ref.include_on_send = true

    upload_service = Quickbooks::Service::Upload.new
    upload_service.access_token = credentials.oauth_client
    upload_service.company_id = credentials.realm_id

    upload_service.upload(tmp.path, 'text/csv', meta)

    tmp.unlink
  end
end
