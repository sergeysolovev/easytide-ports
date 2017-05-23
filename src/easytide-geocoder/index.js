#!/usr/bin/env node
const NodeGeocoder = require('node-geocoder');
const parse = require('csv-parse/lib/sync');
const stringify = require('csv-stringify');

const geocoder = NodeGeocoder({
  provider: 'google',
  httpAdapter: 'https',
  apiKey: '',
  formatter: null
});

const inputCsv = process.argv[2];
const record = parse(inputCsv)[0];
const name = record[1];
geocoder.geocode(name, (err, results) => {
  if (err) {
    process.stdout.write(err.message);
    process.exit(1);
  }
  firstMatch = results[0];
  let input;
  if (results.length > 0) {
    input = [ [
      record[0],
      record[1],
      record[2],
      firstMatch.formattedAddress,
      firstMatch.latitude,
      firstMatch.longitude,
      firstMatch.city,
      firstMatch.country,
      'done'
    ] ];
  } else {
    record[8] = 'not_found';
    input = [record];
  }
  stringify(input, (err, output) => process.stdout.write(output))
});
