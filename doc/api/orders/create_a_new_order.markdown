# Orders API

## Create a new order

### POST /orders

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| frequencies | String array, frequencies requested. Each entity in the array corresponds to a single radio | true |  |
| first_name | String, first name for the order | true |  |
| last_name | String, last name for the order | true |  |
| address | String, address where the order should be shipped | true |  |
| order_source | String, where the order came from. Options: kickstarter, squarespace, other | false |  |

### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>POST /orders</pre>

#### Body

<pre>{"order_source":"other","first_name":"Person","last_name":"McPersonson","address":"345 West Way, Brooklyn, NY, 11221","frequencies":["98.3","79.5","79.5","98.3","79.5","79.5","98.3","79.5","79.5","105.6"],"email":"person.mcpersonson@gmail.com"}</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>201 Created</pre>

#### Body

<pre>{
  "id": 650,
  "first_name": "Person",
  "last_name": "McPersonson",
  "address": "345 West Way, Brooklyn, NY, 11221",
  "order_source": "other",
  "email": "person.mcpersonson@gmail.com"
}</pre>
