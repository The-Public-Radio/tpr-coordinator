# Radios API

## Update a radio to be boxed and attached to a shipment

### PUT /radios

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| boxed | Boolean, is this radio boxed? | true |  |
| serial_number | String, radio (speaker) serial number | true |  |
| shipment_id | String, shipment_id that the radio was boxed for | true |  |
| frequency | String, the frequency the that the radio was programed to | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>PUT /radios</pre>

#### Body

<pre>{"boxed":true,"serial_number":"TPRv2.0_1_37787","shipment_id":6732,"frequency":"79.2"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 6650,
    "frequency": "79.2",
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_37787",
    "assembly_date": "2017-08-19 17:04:31 -0400",
    "operator": "Michelle Lewis",
    "shipment_id": 6732,
    "boxed": true
  },
  "errors": [

  ]
}</pre>
