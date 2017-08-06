# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/10826/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 6752,
      "frequency": "90.5"
    },
    {
      "id": 6753,
      "frequency": "90.5"
    },
    {
      "id": 6754,
      "frequency": "90.5"
    }
  ],
  "errors": [

  ]
}</pre>
