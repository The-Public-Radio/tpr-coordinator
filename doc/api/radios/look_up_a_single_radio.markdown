# Radios API

## Look up a single radio

### GET /shipments/:shipment_id/radios/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/10309/radios/6348</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "id": 6348,
    "frequency": "90.5"
  },
  "errors": [

  ]
}</pre>
