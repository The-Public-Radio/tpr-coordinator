# Radios API

## Look up a single radio

### GET /radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /radios/2148</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 2148,
    "frequency": "104.1",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_29084",
    "assembly_date": "2017-10-09 23:30:29 -0400",
    "operator": "Desiree Predovic",
    "shipment_id": 2100,
    "boxed": true,
    "country_code": "US",
    "firmware_version": "firmware_v1",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
