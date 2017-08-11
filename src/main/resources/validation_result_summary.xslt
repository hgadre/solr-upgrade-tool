<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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

<xsl:output method="text" version="1.0" encoding="UTF-8" indent="true"/>

<xsl:param name="solrOpVersion" />
<xsl:param name="dryRun" />

<xsl:template match="result">
  <xsl:choose>
    <xsl:when test="/result/incompatibility[contains(level, 'error')]">
      <xsl:text>&#10;</xsl:text>Following configuration errors found:
      <xsl:for-each select="/result/incompatibility[contains(level, 'error')]">
      * <xsl:value-of select="./description"/>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text><xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise><xsl:text>No configuration errors found...&#10;</xsl:text></xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="/result/incompatibility[contains(level, 'warn')]"><xsl:text>&#10;</xsl:text>Following configuration warnings found:
      <xsl:for-each select="/result/incompatibility[contains(level, 'warn')]">
      * <xsl:value-of select="./description"/>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise><xsl:text>No configuration warnings found...&#10;</xsl:text></xsl:otherwise>
  </xsl:choose>

  <xsl:if test="not($dryRun)">
  <xsl:if test="/result/incompatibility[contains(level, 'info') and contains(transform, 'yes')]"><xsl:text>&#10;</xsl:text>Following incompatibilities will be fixed by auto-transformations (using --upgrade command):</xsl:if>
  <xsl:for-each select="/result/incompatibility[contains(level, 'info') and contains(transform, 'yes')]">
    * <xsl:value-of select="./description"/>
  </xsl:for-each>
  <xsl:if test="/result/incompatibility[contains(level, 'info') and contains(transform, 'yes')]"><xsl:text>&#10;</xsl:text></xsl:if>
  </xsl:if>

  <xsl:if test="/result/incompatibility[contains(level, 'info') and contains(transform, 'no')]"><xsl:text>&#10;</xsl:text>Please note that in Solr <xsl:value-of select="$solrOpVersion"/>:</xsl:if>
  <xsl:for-each select="/result/incompatibility[contains(level, 'info') and contains(transform, 'no')]">
    * <xsl:value-of select="./description"/>
  </xsl:for-each>
  <xsl:if test="/result/incompatibility[contains(level, 'info') and contains(transform, 'no')]"><xsl:text>&#10;</xsl:text></xsl:if>
</xsl:template>

</xsl:stylesheet>
