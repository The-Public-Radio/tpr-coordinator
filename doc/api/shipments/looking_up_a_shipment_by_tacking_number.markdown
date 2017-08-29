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

<pre>GET /shipments?tracking_number=9374889691090496622758</pre>

#### Query Parameters

<pre>tracking_number: 9374889691090496622758</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 115,
    "tracking_number": "9374889691090496622758",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 76
  },
  "errors": [

  ]
}</pre>
