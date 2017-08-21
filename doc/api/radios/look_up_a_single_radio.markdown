# Radios API

## Look up a single radio

### GET /shipments/:shipment_id/radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/721/radios/864</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 864,
    "frequency": "97.3",
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_83382",
    "assembly_date": "2017-08-20 23:23:04 -0400",
    "operator": "James Cook",
    "shipment_id": 722,
    "boxed": true
  },
  "errors": [

  ]
}</pre>
