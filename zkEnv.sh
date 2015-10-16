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
CLASSPATH="/usr/share/java/objectweb-asm/asm.jar:/usr/share/java/antlr.jar:/usr/share/java/avalon-framework-api.jar:/usr/share/java/avalon-logkit.jar:/usr/share/java/cglib.jar:/usr/share/java/checkstyle.jar:/usr/share/java/commons-beanutils.jar:/usr/share/java/commons-cli.jar:/usr/share/java/commons-logging.jar:/usr/share/java/geronimo-jms_1.1_spec.jar:/usr/share/java/guava.jar:/usr/share/java/hamcrest/all.jar:/usr/share/java/hamcrest/core.jar:/usr/share/java/hamcrest/text.jar:/usr/share/java/hamcrest/library.jar:/usr/share/java/hamcrest/generator.jar:/usr/share/java/hamcrest/integration.jar:/usr/share/java/javax.mail/javax.mail.jar:/usr/share/java/jdiff.jar:/usr/share/java/jetty/jetty-security.jar:/usr/share/java/jetty/jetty-xml.jar:/usr/share/java/jetty/websocket-servlet.jar:/usr/share/java/jetty/jetty-rewrite.jar:/usr/share/java/jetty/jetty-jmx.jar:/usr/share/java/jetty/jetty-http.jar:/usr/share/java/jetty/jetty-servlet.jar:/usr/share/java/jetty/jetty-server.jar:/usr/share/java/jetty/jetty-client.jar:/usr/share/java/jetty/jetty-continuation.jar:/usr/share/java/jetty/jetty-jsp.jar:/usr/share/java/jetty/jetty-maven-plugin.jar:/usr/share/java/jetty/jetty-annotations.jar:/usr/share/java/jetty/jetty-util.jar:/usr/share/java/jetty/websocket-client.jar:/usr/share/java/jetty/websocket-common.jar:/usr/share/java/jetty/jetty-proxy.jar:/usr/share/java/jetty/jetty-deploy.jar:/usr/share/java/jetty/websocket-api.jar:/usr/share/java/jetty/jetty-servlets.jar:/usr/share/java/jetty/websocket-server.jar:/usr/share/java/jetty/jetty-plus.jar:/usr/share/java/jetty/jetty-jndi.jar:/usr/share/java/jetty/jetty-util-ajax.jar:/usr/share/java/jetty/jetty-jspc-maven-plugin.jar:/usr/share/java/jetty/jetty-webapp.jar:/usr/share/java/jetty/jetty-jaas.jar:/usr/share/java/jetty/jetty-io.jar:/usr/share/java/jetty/jetty-security.jar:/usr/share/java/jetty/jetty-xml.jar:/usr/share/java/jetty/websocket-servlet.jar:/usr/share/java/jetty/jetty-rewrite.jar:/usr/share/java/jetty/jetty-jmx.jar:/usr/share/java/jetty/jetty-http.jar:/usr/share/java/jetty/jetty-servlet.jar:/usr/share/java/jetty/jetty-server.jar:/usr/share/java/jetty/jetty-client.jar:/usr/share/java/jetty/jetty-continuation.jar:/usr/share/java/jetty/jetty-jsp.jar:/usr/share/java/jetty/jetty-maven-plugin.jar:/usr/share/java/jetty/jetty-annotations.jar:/usr/share/java/jetty/jetty-util.jar:/usr/share/java/jetty/websocket-client.jar:/usr/share/java/jetty/websocket-common.jar:/usr/share/java/jetty/jetty-proxy.jar:/usr/share/java/jetty/jetty-deploy.jar:/usr/share/java/jetty/websocket-api.jar:/usr/share/java/jetty/jetty-servlets.jar:/usr/share/java/jetty/websocket-server.jar:/usr/share/java/jetty/jetty-plus.jar:/usr/share/java/jetty/jetty-jndi.jar:/usr/share/java/jetty/jetty-util-ajax.jar:/usr/share/java/jetty/jetty-jspc-maven-plugin.jar:/usr/share/java/jetty/jetty-webapp.jar:/usr/share/java/jetty/jetty-jaas.jar:/usr/share/java/jetty/jetty-io.jar:/usr/share/java/jetty/jetty-security.jar:/usr/share/java/jetty/jetty-xml.jar:/usr/share/java/jetty/websocket-servlet.jar:/usr/share/java/jetty/jetty-rewrite.jar:/usr/share/java/jetty/jetty-jmx.jar:/usr/share/java/jetty/jetty-http.jar:/usr/share/java/jetty/jetty-servlet.jar:/usr/share/java/jetty/jetty-server.jar:/usr/share/java/jetty/jetty-client.jar:/usr/share/java/jetty/jetty-continuation.jar:/usr/share/java/jetty/jetty-jsp.jar:/usr/share/java/jetty/jetty-maven-plugin.jar:/usr/share/java/jetty/jetty-annotations.jar:/usr/share/java/jetty/jetty-util.jar:/usr/share/java/jetty/websocket-client.jar:/usr/share/java/jetty/websocket-common.jar:/usr/share/java/jetty/jetty-proxy.jar:/usr/share/java/jetty/jetty-deploy.jar:/usr/share/java/jetty/websocket-api.jar:/usr/share/java/jetty/jetty-servlets.jar:/usr/share/java/jetty/websocket-server.jar:/usr/share/java/jetty/jetty-plus.jar:/usr/share/java/jetty/jetty-jndi.jar:/usr/share/java/jetty/jetty-util-ajax.jar:/usr/share/java/jetty/jetty-jspc-maven-plugin.jar:/usr/share/java/jetty/jetty-webapp.jar:/usr/share/java/jetty/jetty-jaas.jar:/usr/share/java/jetty/jetty-io.jar:/usr/share/java/jetty/jetty-security.jar:/usr/share/java/jetty/jetty-xml.jar:/usr/share/java/jetty/websocket-servlet.jar:/usr/share/java/jetty/jetty-rewrite.jar:/usr/share/java/jetty/jetty-jmx.jar:/usr/share/java/jetty/jetty-http.jar:/usr/share/java/jetty/jetty-servlet.jar:/usr/share/java/jetty/jetty-server.jar:/usr/share/java/jetty/jetty-client.jar:/usr/share/java/jetty/jetty-continuation.jar:/usr/share/java/jetty/jetty-jsp.jar:/usr/share/java/jetty/jetty-maven-plugin.jar:/usr/share/java/jetty/jetty-annotations.jar:/usr/share/java/jetty/jetty-util.jar:/usr/share/java/jetty/websocket-client.jar:/usr/share/java/jetty/websocket-common.jar:/usr/share/java/jetty/jetty-proxy.jar:/usr/share/java/jetty/jetty-deploy.jar:/usr/share/java/jetty/websocket-api.jar:/usr/share/java/jetty/jetty-servlets.jar:/usr/share/java/jetty/websocket-server.jar:/usr/share/java/jetty/jetty-plus.jar:/usr/share/java/jetty/jetty-jndi.jar:/usr/share/java/jetty/jetty-util-ajax.jar:/usr/share/java/jetty/jetty-jspc-maven-plugin.jar:/usr/share/java/jetty/jetty-webapp.jar:/usr/share/java/jetty/jetty-jaas.jar:/usr/share/java/jetty/jetty-io.jar:/usr/share/java/jetty/jetty-security.jar:/usr/share/java/jetty/jetty-xml.jar:/usr/share/java/jetty/websocket-servlet.jar:/usr/share/java/jetty/jetty-rewrite.jar:/usr/share/java/jetty/jetty-jmx.jar:/usr/share/java/jetty/jetty-http.jar:/usr/share/java/jetty/jetty-servlet.jar:/usr/share/java/jetty/jetty-server.jar:/usr/share/java/jetty/jetty-client.jar:/usr/share/java/jetty/jetty-continuation.jar:/usr/share/java/jetty/jetty-jsp.jar:/usr/share/java/jetty/jetty-maven-plugin.jar:/usr/share/java/jetty/jetty-annotations.jar:/usr/share/java/jetty/jetty-util.jar:/usr/share/java/jetty/websocket-client.jar:/usr/share/java/jetty/websocket-common.jar:/usr/share/java/jetty/jetty-proxy.jar:/usr/share/java/jetty/jetty-deploy.jar:/usr/share/java/jetty/websocket-api.jar:/usr/share/java/jetty/jetty-servlets.jar:/usr/share/java/jetty/websocket-server.jar:/usr/share/java/jetty/jetty-plus.jar:/usr/share/java/jetty/jetty-jndi.jar:/usr/share/java/jetty/jetty-util-ajax.jar:/usr/share/java/jetty/jetty-jspc-maven-plugin.jar:/usr/share/java/jetty/jetty-webapp.jar:/usr/share/java/jetty/jetty-jaas.jar:/usr/share/java/jetty/jetty-io.jar:/usr/share/java/jetty/jetty-security.jar:/usr/share/java/jetty/jetty-xml.jar:/usr/share/java/jetty/websocket-servlet.jar:/usr/share/java/jetty/jetty-rewrite.jar:/usr/share/java/jetty/jetty-jmx.jar:/usr/share/java/jetty/jetty-http.jar:/usr/share/java/jetty/jetty-servlet.jar:/usr/share/java/jetty/jetty-server.jar:/usr/share/java/jetty/jetty-client.jar:/usr/share/java/jetty/jetty-continuation.jar:/usr/share/java/jetty/jetty-jsp.jar:/usr/share/java/jetty/jetty-maven-plugin.jar:/usr/share/java/jetty/jetty-annotations.jar:/usr/share/java/jetty/jetty-util.jar:/usr/share/java/jetty/websocket-client.jar:/usr/share/java/jetty/websocket-common.jar:/usr/share/java/jetty/jetty-proxy.jar:/usr/share/java/jetty/jetty-deploy.jar:/usr/share/java/jetty/websocket-api.jar:/usr/share/java/jetty/jetty-servlets.jar:/usr/share/java/jetty/websocket-server.jar:/usr/share/java/jetty/jetty-plus.jar:/usr/share/java/jetty/jetty-jndi.jar:/usr/share/java/jetty/jetty-util-ajax.jar:/usr/share/java/jetty/jetty-jspc-maven-plugin.jar:/usr/share/java/jetty/jetty-webapp.jar:/usr/share/java/jetty/jetty-jaas.jar:/usr/share/java/jetty/jetty-io.jar:/usr/share/java/jline.jar:/usr/share/java/jtoaster.jar:/usr/share/java/junit.jar:/usr/share/java/jzlib.jar:/usr/share/java/log4j.jar:/usr/share/java/mockito.jar:/usr/share/java/netty.jar:/usr/share/java/objenesis/objenesis-tck.jar:/usr/share/java/objenesis/objenesis.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/tomcat-servlet-api.jar:/usr/share/java/zookeeper/zookeeper.jar:/usr/share/java/zookeeper/zookeeper-ZooInspector.jar:/usr/share/java/zookeeper/zookeeper-tests.jar:/usr/share/java/zookeeper/zookeeper.jar:/usr/share/java/zookeeper/zookeeper-ZooInspector.jar:/usr/share/java/zookeeper/zookeeper-tests.jar:/usr/share/java/zookeeper/zookeeper.jar:/usr/share/java/zookeeper/zookeeper-ZooInspector.jar:/usr/share/java/zookeeper/zookeeper-tests.jar:/usr/share/java/zookeeper/zookeeper.jar:/usr/share/java/zookeeper/zookeeper-ZooInspector.jar:/usr/share/java/zookeeper/zookeeper-tests.jar:/usr/share/java/zookeeper/zookeeper.jar:/usr/share/java/zookeeper/zookeeper-ZooInspector.jar:/usr/share/java/zookeeper/zookeeper-tests.jar:/usr/share/java/zookeeper/zookeeper.jar:/usr/share/java/zookeeper/zookeeper-ZooInspector.jar:/usr/share/java/zookeeper/zookeeper-tests.jar:/usr/share/java/zookeeper/zookeeper.jar:/usr/share/java/zookeeper/zookeeper-ZooInspector.jar:/usr/share/java/zookeeper/zookeeper-tests.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/api.jar:/usr/share/java/slf4j/slf4j-ext.jar:/usr/share/java/slf4j/slf4j-site.jar:/usr/share/java/slf4j/jcl.jar:/usr/share/java/slf4j/jul-to-slf4j.jar:/usr/share/java/slf4j/ext.jar:/usr/share/java/slf4j/jcl-over-slf4j.jar:/usr/share/java/slf4j/slf4j-migrator.jar:/usr/share/java/slf4j/migrator.jar"
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-api.jar:/usr/share/java/slf4j/site.jar:/usr/share/java/slf4j/jdk14.jar:/usr/share/java/slf4j/slf4j-jcl.jar"

# We use slf4j-log4j12.jar as our logging binding
CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-log4j12.jar"
# These Conflict with slf4j-log4j12.jar
#/usr/share/java/slf4j/slf4j-simple.jar:/usr/share/java/slf4j/simple.jar:
#/usr/share/java/slf4j/slf4j-nop.jar

# Explicitly add the log4j jars (from the log4j.noarch package)
CLASSPATH="$CLASSPATH:/usr/share/java/log4j-1.jar:/usr/share/java/log4j/log4j-core.jar:/usr/share/java/log4j/log4j-api.jar"

# Not required according to https://issues.apache.org/jira/browse/SOLR-2369
# CLASSPATH="$CLASSPATH:/usr/share/java/slf4j/slf4j-jdk14.jar/usr/share/java/slf4j/log4j-over-slf4j.jar"
