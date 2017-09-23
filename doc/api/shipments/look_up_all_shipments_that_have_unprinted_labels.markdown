# Shipments API

## Look up all shipments that have unprinted labels

### GET /shipments

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| shipment_status | String, shipment status | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments?shipment_status=label_created</pre>

#### Query Parameters

<pre>shipment_status: label_created</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 2337,
      "tracking_number": "93748896910904960056315635",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 2413,
      "label_data": "label_data_fixture"
    },
    {
      "id": 2338,
      "tracking_number": "93748896910904960056315635",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 2414,
      "label_data": "label_data_fixture"
    }
  ],
  "errors": [

  ]
}</pre>
