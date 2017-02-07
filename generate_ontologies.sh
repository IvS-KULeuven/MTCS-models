#!/bin/bash

echo "TTL to JSON-LD..."
python rdfconvert.py --from n3 --to json-ld -Rf ttl/metamodels/ -o jsonld/metamodels

