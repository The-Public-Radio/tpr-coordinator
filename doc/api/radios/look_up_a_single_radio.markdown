# Radios API

## Look up a single radio

### GET /shipments/:shipment_id/radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/106/radios/101</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 101,
    "frequency": "94.0",
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_33390",
    "assembly_date": "2017-08-29 14:45:05 -0400",
    "operator": "David Collins",
    "shipment_id": 107,
    "boxed": true,
    "country_code": "US"
  },
  "errors": [

  ]
}</pre>
