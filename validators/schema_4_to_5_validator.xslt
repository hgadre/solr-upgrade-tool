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

<xsl:template match="fieldType">
  <xsl:if test="@class='solr.SortableIntField'
                or @class='solr.SortableLongField'
                or @class='solr.SortableFloatField'
                or @class='solr.SortableDoubleField'
                or @class='solr.DateField'
                or @class='solr.IntField'
                or @class='solr.LongField'
                or @class='solr.FloatField'
                or @class='solr.DoubleField'
                or @class='solr.BCDIntField'
                or @class='solr.BCDLongField'
                or @class='solr.BCDStrField'">
    <incompatibility>
      <level>error</level> 
      <jira_number>SOLR-5936</jira_number>
      <description>Legacy field type (name = <xsl:value-of select="attribute::name"/> and class = <xsl:value-of select="attribute::class"/>) is removed.</description>
      <recommendation>TBD</recommendation>
      <reindexing>Required</reindexing>
      <transform>no</transform> 
    </incompatibility>
  </xsl:if>

  <xsl:if test="(@class='solr.SpatialRecursivePrefixTreeFieldType'
                 or @class='solr.SpatialPointVectorFieldType'
                 or @class='solr.BBoxField') and @units">
    <warning>
      <level>error</level>
      <jira_number>SOLR-6797</jira_number>
      <description>'units' attribute for spatial field type (name = <xsl:value-of select="attribute::name"/> and class = <xsl:value-of select
="attribute::class"/>) is deprecated</description>
      <recommendation>
        Spatial fields originating from Solr 4 (e.g. SpatialRecursivePrefixTreeFieldType, BBoxField)
        have the 'units' attribute deprecated, now replaced with 'distanceUnits'.  If you change it to
        a unit other than 'degrees' (or if you don't specify it, which will default to kilometers if
        geo=true), then be sure to update maxDistErr as it's in those units.  If you keep units=degrees
        then it should be backwards compatible but you'll get a deprecation warning on startup.
      </recommendation>
      <reindexing>Required</reindexing>
      <transform>no</transform>
    </warning>
  </xsl:if>

  <xsl:apply-templates select="child::node()"/>
</xsl:template>

<xsl:template match="filter">
  <xsl:if test="@class='solr.BeiderMorseFilterFactory' and //field/@type=../../@name">
    <incompatibility>
      <level>info</level>
      <jira_number>LUCENE-6058</jira_number>
      <description>Users of the BeiderMorseFilterFactory will need to rebuild their indexes after upgrading</description>
      <recommendation>
        Due to changes in the underlying commons-codec package, users of the BeiderMorseFilterFactory will need to rebuild their indexes after upgrading.
      </recommendation>
      <reindexing>Required</reindexing>
      <transform>no</transform>
    </incompatibility>
  </xsl:if>

  <xsl:if test="@class='solr.LegacyHTMLStripCharFilter'">
    <incompatibility>
      <level>error</level>
      <jira_number>TODO</jira_number>
      <description>LegacyHTMLStripCharFilter has been removed</description>
      <recommendation>TBD</recommendation>
      <reindexing>Required</reindexing>
      <transform>no</transform>
    </incompatibility>
  </xsl:if>

  <xsl:apply-templates select="child::node()"/>
</xsl:template>

</xsl:stylesheet>
