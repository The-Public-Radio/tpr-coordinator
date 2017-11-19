# Orders API

## Lookup orders with a particular order_source

### GET /orders

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| order_source | String, the source for the order; valid values: kickstarter, squarespace, WBEZ, other | true |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /orders?order_source=squarespace</pre>

#### Query Parameters

<pre>order_source: squarespace</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 22,
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
