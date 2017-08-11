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

<xsl:template match="schema">
  <xsl:if test="not(./similarity)">
    <incompatibility>
      <level>info</level>
      <jira_number>SOLR-8270, SOLR-8271</jira_number>
      <description>The implicit default Similarity is changed to SchemaSimilarityFactory</description>
      <recommendation>Users who wish to preserve back-compatible behavior should either explicitly configure ClassicSimilarityFactory, or ensure that the luceneMatchVersion for the collection is less then 6.0</recommendation>
      <reindexing>TBD</reindexing>
      <transform>no</transform>
    </incompatibility>
  </xsl:if>
  <xsl:apply-templates select="child::node()"/>
</xsl:template>

<xsl:template match="similarity[@class='solr.DefaultSimilarityFactory']">
    <incompatibility>
      <level>info</level>
      <jira_number>SOLR-8239</jira_number>
      <description>DefaultSimilarityFactory has been removed</description>
      <recommendation>If you currently have DefaultSimilarityFactory explicitly referenced in your schema.xml, edit your config to use the functionally identical ClassicSimilarityFactory</recommendation>
      <reindexing>TBD</reindexing>
      <transform>yes</transform>
    </incompatibility>
</xsl:template>

<xsl:template match="similarity[@class='solr.SchemaSimilarityFactory']">
    <incompatibility>
      <level>info</level>
      <jira_number>SOLR-8261, SOLR-8329 </jira_number>
      <description>SchemaSimilarityFactory has been modified to use BM25Similarity as the default for fieldTypes that do not explicitly declare a Similarity</description>
      <recommendation>The legacy behavior of using ClassicSimilarity as the default will occur if the luceneMatchVersion for the collection is less then 6.0, or the 'defaultSimFromFieldType' configuration option may be used to specify any default of your choosing</recommendation>
      <reindexing>TBD</reindexing>
      <transform>no</transform>
    </incompatibility>
</xsl:template>

</xsl:stylesheet>
