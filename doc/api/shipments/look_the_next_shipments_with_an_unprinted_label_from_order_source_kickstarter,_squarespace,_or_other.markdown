# Shipments API

## Look the next shipments with an unprinted label from order_source kickstarter, squarespace, or other

### GET /next_shipment_to_print

This endpoint also respects the priority field on a shipment; returning those shipments with priority: true first.
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /next_shipment_to_print</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 63,
    "tracking_number": "93748896910904960011677211",
    "ship_date": null,
    "shipment_status": "label_created",
    "order_id": 44,
    "priority_processing": true,
    "label_url": "https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf",
    "shipment_priority": "economy"
  },
  "errors": [

  ]
}</pre>
