#!/bin/bash

set -e

until mongo mongodb://mongodb; do
  >&2 echo "MongoDB is unavailable"
  sleep 1
done

>&2 echo "MongoDB is up"

mongo mongodb://mongodb --eval 'rs.initiate({
    _id: "rs0", 
    members: [{
      _id: 0,
      host: "mongodb:27017"
    }]
})'