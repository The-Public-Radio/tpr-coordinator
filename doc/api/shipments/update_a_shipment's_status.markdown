# Shipments API

## Update a shipment&#39;s status

### PUT /shipments

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| tracking_number | String, shipment tracking number | true |  |
| shipment_status | String, shipment tracking number | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>PUT /shipments</pre>

#### Body

<pre>{"tracking_number":"9374889691090496953197","shipment_status":"fulfillment"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 5711,
    "tracking_number": "9374889691090496953197",
    "ship_date": null,
    "shipment_status": "fulfillment",
    "order_id": 4781
  },
  "errors": [

  ]
}</pre>
