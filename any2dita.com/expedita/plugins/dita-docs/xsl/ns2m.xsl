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
<xsl:stylesheet version='1.0'
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

	<xsl:output method="xml"
            encoding="utf-8"
            indent="yes"
            doctype-public="-//OASIS//DTD DITA Map//EN"
            doctype-system="../dtd/map.dtd"
			/>

	<xml:strip-space elements="*"/>
 
 	<xsl:template match='/'>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- process the map's title by fall through -->
	<xsl:template match='ol[contains(@class,"sortable")]'>
		<map>
			<!-- generate id if extant -->
			<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<!-- generate title if extant -->
			<xsl:if test="@data-title">
				<title><xsl:value-of select="@data-title"/></title>
			</xsl:if>
			<!-- fall through -->
			<xsl:apply-templates/>
		</map>
	</xsl:template>

	<xsl:template match='li[@data-class = "topichead"]'>
		<topichead>
			<xsl:variable name="navtitle"><xsl:value-of select="div/span[@data-type = 'navtitle']"/></xsl:variable>
			<xsl:variable name="href"><xsl:value-of select="div/a/@href"/></xsl:variable>
			<xsl:variable name="filename"><xsl:value-of select="div/span[@data-type = 'path']"/></xsl:variable>
			<xsl:if test="a/@id">
				<xsl:attribute name="id"><xsl:value-of select="a/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="navtitle">
			  <xsl:value-of select="$navtitle"/>
			</xsl:attribute>
			
			<xsl:apply-templates/>
		</topichead>
	</xsl:template>

	<xsl:template match='li[@data-class = "topicgroup"]'>
		<topicgroup>
			<xsl:variable name="navtitle"><xsl:value-of select="div/a"/></xsl:variable>
			<xsl:variable name="href"><xsl:value-of select="div/a/@href"/></xsl:variable>
			<xsl:variable name="filename"><xsl:value-of select="div/span[@data-type = 'path']"/></xsl:variable>
			<xsl:if test="a/@id">
				<xsl:attribute name="id"><xsl:value-of select="a/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="navtitle">
			  <xsl:value-of select="$navtitle"/>
			</xsl:attribute>
			
			<xsl:apply-templates/>
		</topicgroup>
	</xsl:template>

	<xsl:template match='li[@data-class = "topicref"]'>
		<topicref>
			<xsl:variable name="navtitle"><xsl:value-of select="div/a"/></xsl:variable>
			<xsl:variable name="filename"><xsl:value-of select="div/a/@href"/></xsl:variable>
			<xsl:variable name="href"><xsl:value-of select="div/span[@data-type = 'path']"/></xsl:variable>
			<xsl:variable name="type"><xsl:value-of select="div/span[@data-type = 'type']"/></xsl:variable>
			<xsl:if test="a/@id">
				<xsl:attribute name="id"><xsl:value-of select="a/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="not($type = '')">
				<xsl:attribute name="type"><xsl:value-of select="$type"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="navtitle">
			  <xsl:value-of select="$navtitle"/>
			</xsl:attribute>
			<xsl:attribute name="href">
			  <xsl:value-of select="$href"/>
			</xsl:attribute>
			<!--
			<xsl:attribute name="query">
			  <xsl:value-of select="$filename"/>
			</xsl:attribute>
			-->
			
			<xsl:apply-templates/>
			<xsl:if test='a/@target'>
				<xsl:attribute name='scope'>
					<xsl:choose>
						<xsl:when test='a/@target="external"'>external</xsl:when><!-- case of simple mapping from original-->
						<xsl:when test='a/@target="_new"'>external</xsl:when>
						<xsl:when test='a/@target="_blank"'>external</xsl:when>
						<xsl:when test='a/@target = ""'>local</xsl:when>
						<xsl:otherwise><xsl:value-of select="a/@target"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>

		</topicref>
	</xsl:template>

	<!-- We pulled the values we needed from a previously; null this element -->
	<xsl:template match='a'></xsl:template>
	<xsl:template match="span[@data-type = 'path']"></xsl:template>
	<xsl:template match="span[@data-type = 'navtitle']"></xsl:template>
	<xsl:template match="span[@data-type = 'type']"></xsl:template>

</xsl:stylesheet>