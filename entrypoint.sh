#!/bin/sh

set -e

cp /.releaserc /app/.releaserc

semantic-release --ci false
