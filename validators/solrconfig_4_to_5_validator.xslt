<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="true" standalone="yes" />
<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:element name="result">
  <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- identity transform -->
<xsl:template match="@* | node()">
  <xsl:apply-templates select="node() | @*"/>
</xsl:template>

<xsl:template match="indexConfig">
  <xsl:if test="./termIndexInterval">
    <incompatibility>
      <level>info</level> 
      <jira_number>SOLR-6560</jira_number>
      <description>The "termIndexInterval" option is a no-op and should be removed</description>
      <recommendation>TBD</recommendation>
      <reindexing>No</reindexing>
      <transform>yes</transform>
    </incompatibility>
  </xsl:if>

  <xsl:if test="./checkIntegrityAtMerge">
    <incompatibility>
      <level>info</level>
      <jira_number>SOLR-6834</jira_number>
      <description>The "checkIntegrityAtMerge" option is a no-op and should be removed</description>
      <recommendation>TBD</recommendation>
      <reindexing>No</reindexing>
      <transform>yes</transform>
    </incompatibility>
  </xsl:if>

  <xsl:if test="./nrtMode">
    <incompatibility>
      <level>info</level>
      <jira_number>SOLR-6897</jira_number>
      <description>The &lt;nrtMode&gt; configuration has been discontinued and should be removed</description>
      <recommendation>Solr defaults to using NRT searchers and this configuration is not required</recommendation>
      <reindexing>No</reindexing>
      <transform>yes</transform>
    </incompatibility>
  </xsl:if>

  <xsl:apply-templates select="child::node()"/>
</xsl:template>

<xsl:template match="infoStream">
  <xsl:if test="@file">
    <incompatibility>
      <level>error</level> 
      <jira_number>TBD</jira_number>
      <description>The "file" attribute of infoStream element is removed</description>
      <recommendation>Control this via your logging configuration (org.apache.solr.update.LoggingInfoStream) instead</recommendation>
      <reindexing>No</reindexing>
      <transform>no</transform>
    </incompatibility>
  </xsl:if>
  <xsl:apply-templates select="child::node()"/>
</xsl:template>

<xsl:template match="updateRequestProcessorChain">
  <xsl:if test="./processor[@class='org.apache.solr.update.processor.UniqFieldsUpdateProcessorFactory']/lst[@name='fields']">
    <incompatibility>
      <level>info</level>  
      <jira_number>SOLR-4249</jira_number>
      <description>UniqFieldsUpdateProcessorFactory no longer supports the &lt;lst named=&quot;fields&quot;&gt; init param style</description>
      <recommendation>Update your solrconfig.xml to use &lt;arr name=&quot;fieldName&quot;&gt; instead</recommendation>
      <reindexing>No</reindexing>
      <transform>yes</transform>
    </incompatibility>
  </xsl:if>
  <xsl:apply-templates select="child::node()"/>
</xsl:template>

</xsl:stylesheet>
