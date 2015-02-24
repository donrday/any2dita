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


<!-- markup conversion: map elements -->

	<xsl:template match='/' >
			<xsl:apply-templates/>
	</xsl:template>
	
    <xsl:template match="/" mode="test">
    	<h1>Colophon: List of elements</h1>
    	<ol>
        <xsl:for-each select="//node()">
           <li><xsl:value-of select="name()"/></li>
        </xsl:for-each>
        </ol>
    </xsl:template>


	<!-- =============map=============== -->
	<!-- 
		Pass navtitle content into the HTML editor as if it were element content.
		This makes it plainly editable! The editor has a link dialog already, so don't bother with href. 
	-->
	<xsl:template name='map' match='*[contains(@class," map/map ")]' mode="process">
		<!-- no html or body wrappers because this content is internal to an existing page -->
		<!--style="overflow:auto; height:80%;width:270px;" id="divTest" onscroll="SetDivPosition()"--> <!-- style="border:thin red solid;"-->
			<!-- deal with @title and @id as commonly used attributes -->
			<!--( ( title) (optional) then ( topicmeta) (optional) then... -->
			<xsl:apply-templates select='@title'/>
			<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
			<!-- ( topicref or topichead or topicgroup or... -->
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			<!-- ( navref or anchor or reltable or data or data-about) (any number) )-->
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
	</xsl:template>

	<xsl:template name='submap' match='*[contains(@class," map/map ")]' mode='nestedmap'>
			<xsl:apply-templates select='@title' mode='skip'/>
			<xsl:apply-templates select='*[contains(@class," topic/title ")]' mode='skip'/>
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
			<!-- ( topicref or topichead or topicgroup or... -->
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			<!-- ( navref or anchor or reltable or data or data-about) (any number) )-->
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
	</xsl:template>

	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- null these out completely for now; not supported in speckedit -->
	</xsl:template>

	<!-- =============common content=============== -->


	<xsl:template match='dita' mode='passthru'>
		<p>In 'dita' template.</p>
		<xsl:apply-templates mode='passthru'/>
	</xsl:template>

	<xsl:template match='topic' mode='passthru'>
		<xsl:variable name="topicref_nesting">
			<xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref ")])'/>
		</xsl:variable>
		<xsl:variable name="fullPath">
			<xsl:value-of select="concat($contentDir,'/',$groupName,'/',@href)"/>
		</xsl:variable>
		<xsl:variable name='thisdoc' select='document($fullPath,.)'/>
		<div class="widget" style="border:thin purple solid;">
			<xsl:element name="h{$topicref_nesting}">
				<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
				<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/>. <xsl:choose>
					<xsl:when test="@navtitle">
						<xsl:value-of select="@navtitle"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- force a value so that the element is not left empty. -->
						<span style="color:red;"><xsl:value-of select="@href"/></span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<!--xsl:apply-templates select='titlealts'/-->
			<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]'/>
			<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/body ")]'/>
			<!--xsl:apply-templates select='related-links'/-->
			<!-- now deal with literally nested topics in the local context (not just child topicrefs) -->
				<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/topic ")]/*[contains(@class," topic/topic ")]' mode='nested'/>
			<!-- nested topicrefs are equivalent to child topics -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<xsl:apply-templates mode='ref-as-topic'/>
			</xsl:if>
		</div>
	</xsl:template>


	<xsl:template match='*[contains(@class," map/map ")]/@title'/>
	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]'/>

	<xsl:template match='*[contains(@class," map/map ")]/@title' mode="skip">
		<h1 class="mapTitle" style="clear:both;">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</h1>
	</xsl:template>


	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]' mode="skip">
		<h1 class="mapTitle" style="clear:both;">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	
	<!-- add numbering based on topicref nesting -->	
	<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]' mode="numbered">
		<xsl:variable name="titlenum">
			<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/>
		</xsl:variable>
		<h1 class="slideTitle" style="clear:both;">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:value-of select='$titlenum'/><xsl:text>. </xsl:text>
			<xsl:apply-templates/>
		</h1>
	</xsl:template>

	<!-- added by DRD to ensure good slide title capture: -->
	
	<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]'>
		<h1 class="slideTitle" style="clear:both;">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
           <xsl:apply-templates/>
		</h1>
	</xsl:template>


	<xsl:template name='topicref' match='*[contains(@class," map/topicref ")]'>
		<!--
		<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<p>fullPath: <xsl:value-of select="$fullPath"/></p>
		-->
			<xsl:variable name="topicref_nesting">
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
			<xsl:variable name="fullPath">
				<xsl:value-of select="concat($contentDir,'/',$groupName,'/',$path)"/>
			</xsl:variable>
			<!-- load the referenced topic into processor for drilldown processing -->
			
			<!-- Kahuna! This is where the slide content gets generated -->
			<xsl:variable name='thisdoc' select='document($path,.)'/>
			<xsl:variable name='yoffset'><xsl:value-of select='$topicref_nesting'/>500</xsl:variable>
			<xsl:variable name="titlenum">
				<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/>
			</xsl:variable>
			<xsl:variable name="seqnum">
				<xsl:number level="any" count='*[contains(@class," map/topicref ")]'/>
			</xsl:variable>
