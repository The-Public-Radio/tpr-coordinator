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
      "id": 10831,
      "tracking_number": "9374889691090496772934",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 7866
    },
    {
      "id": 10832,
      "tracking_number": "9374889691090496772934",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 7867
    },
    {
      "id": 10833,
      "tracking_number": "9374889691090496772934",
      "ship_date": null,
      "shipment_status": "fulfillment",
      "order_id": 7868
    }
  ],
  "errors": [

  ]
}</pre>
