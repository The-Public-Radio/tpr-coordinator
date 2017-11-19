# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/45/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 52,
      "frequency": "100.2",
      "pcb_version": "PR9026",
      "serial_number": "TPRv2.0_1_35381",
      "assembly_date": "2017-11-19 17:53:00 -0500",
      "operator": "Kristian Mertz MD",
      "shipment_id": 45,
      "boxed": true,
      "country_code": "US",
      "firmware_version": "firmware_v1",
      "quality_control_status": "passed"
    },
    {
      "id": 53,
      "frequency": "80.2",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 45,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    },
    {
      "id": 54,
      "frequency": "80.2",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 45,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    }
  ],
  "errors": [

  ]
}</pre>
