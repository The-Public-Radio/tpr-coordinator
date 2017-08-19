# Orders API

## Looking up a single order

### GET /orders/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /orders/6112</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "id": 6112,
  "first_name": "Spencer",
  "last_name": "Right",
  "address": "123 West 9th St., City, State, USA",
  "order_source": "kickstarter",
  "email": "Spencer.Right@gmail.com"
}</pre>
