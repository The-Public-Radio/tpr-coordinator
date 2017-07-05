# Tuplip - TPR Coordinator API Interface

## Station Flow

1) Worker: tracking nubmer scan

- GET /order/:tracking_number order queried by tracking number
- number of radios returned, stored in Tulip variable

2) Display:
- Tracking number
- Total number of radios
- Current radio
- Ready to scan the first radio

3) Worker: takes new radio, scans serial number
- POST /radios, body has tracking_number, serial_number
- Respose is Radio ID and a frequency, both stored to tulip variables
- Frequency sent to prgraming jig

4) Display:
- Tracking number
- Radio number in shipment
- Frequency

5) Radio is programed

6) Programing Jig / Worker confirms radio is programed
- PUT /radio/:id?programed=true

7) Worker:
- Package up radio

8) Display:
- Return to step 3 and show ready second radio

9) Complete shipment, attach label, put boxes in box etc

10) Scan next label


# GET /shipments/:tracking_number

Response:

Status: 200

Body:
```
{
  "shipment_id": 123,
  "tracking_number": "sometrackingnumberstring",
  "num_radios": 2
}
```

# POST /radio

Body:
```
{
  "tracking_number": "sometrackingnumberstring"
  "radio_serial": "someradioserialstring"
  "radio_batch": "somebatchstring"
  "model": "v2"
}
```

Response:

Status: 202

Body:
```
?????
``

# PUT /radio/:id?programed=true


Tracking number scan
- tracking number stored in Tulip variable
- GET to /orders/:tracking_number
  - Request:
  - Response:
    - Order ID
    - Tracking Number
    - # of radios

Radio serial number scan
- Serial number stored in Tulip variable
- POST to /radio
  - Request Body:
```
{
  "tracking_number": "some_tracking_number",
  "serial": "some_serial_number",
}
```

## Tracking number scan
