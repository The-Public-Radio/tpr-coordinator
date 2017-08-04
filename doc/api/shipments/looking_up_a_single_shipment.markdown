# Shipments API

## Looking up a single shipment

### GET /shipments/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/5698</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 5698,
    "tracking_number": "9374889691090496953197",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 4776
  },
  "errors": [

  ]
}</pre>
