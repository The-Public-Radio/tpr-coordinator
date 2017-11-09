# Orders API

## Looking up a single order

### GET /orders/:id
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /orders/320</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "id": 320,
  "name": "Lisa Wunsch",
  "order_source": "kickstarter",
  "email": "LisaWunsch@gmail.com",
  "street_address_1": "123 West 9th St.",
  "street_address_2": "Apt 4",
  "city": "Brooklyn",
  "state": "NY",
  "postal_code": "11221",
  "country": "US",
  "phone": "123-321-1231",
  "invoiced": false,
  "reference_number": null
}</pre>
