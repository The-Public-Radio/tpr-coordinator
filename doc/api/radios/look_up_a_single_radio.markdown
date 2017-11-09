# Radios API

## Look up a single radio

### GET /radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /radios/394</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 394,
    "frequency": "95.8",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_65093",
    "assembly_date": "2017-11-08 23:49:17 -0500",
    "operator": "Ashlee Senger",
    "shipment_id": 334,
    "boxed": true,
    "country_code": "US",
    "firmware_version": "firmware_v1",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
