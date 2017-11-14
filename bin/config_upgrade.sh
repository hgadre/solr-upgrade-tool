#!/bin/bash

: ${JAVA_HOME:?"Please configure JAVA_HOME environment variable"}

JVM="java"
SCRIPT_DIR=$(dirname "$0")

PATH="${JAVA_HOME}/bin:${PATH}" ${JVM} $JAVA_OPTS -cp "${SCRIPT_DIR}/lib/*" org.apache.solr.config.upgrade.ConfigUpgradeTool "$@"

