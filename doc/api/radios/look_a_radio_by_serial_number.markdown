# Radios API

## Look a radio by serial number

### GET /radios

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| serial_number | String, serial number of a radio | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /radios?serial_number=TPRv2.0_1_21434</pre>

#### Query Parameters

<pre>serial_number: TPRv2.0_1_21434</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 2338,
    "frequency": "94.4",
    "pcb_version": "PR9026",
    "serial_number": "TPRv2.0_1_21434",
    "assembly_date": "2017-09-22 22:03:35 -0400",
    "operator": "Reuben Jast",
    "shipment_id": 2329,
    "boxed": true,
    "country_code": "US",
    "firmware_version": "firmware_v1",
    "quality_control_status": "passed"
  },
  "errors": [

  ]
}</pre>
