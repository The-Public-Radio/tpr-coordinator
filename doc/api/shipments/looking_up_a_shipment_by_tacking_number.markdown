# Shipments API

## Looking up a shipment by tacking number

### GET /shipments

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| tracking_number | String, shipment tracking number | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments?tracking_number=93748896910904960079523789</pre>

#### Query Parameters

<pre>tracking_number: 93748896910904960079523789</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 343,
    "tracking_number": "93748896910904960079523789",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 333,
    "label_data": "label_data_fixture",
    "priority_processing": null,
    "label_url": null,
    "shipment_priority": "economy"
  },
  "errors": [

  ]
}</pre>
