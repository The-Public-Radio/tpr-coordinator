# Radios API

## Look up a shipment&#39;s radios

### GET /shipments/:shipment_id/radios
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments/11286/radios</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 7071,
      "frequency": "90.5"
    },
    {
      "id": 7072,
      "frequency": "90.5"
    },
    {
      "id": 7073,
      "frequency": "90.5"
    }
  ],
  "errors": [

  ]
}</pre>
