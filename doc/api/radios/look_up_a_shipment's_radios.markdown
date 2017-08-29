# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/108/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 102,
      "frequency": "94.0",
      "pcb_version": "1",
      "serial_number": "TPRv2.0_1_68834",
      "assembly_date": "2017-08-29 14:45:05 -0400",
      "operator": "David Collins",
      "shipment_id": 108,
      "boxed": true,
      "country_code": "US"
    },
    {
      "id": 103,
      "frequency": "84.3",
      "pcb_version": null,
      "serial_number": "TPRv2.0_1_41230",
      "assembly_date": null,
      "operator": null,
      "shipment_id": 108,
      "boxed": false,
      "country_code": "US"
    },
    {
      "id": 104,
      "frequency": "84.3",
      "pcb_version": null,
      "serial_number": "TPRv2.0_1_49898",
      "assembly_date": null,
      "operator": null,
      "shipment_id": 108,
      "boxed": false,
      "country_code": "US"
    }
  ],
  "errors": [

  ]
}</pre>
