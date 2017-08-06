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
      "id": 11291,
      "tracking_number": "9374889691090496901877",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 8289
    },
    {
      "id": 11292,
      "tracking_number": "9374889691090496901877",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 8290
    },
    {
      "id": 11293,
      "tracking_number": "9374889691090496901877",
      "ship_date": null,
      "shipment_status": "fulfillment",
      "order_id": 8291
    }
  ],
  "errors": [

  ]
}</pre>
