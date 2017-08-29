# TPR Coordinator

[ ![Codeship Status for gabe-ochoa/WhoAmI](https://app.codeship.com/projects/43ec8010-dec2-0134-f6d9-669b3eb0e523/status?branch=master)](https://app.codeship.com/projects/242476)

I cordinate orders.

Rails, rspec, postgres.

# Documentation

This API can be reached at `https://api.thepublicradio.io`.

The API documentation is located in the docs folder. [Click here for the web view](doc/api/index.markdown).

## Generation
To regenerate the documentation or add to it, create new acceptance tests in the `spec/acceptance` folder and run `rake docs:generate`

# Testing

## Setup

Install and start postgres:

`brew install postgresql`

`brew services start postgresql`

Install Docker for Mac:

[Click here for the downloads page](https://store.docker.com/editions/community/docker-ce-desktop-mac)

## Run

```
docker-compose run --rm web bundle exec rspec
```

or 

```
bundle exec rspec
```
