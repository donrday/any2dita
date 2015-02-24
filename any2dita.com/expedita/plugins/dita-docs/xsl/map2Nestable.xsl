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
<!-- Note that variable $thisdoc is NOT used in this transform because the intent is to support editing of the map,
     not the rendering of the map. In editing context, a missing topic causes an error, and XSLT lacks a
     graceful "if exists(file)" test that otherwise would allow conditional handling of that case.
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>

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

	<xml:strip-space elements="*"/>  
    

	<!--     layout related -->
	<xsl:param name="groupName" select="'Home'"/>
	<xsl:param name="mapName" select="''"/>
	<xsl:param name="contentDir" select="'content'"/>
	<xsl:param name="contentFile" select="'Overview.dita'"/>
	<xsl:param name="userDir" select="'.'"/>
	<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>
	<xsl:param name="GENERATE-OUTLINE-NUMBERING" select="'no'"/>
	<xsl:param name="SHOW-TOPIC" select="'yes'"/>
	<xsl:param name="SHOW-ALL" select="'no'"/>
	<xsl:param name="SHOW-SLIDES" select="'yes'"/>
	<xsl:param name="phpmsg" select="''"/>
	
	<!-- patch #3 DRD -->
	<xsl:output method="html"
	            indent="no"
	/>
	
	
	<!-- markup conversion: map elements -->

	<xsl:template match='/' >
			<xsl:apply-templates mode="process"/>
	</xsl:template>
	
    <xsl:template match="/" mode="test">
    	<h1>Colophon: List of elements</h1>
    	<ol>
        <xsl:for-each select="//node()">
           <li><xsl:value-of select="name()"/></li>
        </xsl:for-each>
        </ol>
    </xsl:template>


	<!-- ============= Overrides that provide aggregation =============== -->
	<!-- 
		Pass navtitle content into the HTML editor as if it were element content.
		This makes it plainly editable! The editor has a link dialog already, so don't bother with href. 
	-->

	<xsl:template name='map' match='*[contains(@class," map/map ")]' mode="process">
		<!-- For nestedSortable rendition, ONLY the topicrefs are rendered as data structures -->
		<!--div class='map'-->
			<!-- deal with @title and @id as commonly used attributes -->
			<!--( ( title) (optional) then ( topicmeta) (optional) then... -->
			<xsl:variable name="resource-fn">
				<xsl:value-of select="substring-before($contentFile,'.')"/>
			</xsl:variable>
			<xsl:variable name="fixedmapref">
				<xsl:value-of select="$serviceType"/>/map/<xsl:value-of select="$resource-fn"/>
			</xsl:variable>
			<!-- 
			<h1 class="mapTitle topictitle0" style="background:white;border:thin black solid; padding:.5em; line-height: 1.5;">
		 		<xsl:if test="ancestor::map/@id">
					<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test='booktitle'>
						<xsl:apply-templates select='*[contains(@class," bookmap/booktitle ")]/*[contains(@class," bookmap/mainbooktitle ")]'/>:
						<xsl:apply-templates select='*[contains(@class," bookmap/booktitle ")]/*[contains(@class," bookmap/booktitlealt ")]'/>
					</xsl:when>
					<xsl:when test='title'>
						<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
					</xsl:when>
					<xsl:when test='@title'>
						<xsl:apply-templates select='@title'/>
					</xsl:when>
					<xsl:otherwise>
					[untitled map]
					</xsl:otherwise>
				</xsl:choose>
			</h1>
			 -->
			<!-- -->
			<!-- specifically process the top-level metadata here -->
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
			<!-- ( topicref or topichead or topicgroup or... -->
			<ol class="sortable">
				<xsl:if test="@id">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>
				<xsl:if test='*[contains(@class," topic/title ")]'>
					<xsl:attribute name='data-title'><xsl:value-of select='*[contains(@class," topic/title ")]'/></xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ol>
			<!-- ( navref or anchor or reltable or data or data-about) (any number) )-->
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
		<!--/div-->
	</xsl:template>
	
	<xsl:template select='*[contains(@class," bookmap/booktitlealt ")]'/>
		

	<xsl:template name='submap' match='*[contains(@class," map/map ")]' mode='nestedmap'>
		<div class='submap'>
			<xsl:apply-templates select='@title' mode='skip'/>
			<xsl:apply-templates select='*[contains(@class," topic/title ")]' mode='skip'/>
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
			<!-- ( topicref or topichead or topicgroup or... -->
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			<!-- ( navref or anchor or reltable or data or data-about) (any number) )-->
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
		</div>
	</xsl:template>

	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- Need to add processing support for these eventually! -->
	</xsl:template>

	<!-- =============common content=============== -->

	<xsl:template match='@title' mode='skip'/>
	<xsl:template match='*[contains(@class," topic/title ")]' mode='skip'/>

	<xsl:template name='topicref' match='*[contains(@class," map/topicref ")][@format="dita" or not(@format)]'>
		<!-- wrapping is done by the caller since attributes on the wrapper vary by context -->
		    <xsl:variable name="topicref_nesting">
				<!--xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref ")])'/-->
				<xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref mapgroup-d/topichead ")]|ancestor-or-self::*[contains(@class," map/topicref ")])'/>
		    </xsl:variable>
			<!-- parse the href so that we can peek here and there -->
			<xsl:variable name='prepath'>
				<xsl:choose>
					<xsl:when test='substring(@href, 1, 2) = "./"'>
						<xsl:value-of select='substring-after(@href,"./")'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@href"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name='path'>
				<xsl:choose>
					<xsl:when test='contains($prepath,"#") and (substring-before($prepath,"#")="")'>
						<xsl:value-of select='substring-before($prepath,"#")'/>
					</xsl:when>
					<xsl:when test='contains($prepath,"#")'>
						<xsl:value-of select='substring-before($prepath,"#")'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select='$prepath'/>
					</xsl:otherwise>
				</xsl:choose>		
			</xsl:variable>
			<!-- load the previously qualified file here -->
			<!--xsl:variable name='thisdoc' select='document($path,.)'/-->
			<li>
				<xsl:attribute name='data-class'>topicref</xsl:attribute>
				<xsl:attribute name="id">list_<xsl:number/></xsl:attribute>
				<xsl:choose>
				
					<xsl:when test="contains($path,'.ditamap')">
						<div>
							<span class="disclose"><span></span></span>
							<xsl:choose>
								<xsl:when test="@format = 'ditamap'">
									<!--Is a nested map.-->
									<xsl:comment>-{is_nested_map}</xsl:comment>
									<xsl:element name="h{$topicref_nesting}">
										<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
										<xsl:apply-templates select='@navtitle'/>
									</xsl:element>
									<p><span style="color:red;">Nested Map:<xsl:value-of select="@href"/></span></p>
									<!--xsl:apply-templates select='$thisdoc' mode="nestedmap"/-->
								</xsl:when>
								<xsl:otherwise>
									<!--Is a referenced-only map.-->
									<xsl:comment>-{is_ref-only_map}</xsl:comment>
									<xsl:element name="h{$topicref_nesting}">
										<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
										<xsl:apply-templates select='@navtitle'/>
									</xsl:element>
									<p><span style="color:red;">Filename: <xsl:value-of select="@href"/></span></p>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</xsl:when>
					
						<!-- is a composite topic -->
					<!--
					<xsl:when test="name($thisdoc/*[1]) = 'dita'">
						<xsl:comment>-{is_composite_topic}</xsl:comment>
						<div>
							<span class="disclose"><span></span></span>
							<xsl:apply-templates select='$thisdoc/*' mode='nested'/>
						</div>
					</xsl:when>
					-->
					
					<xsl:otherwise>
						<!-- is a topic -->
						<!--xsl:comment>-{is_topic}</xsl:comment-->
						<div>
							<!--xsl:attribute name="data-{$topicref_nesting}">0</xsl:attribute-->
							<!--xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute-->
							<span class="disclose"><span></span></span>
							<xsl:variable name='doctitle'></xsl:variable>
							<!--xsl:variable name='doctitle'><xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/title ")]'/></xsl:variable-->
							<xsl:choose>
								<xsl:when test="@navtitle">
									<xsl:call-template name="newlink"/>
								</xsl:when>
								<xsl:when test="$doctitle">
									<xsl:value-of select="$doctitle"/>
								</xsl:when>
								<xsl:otherwise>
									<!-- force a value so that the element is not left empty. -->
									<!--xsl:value-of select="@href"/><br/-->
									<xsl:call-template name="newlink"/>
								</xsl:otherwise>
							</xsl:choose>
							<span data-type='path'><xsl:value-of select='$path'/></span>
							<xsl:if test="@type">
								<span data-type='type'><xsl:value-of select='@type'/></span>
							</xsl:if>
						</div><!-- close the div wrapper for content before nesting new lists -->
						
												
						<!--
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/titlealts ")]'/>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]'/>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/body ")]'/>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/related-links ")]'/>
						-->
						<!-- now deal with literally nested topics in the local context (not just child topicrefs) -->
							<!-- Not applicable for a topicref only view -->
						<!-- nested topicrefs are equivalent to child topics.  mode='ref-as-topic' -->
						<!-- For child topics, show them as  class="mjs-nestedSortable-no-nesting". -->
						<xsl:if test='*[contains(@class," map/topicref ")]'>
							<ol>
								<xsl:apply-templates/>
							</ol>
						</xsl:if>
					</xsl:otherwise>
					
				</xsl:choose>
				
				<xsl:if test='*[contains(@class," map//topicref ")]'>
					<ol>
						<xsl:apply-templates/>
					</ol>
				</xsl:if>
			</li>
		<!--/ol-->
	</xsl:template>

	<xsl:template match='data'>
			<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topichead ")]'>
	    <xsl:variable name="topicref_nesting">
	      <xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref ")])'/>
	    </xsl:variable>
		<li>
				<xsl:attribute name='data-class'>topichead</xsl:attribute>
			<xsl:attribute name="id">list_<xsl:number/></xsl:attribute>
			<xsl:comment>-{is_topichead}</xsl:comment>
			<div>
				<span class="disclose"><span></span></span>
				<span data-type='navtitle'>
					<xsl:choose>
						<xsl:when test="@navtitle">
							<xsl:value-of select="@navtitle"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- force a value so that the element is not left empty. -->
							<span style="color:red;"><xsl:value-of select="@href"/></span>
						</xsl:otherwise>
					</xsl:choose>
				</span>
			</div>
			<!-- Since topichead has no referenced content, we are done after placing the title. Time to recurse. -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ol>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ol>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topicgroup ")]'>
		<div class='{local-name(parent::*)} topicgroup'>
			<!-- Since topicgroup has no referenced content, we are done after creating a grouping div. Time to recurse. -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ol>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ol>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
		<div class='{local-name(parent::*)} topicmeta'>
			<b class="navtitle"><xsl:value-of select="@navtitle"/></b>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ol>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ol>
			</xsl:if>
		</div>
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
				<xsl:variable name="resource-fn">
					<xsl:value-of select="substring-before(@href,'.')"/>
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
				<xsl:value-of select="$groupName"/>/<xsl:value-of select="$mapName"/>/<xsl:value-of select="$dotted-href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<a href='{$fixedhref}'>
		<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<xsl:choose>
			<xsl:when test="@navtitle">
				<xsl:value-of select="@navtitle"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- force a value so that the element is not left empty. -->
				<span style="color:darkgreen;text-decoration:italic;"><xsl:value-of select="@href"/></span>
			</xsl:otherwise>
		</xsl:choose>
	</a>
	<!--
	<sup><a class="a nav" href='{$fixedhref}?edit'>·</a></sup>
	-->
</xsl:template>



</xsl:stylesheet>