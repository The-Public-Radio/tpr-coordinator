# Shipments API

## Find a shipments that are attached to an order

### GET /shipments?order_id=:order_id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments?order_id=49</pre>

#### Query Parameters

<pre>order_id: 49</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 71,
      "tracking_number": "93748896910904960011677211",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 49,
      "priority_processing": null,
      "label_url": null,
      "shipment_priority": "economy"
    },
    {
      "id": 72,
      "tracking_number": "93748896910904960011677211",
      "ship_date": null,
      "shipment_status": null,
      "order_id": 49,
      "priority_processing": null,
      "label_url": null,
      "shipment_priority": "economy"
    }
  ],
  "errors": [

  ]
}</pre>
