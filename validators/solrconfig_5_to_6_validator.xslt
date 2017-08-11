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

<xsl:template match="config">
  <xsl:if test="not(./schemaFactory)">
    <incompatibility>
      <level>info</level>
      <jira_number>TBD</jira_number>
      <description>The implicit default schema factory is changed from ClassicIndexSchemaFactory to ManagedIndexSchemaFactory. This means that the Schema APIs ( /&lt;collection&gt;/schema ) are enabled and the schema is mutable.</description>
      <recommendation>Users who wish to preserve back-compatible behavior should either explicitly configure schemaFactory to use ClassicIndexSchemaFactory, or ensure that the luceneMatchVersion for the collection is less then 6.0</recommendation>
      <reindexing>no</reindexing>
      <transform>no</transform>
    </incompatibility>
  </xsl:if>
  <xsl:apply-templates select="child::node()"/>
</xsl:template>

<xsl:template match="schemaFactory">
  <xsl:message>Parent is : <xsl:value-of select="name(..)" /></xsl:message>
</xsl:template>

<xsl:template match="indexConfig">
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

</xsl:stylesheet>
