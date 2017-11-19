# Shipments API

## All shipments

### GET /shipments
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 50,
      "tracking_number": "93748896910904960011677211",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 31,
      "priority_processing": null,
      "label_url": null,
      "shipment_priority": "economy"
    },
    {
      "id": 51,
      "tracking_number": "93748896910904960011677211",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 32,
      "priority_processing": null,
      "label_url": null,
      "shipment_priority": "economy"
    },
    {
      "id": 52,
      "tracking_number": "93748896910904960011677211",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 33,
      "priority_processing": null,
      "label_url": "https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf",
      "shipment_priority": "economy"
    }
  ],
  "errors": [

  ]
}</pre>
