# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/723/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 865,
      "frequency": "97.3",
      "pcb_version": "1",
      "serial_number": "TPRv2.0_1_83382",
      "assembly_date": "2017-08-20 23:23:04 -0400",
      "operator": "James Cook",
      "shipment_id": 723,
      "boxed": true
    },
    {
      "id": 866,
      "frequency": "100.9",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 723,
      "boxed": false
    },
    {
      "id": 867,
      "frequency": "100.9",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 723,
      "boxed": false
    }
  ],
  "errors": [

  ]
}</pre>
