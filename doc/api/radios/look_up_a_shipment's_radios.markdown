# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/2101/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 2149,
      "frequency": "104.1",
      "pcb_version": "PR9026",
      "serial_number": "TPRv2.0_1_5575",
      "assembly_date": "2017-10-09 23:30:29 -0400",
      "operator": "Desiree Predovic",
      "shipment_id": 2101,
      "boxed": true,
      "country_code": "US",
      "firmware_version": "firmware_v1",
      "quality_control_status": "passed"
    },
    {
      "id": 2150,
      "frequency": "98.8",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 2101,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    },
    {
      "id": 2151,
      "frequency": "98.8",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 2101,
      "boxed": false,
      "country_code": "US",
      "firmware_version": null,
      "quality_control_status": null
    }
  ],
  "errors": [

  ]
}</pre>
