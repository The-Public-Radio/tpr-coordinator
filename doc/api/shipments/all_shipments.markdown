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
      "id": 133,
      "tracking_number": "93748896910904960078111017",
      "ship_date": "2017-07-28",
      "shipment_status": "shipped",
      "order_id": 125,
      "label_data": "label_data_fixture"
    },
    {
      "id": 134,
      "tracking_number": "93748896910904960078111017",
      "ship_date": null,
      "shipment_status": "created",
      "order_id": 126,
      "label_data": null
    },
    {
      "id": 135,
      "tracking_number": "93748896910904960078111017",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 127,
      "label_data": "label_data_fixture"
    }
  ],
  "errors": [

  ]
}</pre>
