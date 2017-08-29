# Shipments API

## Update a shipment&#39;s status

### PUT /shipments/:id

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| tracking_number | String, shipment tracking number | false |  |
| shipment_status | String, shipment tracking number | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>PUT /shipments/%3Aid</pre>

#### Body

<pre>{"tracking_number":"9374889691090496622758","shipment_status":"label_created"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 116,
    "tracking_number": "9374889691090496622758",
    "ship_date": null,
    "shipment_status": "label_created",
    "order_id": 77
  },
  "errors": [

  ]
}</pre>
