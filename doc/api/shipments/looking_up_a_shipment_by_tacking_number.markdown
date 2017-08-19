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

<pre>GET /shipments?tracking_number=9374889691090496840435</pre>

#### Query Parameters

<pre>tracking_number: 9374889691090496840435</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 6738,
    "tracking_number": "9374889691090496840435",
    "ship_date": "2017-07-28",
    "shipment_status": "shipped",
    "order_id": 6124
  },
  "errors": [

  ]
}</pre>
