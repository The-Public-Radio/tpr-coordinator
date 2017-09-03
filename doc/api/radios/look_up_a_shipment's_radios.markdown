# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/706/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 655,
      "frequency": "85.2",
      "pcb_version": "1",
      "serial_number": "TPRv2.0_1_38286",
      "assembly_date": "2017-09-03 12:41:55 -0400",
      "operator": "Elizabeth Perez",
      "shipment_id": 706,
      "boxed": true,
      "country_code": "US"
    },
    {
      "id": 656,
      "frequency": "94.3",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 706,
      "boxed": false,
      "country_code": "US"
    },
    {
      "id": 657,
      "frequency": "94.3",
      "pcb_version": null,
      "serial_number": null,
      "assembly_date": null,
      "operator": null,
      "shipment_id": 706,
      "boxed": false,
      "country_code": "US"
    }
  ],
  "errors": [

  ]
}</pre>
