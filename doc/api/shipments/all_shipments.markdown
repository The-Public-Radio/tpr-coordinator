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
      "id": 5699,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 4777
    },
    {
      "id": 5700,
      "tracking_number": "9374889691090496953197",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 4777
    },
    {
      "id": 5701,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 4778
    },
    {
      "id": 5702,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 4778
    },
    {
      "id": 5703,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 4778
    },
    {
      "id": 5704,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 4778
    },
    {
      "id": 5705,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 4778
    },
    {
      "id": 5706,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 4778
    },
    {
      "id": 5707,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 4779
    },
    {
      "id": 5708,
      "tracking_number": "9374889691090496953197",
      "ship_date": null,
      "shipment_status": "fulfillment",
      "order_id": 4779
    }
  ],
  "errors": [

  ]
}</pre>
