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
      "id": 6735,
      "tracking_number": "9374889691090496840435",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 6121
    },
    {
      "id": 6736,
      "tracking_number": "9374889691090496840435",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 6122
    },
    {
      "id": 6737,
      "tracking_number": "9374889691090496840435",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 6123
    }
  ],
  "errors": [

  ]
}</pre>
