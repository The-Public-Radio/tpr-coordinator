# Shipments API

## Looking up a single shipment

### GET /shipments/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/2572</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 2572,
    "tracking_number": "93748896910904960041061097",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 2557,
    "label_data": "label_data_fixture"
  },
  "errors": [

  ]
}</pre>
