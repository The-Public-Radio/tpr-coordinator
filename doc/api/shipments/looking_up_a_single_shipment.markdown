# Shipments API

## Looking up a single shipment

### GET /shipments/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/6734</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 6734,
    "tracking_number": "9374889691090496840435",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 6120
  },
  "errors": [

  ]
}</pre>
