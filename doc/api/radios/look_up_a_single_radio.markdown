# Radios API

## Look up a single radio

### GET /shipments/:shipment_id/radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/6728/radios/6641</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 6641,
    "frequency": "79.2",
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_37787",
    "assembly_date": "2017-08-19 17:04:31 -0400",
    "operator": "Michelle Lewis",
    "shipment_id": 6729,
    "boxed": true
  },
  "errors": [

  ]
}</pre>
