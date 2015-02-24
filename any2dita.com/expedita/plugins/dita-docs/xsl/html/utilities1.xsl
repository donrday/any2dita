<?xml version="1.0" encoding="UTF-8"?>
<!--
 | Copyright 2010 Don R. Day
 | 
 |    Licensed under the Apache License, Version 2.0 (the "License");
 |    you may not use this file except in compliance with the License.
 |    You may obtain a copy of the License at
 | 
 |        http://www.apache.org/licenses/LICENSE-2.0
 | 
 |    Unless required by applicable law or agreed to in writing, software
 |    distributed under the License is distributed on an "AS IS" BASIS,
 |    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 |    See the License for the specific language governing permissions and
 |    limitations under the License.
 | 
 | Contributed to the expeDITA-cct Content Collaboration Tools Sourceforge project.
 '-->

<!-- Common utilities that can be used by DITA transforms -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- from Mike Brown recommendation, http://www.biglist.com/lists/xsl-list/archives/200008/msg01318.html -->
<!--
	given the info needed to produce a set of candidates ($str),
	pick the best of the bunch:
	1. $str[lang($Lang)][1]
	2. $str[lang($PrimaryLang)][1]
	3. $str[1]
	4. if not($str) then issue warning to STDERR
-->
<xsl:template name="getString">
  <xsl:param name="stringName"/>
  <xsl:variable name="str" select="$StringFile/strings/str[@name=$stringName]"/>
  <xsl:choose>
    <xsl:when test="$str[lang($Lang)]">
      <xsl:value-of select="$str[lang($Lang)][1]"/>
    </xsl:when>
    <xsl:when test="$str[lang($PrimaryLang)]">
      <xsl:value-of select="$str[lang($PrimaryLang)][1]"/>
    </xsl:when>
    <xsl:when test="$str">
      <xsl:value-of select="$str[1]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="no">
        <xsl:text>Warning: no string named '</xsl:text>
        <xsl:value-of select="$stringName"/>
        <xsl:text>' found.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

 <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


<!-- Process standard attributes that may appear anywhere. Previously this was "setclass" -->
<xsl:template name="commonattributes">
  <xsl:param name="default-output-class"/>
  <xsl:apply-templates select="@xml:lang"/>
  <xsl:apply-templates select="@dir"/>
  <!--
  <xsl:apply-templates select="." mode="set-output-class">
    <xsl:with-param name="default" select="$default-output-class"/>
  </xsl:apply-templates>
  -->
</xsl:template>

<xsl:template name="add-user-link-attributes">
  <!-- stub for user values -->
</xsl:template>


<xsl:template name='check-atts'>
	<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
	<xsl:if test="@outputclass"><xsl:attribute name="class"><xsl:value-of select="@outputclass"/></xsl:attribute></xsl:if>
</xsl:template>

<!-- primitive support for @rev = 'v1' -->
<xsl:template name='check-rev'>
<!--
Called for each element.
Build list of properties (associative tables: p:@audience:administrator)
for each attribute
  for each token in the attribute
    compare with each 
-->
	<xsl:if test="@rev = 'v1'">
		<xsl:attribute name="style">background-color:palegreen;</xsl:attribute>
	</xsl:if>
	<xsl:if test="@platform = 'Linux'"> <!-- color action -->
		<xsl:attribute name="style">background-color:pink;</xsl:attribute>
	</xsl:if>
	<xsl:if test="@product = 'extendedprod'"> <!-- exclude action -->
		<xsl:attribute name="style"></xsl:attribute>
	</xsl:if>
<!-- insert images only after attribute adornments -->
	<xsl:if test="@audience = 'administrator'"> <!-- flag action -->
		<img src="{concat($contentDir,'/',$groupName,'/','important.gif')}" title="ADMIN"/>
	</xsl:if>
</xsl:template>

<!-- primitive support for draft_comment -->
<xsl:template match="draft-comment">
	<span style="color:lightgreen;">
	<xsl:apply-templates/>
	</span>
</xsl:template>


</xsl:stylesheet>
