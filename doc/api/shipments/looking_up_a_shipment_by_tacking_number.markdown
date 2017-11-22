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

<pre>GET /shipments?tracking_number=93748896910904960011677211</pre>

#### Query Parameters

<pre>tracking_number: 93748896910904960011677211</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 53,
    "tracking_number": "93748896910904960011677211",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 34,
    "priority_processing": null,
    "label_url": null,
    "shipment_priority": "economy"
  },
  "errors": [

  ]
}</pre>
