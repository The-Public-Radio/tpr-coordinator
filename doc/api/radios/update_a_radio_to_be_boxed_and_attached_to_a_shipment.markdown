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

<pre>PUT /shipments/725/radios</pre>

#### Body

<pre>{"boxed":true,"serial_number":"TPRv2.0_1_83382"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 874,
    "frequency": "100.9",
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_83382",
    "assembly_date": "2017-08-20 23:23:04 -0400",
    "operator": "James Cook",
    "shipment_id": 725,
    "boxed": true
  },
  "errors": [

  ]
}</pre>
