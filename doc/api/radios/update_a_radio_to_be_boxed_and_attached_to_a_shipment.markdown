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

<pre>PUT /shipments/2331/radios</pre>

#### Body

<pre>{"boxed":true,"serial_number":"TPRv2.0_1_8227"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 2344,
    "frequency": "95.3",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_8227",
    "assembly_date": "2017-09-22 22:03:35 -0400",
    "operator": "Reuben Jast",
    "shipment_id": 2331,
    "boxed": true,
    "country_code": "US",
    "firmware_version": null,
    "quality_control_status": null
  },
  "errors": [

  ]
}</pre>
