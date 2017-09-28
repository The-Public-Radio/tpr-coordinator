# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/2328/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 2335,
      "frequency": "94.4",
      "pcb_version": "PR9026",
      "serial_number": "TPRv2.0_1_9478",
      "assembly_date": "2017-09-22 22:03:35 -0400",
      "operator": "Reuben Jast",
      "shipment_id": 2328,
      "boxed": true,
      "country_code": "US",
      "firmware_version": "firmware_v1",
      "quality_control_status": "passed"
    },
    {
      "id": 2336,
      "frequency": "95.3",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 2328,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    },
    {
      "id": 2337,
      "frequency": "95.3",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 2328,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    }
  ],
  "errors": [

  ]
}</pre>
