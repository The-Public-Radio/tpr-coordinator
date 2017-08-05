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
      "id": 10316,
      "tracking_number": "9374889691090496532903",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 7346
    },
    {
      "id": 10317,
      "tracking_number": "9374889691090496532903",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 7347
    },
    {
      "id": 10318,
      "tracking_number": "9374889691090496532903",
      "ship_date": null,
      "shipment_status": "fulfillment",
      "order_id": 7348
    }
  ],
  "errors": [

  ]
}</pre>
