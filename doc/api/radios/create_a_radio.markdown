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

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>POST /radios</pre>

#### Body

<pre>{"pcb_version":"1","serial_number":"TPRv2.0_1_83382","operator":"James Cook"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>201 Created</pre>

#### Body

<pre>{
  "data": {
    "id": 872,
    "frequency": null,
    "pcb_version": "1",
    "serial_number": "TPRv2.0_1_83382",
    "assembly_date": "2017-08-20",
    "operator": "James Cook",
    "shipment_id": null,
    "boxed": false
  },
  "errors": [

  ]
}</pre>
