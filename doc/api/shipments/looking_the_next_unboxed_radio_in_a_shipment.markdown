# Shipments API

## Looking the next unboxed radio in a shipment

### GET /shipments/:id/next_radio

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| tracking_number | String, shipment tracking number | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/117/next_radio?tracking_number=9374889691090496622758</pre>

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
    "id": 125,
    "frequency": "84.3",
    "pcb_version": null,
    "serial_number": "TPRv2.0_1_476",
    "assembly_date": null,
    "operator": null,
    "shipment_id": 117,
    "boxed": false,
    "country_code": "US"
  },
  "errors": [

  ]
}</pre>
