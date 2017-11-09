# Radios API

## Update a radio by serial number

### PUT /radios

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| serial_number | String, radio (speaker) serial number | true |  |
| operator | String, paganation page number | false |  |
| boxed | Boolean, is the radio in a box? | false |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>PUT /radios</pre>

#### Body

<pre>{"serial_number":"TPRv2.0_1_58723","operator":"Rowland Sipes","boxed":true}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 403,
    "frequency": null,
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_58723",
    "assembly_date": "2017-11-08 23:49:17 -0500",
    "operator": "Rowland Sipes",
    "shipment_id": null,
    "boxed": true,
    "country_code": null,
    "firmware_version": "firmware_v1",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
