class QuickbooksAdapter
  RADIO_DESCRIPTION = 'Radios'
  SHIP_DESCRIPTION = 'Shipping & Handling'

  def create_invoice(tpr_invoice)
    qbo_invoice = upload_invoice(tpr_invoice)
    upload_and_attach_csv(qbo_invoice, tpr_invoice)
    email_invoice(qbo_invoice)
  end

  private

  def credentials
    @credentials ||= begin
                       credentials = QuickbooksCredential.first
                       credentials.refresh!
                       credentials
                     end
  end

  def invoice_service
    @invoice_service ||= begin
                           service = Quickbooks::Service::Invoice.new
                           service.access_token = credentials.oauth_client
                           service.company_id = credentials.realm_id
                           service
                         end
  end

  def upload_service
    @upload_service ||= begin
                          service = Quickbooks::Service::Upload.new
                          service.access_token = credentials.oauth_client
                          service.company_id = credentials.realm_id
                          service
                        end
  end

  def customer_service
    @customer_service ||= begin
                            service = Quickbooks::Service::Customer.new
                            service.access_token = credentials.oauth_client
                            service.company_id = credentials.realm_id
                            service
                          end
  end

  def upload_invoice(tpr_invoice)
    customer = customer_service.fetch_by_id(tpr_invoice.retailer.quickbooks_customer_id)

    qbo_invoice = Quickbooks::Model::Invoice.new
    qbo_invoice.customer_id = customer.id
    qbo_invoice.bill_email = customer.email_address
    qbo_invoice.txn_date = Date.today

    qbo_invoice.allow_online_credit_card_payment = true

    qbo_invoice.line_items << build_line_item(ENV['QBO_RADIO_ITEM_ID'], RADIO_DESCRIPTION, tpr_invoice.radio_count, Radio::PRICE)
    qbo_invoice.line_items << build_line_item(ENV['QBO_SHIP_ITEM_ID'], SHIP_DESCRIPTION, 1, tpr_invoice.shipping_total)

    invoice_service.create(qbo_invoice)
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

  def upload_and_attach_csv(qbo_invoice, tpr_invoice)
    tmp = Tempfile.new('invoice')
    tmp.write(tpr_invoice.to_csv)
    tmp.close

    meta = Quickbooks::Model::Attachable.new
    today = Date.today
    meta.file_name = "#{tpr_invoice.retailer.source}_#{today.strftime('%Y_%m_%d')}.csv"
    meta.content_type = 'text/csv'
    entity = Quickbooks::Model::BaseReference.new(qbo_invoice.id, type: 'Invoice')
    meta.attachable_ref = Quickbooks::Model::AttachableRef.new(entity)
    meta.attachable_ref.include_on_send = true

    upload_service.upload(tmp.path, 'text/csv', meta)

    tmp.unlink
  end

  def email_invoice(qbo_invoice)
    return unless qbo_invoice.bill_email

    invoice_service.send(qbo_invoice)
  end
end
