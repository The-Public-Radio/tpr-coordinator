# Shipments API

## Find a shipments that are attached to an order

### GET /shipments?order_id=:order_id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments?order_id=348</pre>

#### Query Parameters

<pre>order_id: 348</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 361,
      "tracking_number": "93748896910904960079523789",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 348,
      "label_data": null,
      "priority_processing": null,
      "label_url": null,
      "shipment_priority": "economy"
    },
    {
      "id": 362,
      "tracking_number": "93748896910904960079523789",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 348,
      "label_data": null,
      "priority_processing": null,
      "label_url": null,
      "shipment_priority": "economy"
    }
  ],
  "errors": [

  ]
}</pre>
