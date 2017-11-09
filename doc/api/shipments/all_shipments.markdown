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
      "id": 340,
      "tracking_number": "93748896910904960079523789",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 330,
      "label_data": "label_data_fixture",
      "priority_processing": null,
      "label_url": null,
      "shipment_priority": "economy"
    },
    {
      "id": 341,
      "tracking_number": "93748896910904960079523789",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 331,
      "label_data": null,
      "priority_processing": null,
      "label_url": null,
      "shipment_priority": "economy"
    },
    {
      "id": 342,
      "tracking_number": "93748896910904960079523789",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 332,
      "label_data": "label_data_fixture",
      "priority_processing": null,
      "label_url": "https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf",
      "shipment_priority": "economy"
    }
  ],
  "errors": [

  ]
}</pre>
