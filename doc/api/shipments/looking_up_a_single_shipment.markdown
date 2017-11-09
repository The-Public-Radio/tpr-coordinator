# Shipments API

## Looking up a single shipment

### GET /shipments/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/339</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 339,
    "tracking_number": "93748896910904960079523789",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 329,
    "label_data": "label_data_fixture",
    "priority_processing": null,
    "label_url": null,
    "shipment_priority": "economy"
  },
  "errors": [

  ]
}</pre>
