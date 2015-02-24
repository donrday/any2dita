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
	<xsl:param name="widgetlevel1" select="'3'"/>


<!-- markup conversion: map elements -->

	<xsl:template match='/' >
			<xsl:apply-templates/>
	</xsl:template>


	<!-- =============map=============== -->
	<xsl:template name='map' match='*[contains(@class," map/map ")]'>

		<!-- prebuild the id attribute -->
		<xsl:variable name="thisid">
			<xsl:value-of select="@id"/>
		</xsl:variable>

		<!-- prebuild the locale attribute -->
		<xsl:variable name="thislang">
			<xsl:choose>
				<xsl:when test="@xml:lang !=''">
					<xsl:value-of select="@xml:lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>en</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- preaccess the title value -->
		<xsl:variable name="thistitle">
			<xsl:choose>
				<xsl:when test="@title !=''">
					<xsl:apply-templates select='@title'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select='*[contains(@class," map/title ")]'/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div locale="{$thislang}" id="{$thisid}">
			<h1><xsl:value-of select="$thistitle"/></h1>
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
		</div>			

		<!-- ( navref or anchor or reltable or data or data-about) (any number) )-->
		<xsl:apply-templates select='navref|anchor|data|data-about|reltable'/>
	</xsl:template>


	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- TBD: Need to add processing support for these eventually! no output for these for now.-->
	</xsl:template> 

	<!-- ============= recursive topicrefs (heart of transforms)=============== -->

	<xsl:template name='topicref' match='*[contains(@class," map/topicref ")][@format="dita" or not(@format)]'>
		<!-- get a bunch of variable content up front as global values to use later -->
	    <xsl:variable name="topicref_nesting">
	      <xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref ")])'/>
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

		<!-- load the referenced topic into processor for drilldown processing -->
		<xsl:variable name='tempdoc' select='document($path,.)'/>

		<!-- 
			Using choose logic to select how to process the different kinds of endponts possible on topicrefs: 
			ie, topics, other maps, links, etc.).
		-->
		<xsl:choose>
			<!-- Is this a reference to another map? (these conditions are not yet adapted for oManual use case) -->
			<xsl:when test="contains($path,'.ditamap')">
				<xsl:choose>
					<!-- If so, is it a mapref? -->
					<xsl:when test="@format = 'ditamap'">
						<!--Is a nested map.-->
						<xsl:comment>-{is_nested_map}</xsl:comment>
						<xsl:element name="h{$topicref_nesting}">
							<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
							<xsl:if test="$GENERATE-OUTLINE-NUMBERING='yes'">
								<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/><xsl:text>. </xsl:text>
							</xsl:if>
							<xsl:apply-templates select='@navtitle'/>
						</xsl:element>
						<p><span style="color:red;">Nested Map:<xsl:value-of select="@href"/></span></p>
						<!--xsl:apply-templates select='$tempdoc' mode="nestedmap"/-->
					</xsl:when>
					<!-- If not a mapref, it must be a reference instead. -->
					<xsl:otherwise>
						<!--Is a referenced-only map.-->
						<xsl:comment>-{is_ref-only_map}</xsl:comment>
						<xsl:element name="h{$topicref_nesting}">
							<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
							<xsl:if test="$GENERATE-OUTLINE-NUMBERING='yes'">
								<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/><xsl:text>. </xsl:text>
							</xsl:if>
							<xsl:apply-templates select='@navtitle'/>
						</xsl:element>
						<p><span style="color:red;">Filename: <xsl:value-of select="@href"/></span></p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<!-- Is this a reference to a composite DITA topic? (this use case will require walking the nested content) -->
			<xsl:when test="name($tempdoc/*[1]) = 'dita'">
				<!-- is a composite topic -->
				<xsl:comment>-{is_composite_topic}</xsl:comment>
				<xsl:apply-templates select='$tempdoc/*' mode='nested'/>
				<!-- anticipate recursion -->
			</xsl:when>
			
			<!-- Fall through to the normal case of actual topics comprising an oManual manifest of guides/topics. -->
			<xsl:otherwise>
				<!-- is a topic -->
 				<xsl:variable name="outermostExtEntName" select="name($tempdoc/*)" />
				<xsl:comment>-{is_topic of type: <xsl:value-of select='$outermostExtEntName'/>}</xsl:comment>
				
				<!-- Processing note:
					At this point, we have a topic in the variable $tempdoc. 
				-->

			
				<xsl:variable name="thistitle">
					<xsl:apply-templates select='$tempdoc/*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]' />
				</xsl:variable>
			
				<xsl:variable name="shortdesc">
					<p>This would actually be the map-level description at this point; we have not drilled into topics yet.</p>
				</xsl:variable>
				
				<!-- generate the reference for the manifest -->
			<div class="wrapper wrapper-style1 wrapper-first">
				<article class="5grid-layout" id="{$topictitleid}">
					<header>
						<h2><xsl:value-of select='$thistitle' /></h2>
						<span><xsl:value-of select='$shortdesc' /></span>
					</header>
					<div class="5grid-layout">
				<?php content(); ?>
						<div class="row">
							<div class="4u">
								<section class="box box-style1">
									<span class="image image-centered"><img src="images/work01.png" alt="" /></span>
									<h3>Consequat lorem</h3>
									<p>Ornare nulla proin odio consequat sapien vestibulum ipsum primis sed amet consequat lorem dolore.</p>
								</section>
							</div>
							<div class="4u">
								<section class="box box-style1">
									<span class="image image-centered"><img src="images/work02.png" alt="" /></span>
									<h3>Lorem dolor tempus</h3>
									<p>Ornare nulla proin odio consequat sapien vestibulum ipsum primis sed amet consequat lorem dolore.</p>
								</section>
							</div>
							<div class="4u">
								<section class="box box-style1">
									<span class="image image-centered"><img src="images/work03.png" alt="" /></span>
									<h3>Feugiat posuere</h3>
									<p>Ornare nulla proin odio consequat sapien vestibulum ipsum primis sed amet consequat lorem dolore.</p>
								</section>
							</div>
						</div>
					</div>
				</article>
			</div>

			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<xsl:apply-templates select='*[contains(@class," map/xtopicref ")]'/>
		</xsl:if>
	</xsl:template>


	<!-- =============common content=============== -->


	<xsl:template match='*[contains(@class," map/map ")]/@title'/>
	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]'/>

	<xsl:template match='*[contains(@class," map/map ")]/@title' mode="skip">
		<xsl:element name="h{$headlevel1}">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>


	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]' mode="skip">
		<xsl:element name="h{$widgetlevel1}">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- add numbering based on topicref nesting -->	
	<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]' mode="numbered">
		<xsl:variable name="titlenum">
			<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/>
		</xsl:variable>
		<xsl:element name="h3">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:value-of select='$titlenum'/><xsl:text>. </xsl:text>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]' mode="aside">
		<xsl:element name="h3">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!-- added by DRD to ensure good slide title capture: -->
	
	<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]'>
		<xsl:element name="h{$widgetlevel1}">
	 		<xsl:if test="ancestor::map/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
			</xsl:if>
           <xsl:apply-templates/>
		</xsl:element>
	</xsl:template>


	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topicgroup ")]'>
	<div class="DON3">
		<section class='step slide'>
			<!-- Since topicgroup has no referenced content, we are done after creating a grouping div. Time to recurse. -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</xsl:if>
		</section>
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
		    <xsl:apply-templates select="node()[name()='title']" mode="aside"/>
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