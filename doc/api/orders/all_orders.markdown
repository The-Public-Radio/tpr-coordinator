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
      "id": 19,
      "name": "Marques Anderson",
      "order_source": "kickstarter",
      "email": "MarquesAnderson@gmail.com",
      "street_address_1": "123 West 9th St.",
      "street_address_2": "Apt 4",
      "city": "Brooklyn",
      "state": "NY",
      "postal_code": "11221",
      "country": "US",
      "phone": "123-321-1231",
      "invoiced": false,
      "reference_number": null,
      "comments": null
    },
    {
      "id": 20,
      "name": "Marques Anderson",
      "order_source": "squarespace",
      "email": "MarquesAnderson@gmail.com",
      "street_address_1": "123 West 9th St.",
      "street_address_2": "Apt 4",
      "city": "Brooklyn",
      "state": "NY",
      "postal_code": "11221",
      "country": "US",
      "phone": "123-321-1231",
      "invoiced": false,
      "reference_number": null,
      "comments": null
    }
  ],
  "errors": [

  ]
}</pre>
