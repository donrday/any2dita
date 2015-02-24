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


	<xsl:output method="html"
	            indent="no"
	/>
	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/>
  
    
	<xsl:param name="groupName" select="''"/>
	<xsl:param name="mapName" select="''"/>

  


	<xsl:template name='map' match='*[contains(@class," map/map ")]'>
		<xsl:apply-templates select='@title'/>
		<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
		<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
		<table 
			class="table"
			width="100%" 
			cellpadding="6"
			cellspacing="0"
			frame="border"
			border="1"
			rules="all"
			style="font-size:85%;"
			>
			<tbody>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</tbody>
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
		</table>
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
		<!-- Bug: no select for current context (.), but instead gathered the rest of the map! -->
		<!--
		<xsl:if test="topicref|topichead|topicgroup">
			<ul>
				<xsl:apply-templates select='topicref|topichead|topicgroup'/>
			</ul>
		</xsl:if>
		-->
		</h3>
	</xsl:template>

	<xsl:template match='map/*[contains(@class," map/topicref ")]'>
		<tr class="topicref">
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<td>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>1
				</td>
			</xsl:if>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref ")]/*[contains(@class," map/topicref ")]'>
		<tr class="innertopicref">
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<td>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>2
				</td>
			</xsl:if>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topicgroup ")]'>
		<tr class='topicgroup'>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<td>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>3
				</td>
			</xsl:if>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topichead ")]'>
		<tr class='topichead'>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul><!-- class="innermapnav"-->
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>4
				</ul>
			</xsl:if>
		</tr>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
		<td class='topicmeta'>
			<b class="navtitle"><xsl:value-of select="@navtitle"/></b>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul><!-- class="innermapnav"-->
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>5
				</ul>
			</xsl:if>
		</td>
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



<!-- Bookmap rendering -->

<xsl:template match='*[contains(@class," map/map bookmap/bookmap ")]'>
	<div class="xwidget">
		<xsl:apply-templates select='*[contains(@class," bookmap/booktitle ")]'/>
		<xsl:apply-templates select='*[contains(@class," bookmap/bookmeta ")]'/>
		<!-- front, body, backmatter -->
		<ul id="mapnav-ul">
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]' mode="sideBookNav"/>
		</ul>
	</div>
</xsl:template>

<xsl:template match='*[contains(@class," bookmap/bookmap ")]/*[contains(@class," bookmap/booktitle ")]'>
<div style="border:thin black solid;padding-bottom:3em;">
	<h4 style="text-align:center;font-style:italic;"><xsl:value-of select="//booklibrary"/></h4>
	<h3 class="navmapTitle"  style="font-size:1.5em">
		<xsl:if test="ancestor::map/@id">
			<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
		</xsl:if>
		<xsl:value-of select='//*[contains(@class," bookmap/mainbooktitle ")]'/>
	</h3>
	<!--<div><br/><b>Table of Contents</b></div>-->
	<xsl:if test='//*[contains(@class," bookmap/booktitlealt ")]'>
		<div style="margin-bottom:.7em;">
			<b style="font-size:.9em"><xsl:value-of select='//*[contains(@class," bookmap/booktitlealt ")]'/></b>
		</div>
	</xsl:if>
</div>
</xsl:template>

<xsl:template name="do_bookmap" match='*[contains(@class," bookmap/bookmeta ")]'>
	<div class="widget">
		<!-- bookmeta stuff -->
		<xsl:if test='//*[contains(@class,"  xnal-d/authorinformation ")]'>
			<div style="margin-top:1.4em;font-size:.8em">Authors:
				<xsl:for-each select='//*[contains(@class," xnal-d/personname ")]'>
					<div style="margin-left:1em"><xsl:value-of select="."/></div>
				</xsl:for-each>
			</div>
		</xsl:if>
		<hr/>
	</div>
</xsl:template>



<xsl:template match="booklists" mode="sideBookNav">
  <!-- this is automated function -->
</xsl:template>


<xsl:template match='*[contains(@class," bookmap/chapter ")]' mode="sideBookNav">
	<li style='padding:2px 0px 2px 0px'>		
		<b>Chapter <xsl:number/>. </b>
		<xsl:call-template name="newlink"/>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul id="innermapnav">
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ul>
		</xsl:if>
		
		<!-- after the link, echo some attribute info about the element -->
		<!--xsl:call-template name="ref-adorn"/-->
	</li>
</xsl:template>

<xsl:template match='*[contains(@class," bookmap/preface ")]' mode="sideBookNav">
	<li style='padding:2px 0px 2px 0px'>		
		<b>Preface: </b>
		<xsl:call-template name="newlink"/>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul id="innermapnav">
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ul>
		</xsl:if>
		
		<!-- after the link, echo some attribute info about the element -->
		<!--xsl:call-template name="ref-adorn"/-->
	</li>
</xsl:template>

<xsl:template match='*[contains(@class," bookmap/abstract ")]' mode="sideBookNav">
	<li style='padding:2px 0px 2px 0px'>
		<b>Abstract: </b>
		<xsl:call-template name="newlink"/>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul id="innermapnav">
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ul>
		</xsl:if>
		
		<!-- after the link, echo some attribute info about the element -->
		<!--xsl:call-template name="ref-adorn"/-->
	</li>
</xsl:template>

<!--
			<b>Abstract: </b>
			<b>Notices: </b>
-->


<xsl:template match='*[contains(@class," mapgroup-d/topichead ")]' mode='sideBookNav'>
	<li class='topichead nav'>
		<b><xsl:value-of select="@navtitle"/></b>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul id="innermapnav">
				<xsl:apply-templates mode="sideBookNav"/>
			</ul>
		</xsl:if>
	</li>
</xsl:template>


<xsl:template match='*[contains(@class," mapgroup-d/topicgroup ")]' mode='sideBookNav'> <!-- mapgroup-d/topicgroup this handles frontmatter, backmatter and booklist groups -->
	<li class='topicgroup nav'>
		<b><xsl:value-of select="@outputclass"/></b>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul id="innermapnav">
				<xsl:apply-templates mode="sideBookNav"/>
			</ul>
		</xsl:if>
	</li>
</xsl:template>



</xsl:stylesheet>