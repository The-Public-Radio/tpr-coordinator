# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/2568/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 2577,
      "frequency": "83.8",
      "pcb_version": "PR9026",
      "serial_number": "TPRv2.0_1_6401",
      "assembly_date": "2017-10-09 23:38:07 -0400",
      "operator": "Edna Windler",
      "shipment_id": 2568,
      "boxed": true,
      "country_code": "US",
      "firmware_version": "firmware_v1",
      "quality_control_status": "passed"
    },
    {
      "id": 2578,
      "frequency": "81.9",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 2568,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    },
    {
      "id": 2579,
      "frequency": "81.9",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 2568,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    }
  ],
  "errors": [

  ]
}</pre>
