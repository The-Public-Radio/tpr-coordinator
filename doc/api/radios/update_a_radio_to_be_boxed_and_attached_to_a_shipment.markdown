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

<pre>PUT /shipments/708/radios</pre>

#### Body

<pre>{"boxed":true,"serial_number":"TPRv2.0_1_40172"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 663,
    "frequency": "94.3",
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_40172",
    "assembly_date": "2017-09-03 12:41:55 -0400",
    "operator": "Elizabeth Perez",
    "shipment_id": 708,
    "boxed": true,
    "country_code": "US"
  },
  "errors": [

  ]
}</pre>
