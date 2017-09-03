# Orders API

## All orders

### GET /orders
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /orders</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 657,
      "first_name": "Spencer",
      "last_name": "Right",
      "order_source": "kickstarter",
      "email": "Spencer.Right@gmail.com",
      "street_address_1": "123 West 9th St.",
      "street_address_2": "Apt 4",
      "city": "Brooklyn",
      "state": "NY",
      "postal_code": "11221",
      "country": "US",
      "phone": "123-321-1231"
    },
    {
      "id": 658,
      "first_name": "Spencer",
      "last_name": "Right",
      "order_source": "squarespace",
      "email": "Spencer.Right@gmail.com",
      "street_address_1": "123 West 9th St.",
      "street_address_2": "Apt 4",
      "city": "Brooklyn",
      "state": "NY",
      "postal_code": "11221",
      "country": "US",
      "phone": "123-321-1231"
    }
  ],
  "errors": [

  ]
}</pre>
