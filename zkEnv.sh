#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script should be sourced into other zookeeper
# scripts to setup the env variables

# We use ZOOCFGDIR if defined,
# otherwise we use /etc/zookeeper
# or the conf directory that is
# a sibling of this script's directory

ZOOBINDIR="${ZOOBINDIR:-/usr/bin}"
ZOOKEEPER_PREFIX="${ZOOBINDIR}/.."
ZOOCFGDIR="/etc/zookeeper"
ZOO_LOG_DIR="/var/log/zookeeper"

if [ -f "${ZOOCFGDIR}/zookeeper-env.sh" ]; then
  . "${ZOOCFGDIR}/zookeeper-env.sh"
fi

if [ "x$ZOOCFG" = "x" ]
then
    ZOOCFG="zoo.cfg"
fi

ZOOCFG="$ZOOCFGDIR/$ZOOCFG"

if [ -f "$ZOOCFGDIR/java.env" ]
then
    . "$ZOOCFGDIR/java.env"
fi

if [ "x${ZOO_LOG_DIR}" = "x" ]
then
    ZOO_LOG_DIR="."
fi

if [ "x${ZOO_LOG4J_PROP}" = "x" ]
then
    ZOO_LOG4J_PROP="INFO,CONSOLE"
fi

if [ "$JAVA_HOME" != "" ]; then
  JAVA="$JAVA_HOME/bin/java"
else
  JAVA=java
fi

## TSTCLAIR: May need to add jar soup to classpath
#add the zoocfg dir to classpath
CLASSPATH="/usr/share/java/zookeeper/zookeeper.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/zookeeper/zookeeper-ZooInspector.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/zookeeper/zookeeper-tests.jar"

# This section is sorted for easy maintenance
CLASSPATH="$CLASSPATH:/usr/lib/java/jline1/jline-1.0.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/antlr.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/avalon-framework-api.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/avalon-logkit.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/cglib.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/checkstyle.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/commons-beanutils.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/commons-cli.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/commons-logging.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/geronimo-jms_1.1_spec.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/guava.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/hamcrest/all.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/hamcrest/core.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/hamcrest/generator.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/hamcrest/integration.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/hamcrest/library.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/hamcrest/text.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/javax.mail/javax.mail.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jdiff.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-annotations.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-client.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-continuation.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-deploy.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-http.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-io.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-jaas.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-jmx.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-jndi.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-jsp.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-jspc-maven-plugin.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-maven-plugin.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-plus.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-proxy.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-rewrite.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-security.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-server.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-servlet.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-servlets.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-util-ajax.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-util.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-webapp.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/jetty-xml.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/websocket-api.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/websocket-client.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/websocket-common.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/websocket-server.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jetty/websocket-servlet.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jtoaster.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/junit.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/jzlib.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/mockito.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/netty.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/objectweb-asm/asm.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/objenesis/objenesis-tck.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/objenesis/objenesis.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/api.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/ext.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/jcl-over-slf4j.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/jul-to-slf4j.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/migrator.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/site.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-api.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-ext.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-migrator.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-site.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/tomcat-servlet-api.jar"

# We use slf4j-log4j12.jar as our logging binding
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-log4j12.jar"
# These Conflict with slf4j-log4j12.jar
#CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-jcl.jar"
#CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-nop.jar"
#CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-simple.jar"

# Explicitly add the log4j 1.2 jars
CLASSPATH="$CLASSPATH:/usr/share/java/log4j-1.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/log4j.jar"

# Not required according to https://issues.apache.org/jira/browse/SOLR-2369
#CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/log4j-over-slf4j.jar"
#CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-jdk14.jar"
