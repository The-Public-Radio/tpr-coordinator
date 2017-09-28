# Shipments API

## Look the next shipments with an unprinted label.

### GET /next_shipment_to_print
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
    "id": 143,
    "tracking_number": "93748896910904960078111017",
    "ship_date": null,
    "shipment_status": "label_created",
    "order_id": 135,
    "label_data": "label_data_fixture"
  },
  "errors": [

  ]
}</pre>
