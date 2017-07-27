# Shipments API

## All shipments

### GET /shipments

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| page | String, page number reqested | false |  |
| tracking_number | String, shipment tracking number | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments?tracking_number=9374889691090496006138</pre>

#### Query Parameters

<pre>tracking_number: 9374889691090496006138</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 1,
    "tracking_number": "9374889691090496006138",
    "ship_date": "2017-07-27",
    "shipment_status": "created"
  },
  "errors": [

  ]
}</pre>
