# Shipments API

## Look the number of shipments with an unprinted label.

### GET /shipment_label_created_count
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipment_label_created_count</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": {
    "shipment_count": 2
  },
  "error": {
  }
}</pre>
