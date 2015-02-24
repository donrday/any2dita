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
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>


<!-- =========== OTHER STYLESHEET INCLUDES/IMPORTS =========== -->

	<!-- transforms for topics and their derivations -->
	<xsl:import href="html/topic.xsl"/>
	<xsl:import href="html/domains.xsl"/>
	<xsl:import href="html/utilities.xsl"/>
	<xsl:import href="html/task.xsl"></xsl:import>
	<xsl:import href="html/reference.xsl"></xsl:import>
	<!-- Transforms for maps -->
	<!-- Not needed in aggregatemap, which IS the map shell -->
	
	<!-- Transforms for ditaval visualization/editing -->
	<xsl:import href="html/props.xsl"/>
	
	<!-- import specializations in the override priority position -->
	<xsl:import href="msgref/msg2xhtml.xsl"/>
	<xsl:import href="faq/faq2html.xsl"/>
	<xsl:import href="ts/tsTroubleshooting.xsl"/>

	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/>
 
	<xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
	<!--xsl:output method="xml"
	            indent="yes"
	            encoding="utf-8"
	            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	/-->
  
  
	<!--     layout related -->
	<xsl:param name="groupName" select="'Home'"/>
	<xsl:param name="mapName" select="''"/>
	<xsl:param name="contentDir" select="'content'"/>
	<xsl:param name="contentFile" select="'Overview.dita'"/>
	<xsl:param name="userDir" select="'.'"/>
	<xsl:param name="siteLogo" select="''"/>
	<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>
	<xsl:param name="GENERATE-OUTLINE-NUMBERING" select="'no'"/>
	<xsl:param name="SHOW-TOPIC" select="'yes'"/>
	<xsl:param name="SHOW-ALL" select="'no'"/>
	<xsl:param name="SHOW-SLIDES" select="'yes'"/>

	<xsl:param name="serviceType" select="'browse'"/>
	<xsl:param name="resourceName" select="'Home'"/>
	<xsl:param name="tempTheme" select="'compromise'"/>


  	
	<xsl:template name='map' match='*[contains(@class," map/map ")]'>
			<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
			<xsl:apply-templates select='topicref|topichead|topicgroup'/>
			<xsl:apply-templates select='navref|anchor|data|data-about|reltable'/>
	</xsl:template>

	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- null these out completely for now; not supported in speckedit -->
	</xsl:template>

	<!-- =============common map content=============== concat($serviceType,'/topic/',$targfilename)-->

	<xsl:template match='*[contains(@class," map/topicref ")]'>
		<xsl:variable name="targfilename" select="substring-before(@href,'.')"/>
		<xsl:variable name="url"></xsl:variable>	
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>random</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<section>
			<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
			<div class="intro-box">
				<h1>
					<xsl:choose>
						<xsl:when test="@navtitle">
							<xsl:value-of select="@navtitle"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- force a value so that the element is not left empty. -->
							<!--{navigation title for: <xsl:value-of select="@href"/>}-->
							<!-- For low oops function, just silently fill this for now. -->
							<xsl:value-of select="document(@href)/*/title"/>
						</xsl:otherwise>
					</xsl:choose>
				</h1>
			</div>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
		</xsl:if>
        	<a class="back-to-top" href="#main"><xsl:value-of select="$targfilename"/>:Back to Top</a>
		</section>
	</xsl:template>

	<xsl:template match='*[contains(@class," mapgroup-d/topicgroup ")]'>
	</xsl:template>

	<xsl:template match='*[contains(@class," mapgroup-d/topichead ")]'>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
	</xsl:template>

	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- null these out completely for now; not supported in speckedit -->
	</xsl:template>
	<!-- =============common content=============== -->

	<xsl:template match='*[contains(@class," map/map ")]/@title'>
		<h3 class="navmapTitle">
			<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
		</h3>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]'>
		<h3 class="navmapTitle">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>

<!-- common utility for all topicref links -->

<xsl:template name="newlink">
	<xsl:variable name="fixedhref">
		<xsl:choose>
			<xsl:when test="contains(@href,'http://')">
				<!-- The href value is already presumeably a standard URL that was authored compliantly. -->
				<xsl:value-of select="@href"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- The standard file-based href source conventions need to be normalized per the API syntax. -->
				<!-- strip the extension off the href attribute -->
				<!-- parse the href so that we can peek here and there -->
				<xsl:variable name='path'>
					<xsl:choose>
						<xsl:when test='contains(@href,"#") and (substring-before(@href,"#")="")'>
							<xsl:value-of select='substring-before(@href,"#")'/>
						</xsl:when>
						<xsl:when test='contains(@href,"#")'>
							<xsl:value-of select='substring-before(@href,"#")'/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select='@href'/>
						</xsl:otherwise>
					</xsl:choose>		
				</xsl:variable>
				<xsl:variable name="resource-fn">
					<xsl:value-of select="substring-before($path,'.')"/>
				</xsl:variable>
				<!-- normalize any nested path by converting path separator / into a period . -->
				<!-- 16 Dec 2011 DRD: reverted the dotted-href logic so that we can try traversing folders normally -->
				<xsl:variable name="dotted-href">
					<xsl:value-of select='$resource-fn'/>
				<!--
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text" select="$resource-fn" />
						<xsl:with-param name="replace" select="'/'" />
						<xsl:with-param name="by" select="'.'" />
					</xsl:call-template>
				-->
				</xsl:variable>
				<!-- The groupName and mapName values were passed in by the calling context (known context) -->
				<xsl:text>resource</xsl:text>/<xsl:value-of select="$groupName"/>/<xsl:value-of select="$mapName"/>/<xsl:value-of select="$dotted-href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<a class="a nav" href='{$fixedhref}'>
		<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<span class="navtitle">
			<xsl:choose>
				<xsl:when test="@navtitle">
					<xsl:value-of select="@navtitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- force a value so that the element is not left empty. -->
					<span style="color:red;">(no navtitle) <xsl:value-of select="@href"/></span>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</a>
</xsl:template>


</xsl:stylesheet>