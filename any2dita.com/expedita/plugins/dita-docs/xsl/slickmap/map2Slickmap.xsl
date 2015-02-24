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
	<xsl:param name="themesDir" select="'content'"/>
	<xsl:param name="themeName" select="''"/>
	<xsl:param name="addcss" select="''"/>

  	
	<xsl:template name='map' match='*[contains(@class," map/map ")]'>
		<!-- style="border:thin black solid; padding:1em; background-color:#FFFFFF; width:97%;" -->
		<div class="sitemap">
			<h1>
		 		<xsl:if test="@id">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>
				<xsl:if test='@xml:lang'>
					<xsl:attribute name="lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test='@title'>
						<xsl:value-of select='@title'/>
					</xsl:when>
					<xsl:when test='title'>
						<xsl:value-of select='title'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Default map title</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</h1>
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
		
			<ul id="utilityNav">
				<li><a title="/tool1">Interaction 1</a></li>
				<li><a title="/tool2">Interaction 2</a></li>
				<li><a title="/tool3">Interaction 3</a></li>
			</ul>
	
			<ul id="primaryNav" class="col4">
				<!--li id="home"><a href="Home.dita">Home</a></li-->
				<xsl:apply-templates select='topicref|topichead|topicgroup'/>
			</ul>
			
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]'>
		<xsl:apply-templates/>
	</xsl:template>


	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- null these out completely for now; not supported in speckedit -->
	</xsl:template>

	<!-- =============common map content=============== -->

	<xsl:template match='*[contains(@class," map/topicref ")]'>
		<xsl:variable name="targfilename" select="substring-before(@href,'.')"/>
		<li>
			<a onClick="window.open('{$serviceType}/topic/{$targfilename}?themeName=galley', 'helpwindow','status=1,scrollbars=1, width=800,height=640')">
			<!--a onClick="javascript:popup('printwin','{$serviceType}/topic/{$targfilename}?render=single', 500);"-->
			<!--a href="{$serviceType}/topic/{$targfilename}"-->
 				<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
				<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
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
			</a>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
					<br clear="both" />
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," mapgroup-d/topicgroup ")]'>
		<li><a href="Node">Group</a>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
					<br clear="both" />
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," mapgroup-d/topichead ")]'>
		<li>
			<a title="TitledNode"><xsl:value-of select="@navtitle"/></a>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
					<br clear="both" />
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
		<li>
			<a title="/toolz"><xsl:value-of select="@navtitle"/></a>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
					<br clear="both" />
				</ul>
			</xsl:if>
		</li>
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

	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
		<p class='topicmeta'>
			<b class="navtitle"><xsl:value-of select="@navtitle"/></b>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul><!-- class="innermapnav"-->
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>5
				</ul>
			</xsl:if>
		</p>
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



<!-- not used -->

	<xsl:template name='map3' match='*[contains(@class," map/map3 ")]'>
		<xsl:apply-templates select='@title'/>

	<table
		width="100%" 
		cellpadding="6"
		cellspacing="0"
		frame="border"
		border="0"
		rules="all"
		style="font-size:85%;"
	>
      <tbody class="tbody">
        <tr class="row">
          <td class="entry" rowspan="2" width="20%" outputclass="KP-KeyPartners">KP<br/><textarea id="kr"></textarea></td>
          <td class="entry"             width="20%" outputclass="KA-KeyActivities">KA<br/><textarea id="kr"></textarea></td>
          <td class="entry" rowspan="2" colspan="2" outputclass="VP-ValuePropositions">VP<br/><textarea id="kr"></textarea></td>
          <td class="entry"             width="20%" outputclass="CR-CustomerRelationships">CR<br/><textarea id="kr"></textarea></td>
          <td class="entry" rowspan="2" width="20%" outputclass="CS-CustomerSegments">CS<br/><textarea id="kr"></textarea></td>
        </tr>
        <tr class="row">
          <td class="entry" width="20%" outputclass="KR-KeyResources">KR<br/><textarea id="kr"></textarea></td>
          <td class="entry" width="20%" outputclass="CH-Channels">CH<br/><textarea id="kr"></textarea></td>
        </tr>
        <tr class="row">
          <td class="entry" colspan="3" outputclass="C$-CostStructure">C$<br/><textarea id="kr"></textarea></td>
          <td class="entry" colspan="3" outputclass="R$-RevenueStreams">R$<br/><textarea id="kr"></textarea></td>
        </tr>
      </tbody>
	</table>
</xsl:template>



</xsl:stylesheet>