# Shipments API

## Update a shipment&#39;s status

### PUT /shipments/:id

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| tracking_number | String, shipment tracking number | false |  |
| shipment_status | String, shipment status | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>PUT /shipments/%3Aid</pre>

#### Body

<pre>{"tracking_number":"93748896910904960072494970","shipment_status":"label_created"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 2120,
    "tracking_number": "93748896910904960072494970",
    "ship_date": null,
    "shipment_status": "label_created",
    "order_id": 2145,
    "label_data": null
  },
  "errors": [

  ]
}</pre>
