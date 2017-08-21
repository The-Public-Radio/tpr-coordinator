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
      "id": 727,
      "tracking_number": "9374889691090496510451",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 657
    },
    {
      "id": 728,
      "tracking_number": "9374889691090496510451",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 658
    },
    {
      "id": 729,
      "tracking_number": "9374889691090496510451",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 659
    }
  ],
  "errors": [

  ]
}</pre>
