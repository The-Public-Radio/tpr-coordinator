# Radios API

## Look up a single radio

### GET /shipments/:shipment_id/radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/704/radios/654</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 654,
    "frequency": "85.2",
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_45393",
    "assembly_date": "2017-09-03 12:41:55 -0400",
    "operator": "Elizabeth Perez",
    "shipment_id": 705,
    "boxed": true,
    "country_code": "US"
  },
  "errors": [

  ]
}</pre>
