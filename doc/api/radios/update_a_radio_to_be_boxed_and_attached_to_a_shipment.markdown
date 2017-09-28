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

<pre>PUT /shipments/131/radios</pre>

#### Body

<pre>{"boxed":true,"serial_number":"TPRv2.0_1_15211"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 128,
    "frequency": "105.0",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_15211",
    "assembly_date": "2017-09-27 21:19:55 -0400",
    "operator": "Kennith Strosin",
    "shipment_id": 131,
    "boxed": true,
    "country_code": "US",
    "firmware_version": null,
    "quality_control_status": null
  },
  "errors": [

  ]
}</pre>
