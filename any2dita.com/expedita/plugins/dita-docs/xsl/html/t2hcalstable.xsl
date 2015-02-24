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
<xsl:stylesheet
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:lookup="http://yourdomain.com/lookup"
    extension-element-prefixes="lookup"
>


	
		<!-- drd:  to html editors 
	<table frame="all" id="S0036D47F">
	-->
<xsl:template match='*[contains(@class," topic/table ")]'>
	<div class='table'>
		<xsl:if test='@frame'><!-- if converting from HTML table to simpletable, this would be implicit, thus unnecessary-->
			<xsl:attribute name='frame'><xsl:value-of select='@frame'/></xsl:attribute>
		</xsl:if>
		<xsl:if test='@id'>
			<xsl:attribute name='id'><xsl:value-of select='@id'/></xsl:attribute>
		</xsl:if>
		<table border="1" style="border:thin #ccffff solid;border-collapse:collapse;">
			<xsl:apply-templates select='title'/>
			<xsl:apply-templates select='desc'/>
			<xsl:apply-templates select='tgroup'/>
		</table>
	</div>
</xsl:template>

<xsl:template match='*[contains(@class," topic/table ")]/*[contains(@class," topic/title ")]'>
	<caption><xsl:apply-templates/></caption>
</xsl:template>

<xsl:template match='*[contains(@class," topic/tgroup ")]'>
	<tgroup>
		<xsl:if test='@colsep'>
			<xsl:attribute name='colsep'><xsl:value-of select='@colsep'/></xsl:attribute>
		</xsl:if>
		<xsl:if test='@cols'>
			<xsl:attribute name='cols'><xsl:value-of select='@cols'/></xsl:attribute>
		</xsl:if>
		<xsl:apply-templates/>
	</tgroup>
</xsl:template>

<!-- for some reason, colspecs are nesting and tgroup shows up out of sequence. -->
	<xsl:template match='*[contains(@class," topic/colspec ")]'>
		<colspec>
			<xsl:copy-of select="@*"/>
		</colspec>
<!--
    <xsl:for-each select="colspec">
      <colgroup>
        <xsl:attribute name='align'>center</xsl:attribute>
      </colgroup>
    </xsl:for-each>
-->
	</xsl:template>
 
	<xsl:template match='*[contains(@class," topic/thead ")]'>
		<thead><xsl:apply-templates mode='thead'/></thead>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/tbody ")]'>
		<tbody><xsl:apply-templates mode='tbody'/></tbody>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/row ")]' mode='thead'>
		<tr>
			<xsl:apply-templates mode='thead'/>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/row ")]' mode='tbody'>
		<tr>
			<xsl:apply-templates mode='tbody'/>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/entry ")]' mode='thead'>
		<th>
			<xsl:apply-templates/>
		</th>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/entry ")]' mode='tbody'>
		<td>
			<xsl:apply-templates/>
		</td>
	</xsl:template>


</xsl:stylesheet>