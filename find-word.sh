#!/bin/bash

WORD=$1
FILE_EXT=$2

if [ -z $FILE_EXT ]; then

  find . -name "*.go" | grep -v "/bin/" | xargs grep --color -Hni "$WORD"
  find . -name "*.sh" | grep -v "/bin/" | xargs grep --color -Hni "$WORD"
  find . -name "*.mod" | grep -v "/bin/" | xargs grep --color -Hni "$WORD"

  find . -name "*.kt" | grep -v "/target/" | xargs grep --color -Hni "$WORD"
  find . -name "*.java" | grep -v "/target/" | xargs grep --color -Hni "$WORD"

  find . -name "*.yaml" | grep -v "/target/" | xargs grep --color -Hni "$WORD"
  find . -name "*.proto" | grep -v "/target/" | xargs grep --color -Hni "$WORD"
  find . -name "*.properties" | grep -v "/target/" | xargs grep --color -Hni "$WORD"
  find . -name "*.json" | grep -v "/target/" | xargs grep --color -Hni "$WORD"
  find . -name "*.xml" | grep -v "/target/" | xargs grep --color -Hni "$WORD"
  find . -name "*.sql" | grep -v "/target/" | xargs grep --color -Hni "$WORD"
  find . -name "*.txt" | grep -v "/target/" | xargs grep --color -Hni "$WORD"
  find . -name "*.csv" | grep -v "/target/" | xargs grep --color -Hni "$WORD"

else

  find . -name "*.$FILE_EXT" | grep -v "/target/" | xargs grep --color -Hni "$WORD"

fi
