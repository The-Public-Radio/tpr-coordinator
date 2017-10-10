# Radios API

## Look up a single radio

### GET /radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /radios/2576</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 2576,
    "frequency": "83.8",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_15920",
    "assembly_date": "2017-10-09 23:38:07 -0400",
    "operator": "Edna Windler",
    "shipment_id": 2567,
    "boxed": true,
    "country_code": "US",
    "firmware_version": "firmware_v1",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
