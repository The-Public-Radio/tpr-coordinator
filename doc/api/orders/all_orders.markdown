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
      "id": 6110,
      "first_name": "Spencer",
      "last_name": "Right",
      "address": "123 West 9th St., City, State, USA",
      "order_source": "kickstarter",
      "email": "Spencer.Right@gmail.com"
    },
    {
      "id": 6111,
      "first_name": "Spencer",
      "last_name": "Right",
      "address": "123 West 9th St., City, State, USA",
      "order_source": "squarespace",
      "email": "Spencer.Right@gmail.com"
    }
  ],
  "errors": [

  ]
}</pre>
