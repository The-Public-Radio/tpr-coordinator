# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/6730/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 6642,
      "frequency": "79.2",
      "pcb_version": "1",
      "serial_number": "TPRv2.0_1_37787",
      "assembly_date": "2017-08-19 17:04:31 -0400",
      "operator": "Michelle Lewis",
      "shipment_id": 6730,
      "boxed": true
    },
    {
      "id": 6643,
      "frequency": "78.8",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 6730,
      "boxed": false
    },
    {
      "id": 6644,
      "frequency": "78.8",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 6730,
      "boxed": false
    }
  ],
  "errors": [

  ]
}</pre>
