# Orders API

## Looking up a single order

### GET /orders/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /orders/117</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "id": 117,
  "name": "Trevor Maggio",
  "order_source": "kickstarter",
  "email": "TrevorMaggio@gmail.com",
  "street_address_1": "123 West 9th St.",
  "street_address_2": "Apt 4",
  "city": "Brooklyn",
  "state": "NY",
  "postal_code": "11221",
  "country": "US",
  "phone": "123-321-1231"
}</pre>
