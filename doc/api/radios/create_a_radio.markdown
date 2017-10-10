# Radios API

## Create a radio

### POST /radios

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| frequency | String, frequency for the radio | false |  |
| pcb_version | String, PCB revision | false |  |
| serial_number | String, radio (speaker) serial number | false |  |
| operator | String, paganation page number | false |  |
| country_code | String, country code for the radio. One of us, jp, eu | false |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>POST /radios</pre>

#### Body

<pre>{"pcb_version":"1","serial_number":"TPRv2.0_1_81667","operator":"Candida Mraz","country_code":"US"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>201 Created</pre>

#### Body

<pre>{
  "data": {
    "id": 2156,
    "frequency": null,
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_81667",
    "assembly_date": "2017-10-09",
    "operator": "Candida Mraz",
    "shipment_id": null,
    "boxed": false,
    "country_code": "US",
    "firmware_version": null,
    "quality_control_status": null
  },
  "errors": [

  ]
}</pre>
