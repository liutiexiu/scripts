#!/bin/bash

find . -name *.kt | grep -v "/target/" | xargs grep -i "$1"
find . -name *.java | grep -v "/target/" | xargs grep -i "$1"

