# Radios API

## Update a radio to be boxed and attached to a shipment

### PUT /shipments/:shipment_id/radios

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| boxed | Boolean, is this radio boxed? | true |  |
| serial_number | String, radio (speaker) serial number | true |  |
| country_code | String, country code for the radio. One of us, jp, eu | false |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>PUT /shipments/110/radios</pre>

#### Body

<pre>{"boxed":true,"serial_number":"TPRv2.0_1_17647","country_code":"US"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 109,
    "frequency": "84.3",
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_17647",
    "assembly_date": "2017-08-29 14:45:05 -0400",
    "operator": "David Collins",
    "shipment_id": 110,
    "boxed": true,
    "country_code": null
  },
  "errors": [

  ]
}</pre>
