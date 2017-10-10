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
      "id": 2573,
      "tracking_number": "93748896910904960041061097",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 2558,
      "label_data": "label_data_fixture"
    },
    {
      "id": 2574,
      "tracking_number": "93748896910904960041061097",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 2559,
      "label_data": null
    },
    {
      "id": 2575,
      "tracking_number": "93748896910904960041061097",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 2560,
      "label_data": "label_data_fixture"
    }
  ],
  "errors": [

  ]
}</pre>
