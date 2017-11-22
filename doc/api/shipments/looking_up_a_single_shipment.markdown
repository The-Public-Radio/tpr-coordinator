# Shipments API

## Looking up a single shipment

### GET /shipments/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/49</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 49,
    "tracking_number": "93748896910904960011677211",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 30,
    "priority_processing": null,
    "label_url": null,
    "shipment_priority": "economy"
  },
  "errors": [

  ]
}</pre>
