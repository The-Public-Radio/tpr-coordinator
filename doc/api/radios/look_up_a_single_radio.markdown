# Radios API

## Look up a single radio

### GET /radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /radios/118</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 118,
    "frequency": "89.4",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_83316",
    "assembly_date": "2017-09-27 21:19:55 -0400",
    "operator": "Kennith Strosin",
    "shipment_id": 127,
    "boxed": true,
    "country_code": "US",
    "firmware_version": "firmware_v1",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
