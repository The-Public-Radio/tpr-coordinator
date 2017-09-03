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
      "id": 710,
      "tracking_number": "9374889691090496601517",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 667
    },
    {
      "id": 711,
      "tracking_number": "9374889691090496601517",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 668
    },
    {
      "id": 712,
      "tracking_number": "9374889691090496601517",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 669
    }
  ],
  "errors": [

  ]
}</pre>
