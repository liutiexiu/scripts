#!/bin/bash

find . -name *.kt | grep -v "/target/" | xargs grep -Hni "$1"
find . -name *.java | grep -v "/target/" | xargs grep -Hni "$1"

find . -name *.properties | grep -v "/target/" | xargs grep -Hni "$1"
find . -name *.json | grep -v "/target/" | xargs grep -Hni "$1"

