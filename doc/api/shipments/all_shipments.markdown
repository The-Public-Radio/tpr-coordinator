# Shipments API

## All shipments

### GET /shipments
### Request

#### Headers

<pre>Authorization: Bearer myaccesstoken</pre>

#### Route

<pre>GET /shipments</pre>

### Response

#### Headers

<pre>Content-Type: application/json; charset=utf-8</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>{
  "data": [
    {
      "id": 1,
      "tracking_number": "9374889691090496006138",
      "ship_date": "2017-07-27",
      "shipment_status": "created"
    },
    {
      "id": 2,
      "tracking_number": "9374889691090346006029",
      "ship_date": "2017-07-28",
      "shipment_status": "fulfillment"
    },
    {
      "id": 3,
      "tracking_number": "9374889691090496006739",
      "ship_date": "2017-07-29",
      "shipment_status": "shipped"
    }
  ],
  "errors": [

  ]
}</pre>
