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
      "id": 54,
      "tracking_number": "93748896910904960011677211",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 35,
      "priority_processing": null,
      "label_url": "https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf",
      "shipment_priority": "economy"
    },
    {
      "id": 55,
      "tracking_number": "93748896910904960011677211",
      "ship_date": null,
      "shipment_status": "label_created",
      "order_id": 36,
      "priority_processing": null,
      "label_url": "https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf",
      "shipment_priority": "economy"
    }
  ],
  "errors": [

  ]
}</pre>
