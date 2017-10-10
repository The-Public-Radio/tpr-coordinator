# Shipments API

## Find a shipments that are attached to an order

### GET /shipments?order_id=1
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments?order_id=1</pre>

#### Query Parameters

<pre>order_id: 1</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 2121,
      "tracking_number": "93748896910904960072494970",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 2146,
      "label_data": null
    },
    {
      "id": 2122,
      "tracking_number": "93748896910904960072494970",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 2146,
      "label_data": null
    }
  ],
  "errors": [

  ]
}</pre>
