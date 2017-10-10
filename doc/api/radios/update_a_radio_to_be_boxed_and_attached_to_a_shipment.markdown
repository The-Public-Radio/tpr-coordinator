# Radios API

## Update a radio to be boxed and attached to a shipment

### PUT /shipments/:shipment_id/radios

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| boxed | Boolean, is this radio boxed? | true |  |
| serial_number | String, radio (speaker) serial number | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>PUT /shipments/2571/radios</pre>

#### Body

<pre>{"boxed":true,"serial_number":"TPRv2.0_1_98769"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 2586,
    "frequency": "81.9",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_98769",
    "assembly_date": "2017-10-09 23:38:07 -0400",
    "operator": "Edna Windler",
    "shipment_id": 2571,
    "boxed": true,
    "country_code": "US",
    "firmware_version": "firmware_v1",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
