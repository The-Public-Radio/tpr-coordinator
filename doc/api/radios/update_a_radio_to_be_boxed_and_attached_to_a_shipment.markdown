# Radios API

## Update a radio to be boxed and attached to a shipment

### PUT /shipments/:shipment_id/radios

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| boxed | Boolean, is this radio boxed? | true |  |
| serial_number | String, radio (speaker) serial number | true |  |
| operator | String, Operator who boxed the radio | false |  |
| firmware_version | String, Firmware version of the radio | false |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>PUT /shipments/48/radios</pre>

#### Body

<pre>{"boxed":true,"serial_number":"TPRv2.0_1_60088","operator":"Nikko Lowe","firmware_version":"firmware_v2"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 62,
    "frequency": "80.2",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_60088",
    "assembly_date": "2017-11-19 17:53:00 -0500",
    "operator": "Nikko Lowe",
    "shipment_id": 48,
    "boxed": true,
    "country_code": "US",
    "firmware_version": "firmware_v2",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
