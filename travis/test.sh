#!/bin/bash

cd "$(dirname "$0")"

cd ../
yuitest=./node_modules/.bin/yuitest

${yuitest} ./javascript/tests/{asserts,core,mock}/*.js
wait

RETVAL=$?
[ $RETVAL -ne 0 ] && exit 1

cd javascript
grover=../node_modules/.bin/grover
echo "Grover: ${grover}"

${grover} --server ./tests/TestRunner.html -S "?autorun=true"

RETVAL=$?
[ $RETVAL -ne 0 ] && exit 1

if [ -n "$TRAVIS" ]; then
    cd ../java
    echo "Setting up Java:"
    TRAVIS_JDK_VERSION=default
    export CLASSPATH=`pwd`/lib
    echo "ClassPath: ${CLASSPATH}"
    echo -n "Java: "
    java -version
    echo -n "Javac: "
    javac -version
    echo "Running Java Tests in Travis"
    ant test
fi