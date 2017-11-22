# Radios API

## Look up a single radio

### GET /radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /radios/51</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 51,
    "frequency": "100.2",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_89993",
    "assembly_date": "2017-11-19 17:53:00 -0500",
    "operator": "Kristian Mertz MD",
    "shipment_id": 44,
    "boxed": true,
    "country_code": "US",
    "firmware_version": "firmware_v1",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
