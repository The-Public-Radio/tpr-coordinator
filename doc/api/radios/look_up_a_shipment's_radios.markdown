# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/10311/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 6349,
      "frequency": "90.5"
    },
    {
      "id": 6350,
      "frequency": "90.5"
    },
    {
      "id": 6351,
      "frequency": "90.5"
    }
  ],
  "errors": [

  ]
}</pre>
