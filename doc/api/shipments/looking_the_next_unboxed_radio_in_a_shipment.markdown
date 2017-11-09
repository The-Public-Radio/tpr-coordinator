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

<pre>GET /shipments/363/next_radio?tracking_number=93748896910904960079523789</pre>

#### Query Parameters

<pre>tracking_number: 93748896910904960079523789</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 452,
    "frequency": "106.4",
    "pcb_version": null,
    "serial_number": null,
    "assembly_date": null,
    "operator": null,
    "shipment_id": 363,
    "boxed": false,
    "country_code": "US",
    "firmware_version": null,
    "quality_control_status": null
  },
  "errors": [

  ]
}</pre>
