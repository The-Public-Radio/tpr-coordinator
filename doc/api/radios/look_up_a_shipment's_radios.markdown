# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/335/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 395,
      "frequency": "95.8",
      "pcb_version": "PR9026",
      "serial_number": "TPRv2.0_1_98124",
      "assembly_date": "2017-11-08 23:49:17 -0500",
      "operator": "Ashlee Senger",
      "shipment_id": 335,
      "boxed": true,
      "country_code": "US",
      "firmware_version": "firmware_v1",
      "quality_control_status": "passed"
    },
    {
      "id": 396,
      "frequency": "106.4",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 335,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    },
    {
      "id": 397,
      "frequency": "106.4",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 335,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    }
  ],
  "errors": [

  ]
}</pre>