<xsl:text>
			

</xsl:text>

<xsl:comment> Topicref rule: 
x-Pos <xsl:value-of select='position()'/>, 
y-Nesting <xsl:value-of select='$topicref_nesting'/>, 
titlenum <xsl:value-of select='$titlenum'/>, 
seqnum <xsl:value-of select='$seqnum'/>
</xsl:comment>
<xsl:text>
</xsl:text>
			<div id="slide{$seqnum}" class="step slide" data-x="{position()}000" data-y="{$yoffset - 3000 + ($seqnum * 300)}" data-rotate="{(position() - 4) * 23}" 
		 	data-z="-{$seqnum * 1000}" 
			data-scale="0.{10 - $topicref_nesting}" style="padding-top:0;">
					<!-- Adding ?file=value turns the link into a parameter for the GET event processor. -->
					<!-- data-scale="{$topicref_nesting}" style="border: 2px purple solid;"
				<a>
					<xsl:attribute name='href'>?file=<xsl:value-of select='@href'/></xsl:attribute>
					<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
					<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
					&#9632;&#9632;&#9632;
				</a>
				-->
				<!-- above here place the "link" content -->
				<div class="slideheader">
<a href="{$serviceType}/map/{$resourceName}?themeName={$tempTheme}">
<img src="{$contentDir}/{$groupName}/{$siteLogo}" width="240px"/>
</a>
</div>
				<!--div class='topicref'-->
					<xsl:choose>
						<xsl:when test="contains(@href,'.ditamap')">
							<xsl:choose>
								<xsl:when test="@format = 'ditamap'">
									<!--Is a nested map.-->
									<xsl:element name="h{$topicref_nesting}">
										<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
										<xsl:value-of select='$titlenum'/><xsl:text>. </xsl:text>
										<xsl:apply-templates select='@navtitle'/>
									</xsl:element>
									<p><span style="color:red;">Nested Map:<xsl:value-of select="@href"/></span></p>
									<!--xsl:apply-templates select='$thisdoc' mode="nestedmap"/-->
								</xsl:when>
								<xsl:otherwise>
									<!--Is a referenced-only map.-->
									<xsl:element name="h{$topicref_nesting}">
										<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
										<xsl:value-of select='$titlenum'/><xsl:text>. </xsl:text>
										<xsl:apply-templates select='@navtitle'/>
									</xsl:element>
									<p><span style="color:red;">Filename: <xsl:value-of select="@href"/></span></p>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="name($thisdoc/*[1]) = 'dita'">
							<!-- is a composite topic -->
							<xsl:element name="h{$topicref_nesting}">
								<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
								<xsl:value-of select='$titlenum'/><xsl:text>. </xsl:text>
								<xsl:choose>
									<xsl:when test="@navtitle">
										<xsl:value-of select="@navtitle"/>
									</xsl:when>
									<xsl:otherwise>
										<!-- force a value so that the element is not left empty. -->
										<span style="color:red;"><xsl:value-of select="@href"/></span>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
								<p>--ideally should use actual contained titles, not the map's navtitle</p>
							<!--xsl:apply-templates/-->
							<xsl:for-each select='$thisdoc/*/*[contains(@class," topic/topic ")]'>
								<div class='nestedComposite' style="border:thin pink solid; margin-left:2em;">
									<h3><xsl:value-of select='*[contains(@class," topic/title ")]'/></h3>
									<xsl:apply-templates select='*[contains(@class," topic/shortdesc ")]'/>
									<xsl:apply-templates select='*[contains(@class," topic/body ")]'/>
								</div>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<!-- is a topic -->
							<!--xsl:apply-templates select='titlealts'/-->
							<!--xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]'/-->
							<!--xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/body ")]'/-->
							<!--xsl:apply-templates select='related-links'/-->
							<xsl:variable name='checkclass' select='$thisdoc/*//*[contains(@class," topic/section ")]/@outputclass'/>
							<xsl:choose>
								<xsl:when test='$checkclass = "aside"'>
									<!-- selecting only the first of any multiple asides to avoid overrun; start a new topic for now -->
									<xsl:apply-templates select='$thisdoc/*//*[contains(@class," topic/section ")][@outputclass="aside"][1]' mode="slide"/>
								</xsl:when>
								<xsl:otherwise>
									<h1>
									<xsl:value-of select='$thisdoc/*/*[contains(@class," topic/title ")]'/></h1>
									<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]'/>
								</xsl:otherwise>
							</xsl:choose>

							<!-- now deal with literally nested topics in the local context (not just child topicrefs) -->
								<!-- DRD: Removed childtopics div to remove extraneous div structure for prez styles -->
								<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/topic ")]/*[contains(@class," topic/topic ")]' mode='nested'/>
							<!-- nested topicrefs are equivalent to child topics -->
							<xsl:if test='*[contains(@class," map/topicref ")]'>
								<xsl:apply-templates mode='ref-as-topic'/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				<!--/div-->
			</div>
			<!--div-->
				<xsl:if test='*[contains(@class," map/topicref ")]'>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</xsl:if>
			<!--/div-->
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topichead ")]'>
	    <xsl:variable name="topicref_nesting">
	      <xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref mapgroup-d/topichead ")]|ancestor-or-self::*[contains(@class," map/topicref ")])'/>
	    </xsl:variable>
		<xsl:variable name='yoffset'><xsl:value-of select='$topicref_nesting'/>500</xsl:variable>
		<xsl:variable name="titlenum">
			<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/>
		</xsl:variable>
			<xsl:variable name="seqnum">
				<xsl:number level="any" count='*[contains(@class," map/topicref ")]'/>
			</xsl:variable>
