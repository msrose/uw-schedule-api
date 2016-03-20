# University of Waterloo Schedule Generator API

# Developing

```
git clone https://github.com/msrose/uw-schedule-api
cd uw-schedule-api
git submodule update --init
bundle
ruby server.rb
```

The server starts at http://localhost:4567

# Documentation

## POST /

Example request body:

```
{"title": "hi", "term": 1165, "colors":["blue"], "course_numbers":[[3565]]}
```
See the [schedule generator](https://github.com/msrose/schedule-generator) for a full explanation of the parameters.

# Deploy to EC2

SSH into the instance and run

```
RACK_ENV=production nohup ruby server.rb > uw-schedule-api.log &
```