<xsl:text>

</xsl:text>

<xsl:comment> Topichead rule: 
x-Pos <xsl:value-of select='position()'/>, 
y-Nesting <xsl:value-of select='$topicref_nesting'/>, 
titlenum <xsl:value-of select='$titlenum'/>, 
seqnum <xsl:value-of select='$seqnum'/>
</xsl:comment>
<xsl:text>
</xsl:text>
		<div class="step slide" data-x="{position()}000" data-y="{$yoffset - 2000}" data-rotate="{(position() - 4) * 23}" 
		data-z="-{$seqnum * 1000}" data-rotate-x="-40" data-rotate-y="10"
		data-scale="0.{10 - $topicref_nesting}" style="background-color:#E0E0C0">
				<xsl:element name="h{$topicref_nesting}">
					<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
					<!--xsl:value-of select='$titlenum'/><xsl:text>. </xsl:text-->
					<xsl:choose>
						<xsl:when test="@navtitle">
							<xsl:value-of select="@navtitle"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- force a value so that the element is not left empty. -->
							<span style="color:red;"><xsl:value-of select="@href"/></span>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
		</div>
		<!--div-->
			<!-- Since topichead has no referenced content, we are done after placing the title. Time to recurse. -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</xsl:if>
		<!--/div-->
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topicgroup ")]'>
		<div class='step slide'>
			<!-- Since topicgroup has no referenced content, we are done after creating a grouping div. Time to recurse. -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
	<!--
		<div class='step slide'>
			<b class="navtitle"><xsl:value-of select="@navtitle"/></b>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</xsl:if>
		</div>
		-->
	</xsl:template>


	<xsl:template match='*[contains(@class," topic/section ")][@outputclass="aside"]' mode="slide">
			<!-- removed check-atts because the outputclass handler overrides the class value needed here -->
			<xsl:call-template name="check-rev"/>
		    <xsl:apply-templates select="node()[name()='title']"/>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
	</xsl:template>


<!-- Template for pis not handled elsewhere -->

<xsl:template match="processing-instruction('xpd-html')">
  <xsl:choose>
  	<xsl:when test='. = "linebreak"'>
  		<br/>
  	</xsl:when>
  	<xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>