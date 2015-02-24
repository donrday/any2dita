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

	<!--xsl:import href="template2html.xsl"/-->
	
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
	<xsl:param name="contentPath" select="'content'"/>
	<xsl:param name="contentFile" select="'Overview.dita'"/>
	<xsl:param name="userDir" select="'.'"/>
	<xsl:param name="siteLogo" select="''"/>
	<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>
	<xsl:param name="GENERATE-OUTLINE-NUMBERING" select="'no'"/>
	<xsl:param name="SHOW-TOPIC" select="'no'"/>
	<xsl:param name="SHOW-ALL" select="'no'"/>
	<xsl:param name="SHOW-SLIDES" select="'yes'"/>

	<xsl:param name="serviceType" select="'browse'"/>
	<xsl:param name="resourceName" select="'Home'"/>
	<xsl:param name="tempTheme" select="'compromise'"/>
	
	
	<!-- markup conversion: map elements (process or slidesonly)-->

	<xsl:template match='/' >
			<xsl:apply-templates mode="process"/>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/map ")]' mode="test">
    	<h1>Colophon: List of elements</h1>
    	<ol>
        <xsl:for-each select="//node()">
           <li><xsl:value-of select="name()"/></li>
        </xsl:for-each>
        </ol>
    </xsl:template>


	<!-- ============= Overrides that provide aggregation =============== -->
	<!-- 
		Pass "topic_notes_k content into the HTML editor as if it were element content.
		This makes it plainly editable! The editor has a link dialog already, so don't bother with href. 
	-->

	<xsl:template match='*[contains(@class," map/map ")]' mode="slidesonly">
		<!-- provide descent into any element based on topicref -->
		<xsl:apply-templates select='*[contains(@class," map/topicref ")]' mode="slidesonly"/>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref ")][@format="dita" or not(@format)]' mode="slidesonly">
	<h1>ELEMENT: <xsl:value-of select="name()"/></h1>
		<div>
			<xsl:variable name='prepath'>
				<!-- parse the href so that we can peek here and there -->
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
			<xsl:variable name='thisdoc' select='document($path,.)'/>
			<!-- provide moded descent into the body of the topic named by the topicref -->
			<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/body ")]' mode="slidesonly"/>
		</div>
	</xsl:template>

	<!-- Main logic for aggregated rendition of map in a display context. -->
	<xsl:template name='map' match='*[contains(@class," map/map ")]' mode="process">
		<div class='map'>	
			<xsl:variable name="resource-fn">
				<xsl:value-of select="substring-before($contentFile,'.')"/>
			</xsl:variable>
			<xsl:variable name="fixedmapref">
				<xsl:value-of select="$serviceType"/>/map/<xsl:value-of select="$resource-fn"/>
			</xsl:variable>
			<!--
			<sup><a class="a nav" href='{$fixedmapref}?edit'>·</a></sup>
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
			<!-- was using $headlevel1 here, passed from theme context, but it is meaningless for the map title. -->
			<div class="ditamaphd0div">
				<xsl:element name="h1">
					<xsl:attribute name="class">ditamaphd0text</xsl:attribute>
			 		<xsl:if test="ancestor::*/@id">
						<xsl:attribute name="id"><xsl:value-of select="ancestor::*/@id"/></xsl:attribute>
					</xsl:if>
					<xsl:if test='ancestor::*/@xml:lang'>
						<xsl:attribute name="lang"><xsl:value-of select="ancestor::*/@xml:lang"/></xsl:attribute>
					</xsl:if>
					<!--
					<xsl:attribute name="class">mapTitle <xsl:value-of select="$classlevel1"/><xsl:text> </xsl:text><xsl:value-of select="local-name(parent::*)"/><xsl:value-of select="local-name(.)"/></xsl:attribute>
					<xsl:if test='ancestor::*/@outputclass'>
						<xsl:attribute name="style"><xsl:value-of select="ancestor::*/@outputclass"/></xsl:attribute>
					</xsl:if>
					-->
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
						Untitled List
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</div>
			<!-- specifically process the top-level metadata here -->
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
			<!-- ( topicref or topichead or topicgroup or... -->
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			<!-- ( navref or anchor or reltable or data or data-about) (any number) )-->
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
		</div>
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

	<xsl:template match='*[contains(@class," topic/section ")][@class="aside"]'>
		<div>
			<xsl:attribute name="style">
			<xsl:choose>
				<xsl:when test='$SHOW-SLIDES = "yes"'>
					display:block;
				</xsl:when>
				<xsl:otherwise>
					display:none;
				</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- =============common content=============== -->

	<xsl:template match='@title' mode='skip'/>
	<xsl:template match='*[contains(@class," topic/title ")]' mode='skip'/>

	<xsl:template name='topicref' match='*[contains(@class," map/topicref ")][@format="dita" or not(@format)]'>
		<xsl:variable name="trefseq"><xsl:number count="topicref" level="any"/></xsl:variable>
		<div class="ref_nesting">
		    <xsl:variable name="topicref_nesting">
				<!--xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref ")])'/-->
				<xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref mapgroup-d/topichead ")]|ancestor-or-self::*[contains(@class," map/topicref ")])'/>
		    </xsl:variable>
			<xsl:variable name='prepath'>
				<!-- parse the href so that we can peek here and there -->
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
			<xsl:variable name='fullpath'><xsl:value-of select="concat($contentPath,'/',$path)"/></xsl:variable>
			<xsl:variable name='thisdoc' select='document($fullpath,.)'/>
			<div class='topicref'>
				<xsl:choose>
				
					<xsl:when test="contains($path,'.ditamap')">
						<xsl:choose>
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
								<!--xsl:apply-templates select='$thisdoc' mode="nestedmap"/-->
							</xsl:when>
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
					
					<xsl:when test="name($thisdoc/*[1]) = 'dita'">
						<!-- is a composite topic -->
						<xsl:comment>-{is_composite_topic}</xsl:comment>
						<!-- Generate a heading (this is optional, just making use of the <dita> event for now). -->
						<!-- OK, decided not to use this. Let's see what happens.
						<xsl:element name="h{$topicref_nesting}">
							<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
							<xsl:if test="$GENERATE-OUTLINE-NUMBERING='yes'">
								<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/><xsl:text>. </xsl:text>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="@navtitle">
									<xsl:value-of select="@navtitle"/>
								</xsl:when>
								<xsl:otherwise>
									<p>Force a value so that the element is not left empty.</p>
									<span style="color:red;"><xsl:value-of select="@href"/></span>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						-->
						<!-- Generate some default text for testing the visual result of this event. -->
						<!--ideally should use actual contained titles, not the map's navtitle -->
						<!-- Drop into the structure. The problem is that peer topics are possible at this point. 
						    Just doing an apply-templates won't process the following siblings in the dita container.
						-->
						<!--
						1. xsl:apply-templates needs guided to the proper descent pattern. Need to test.
						   Also, need to reset the nesting depth, if retaining the generated heading above.
						-->
						<xsl:apply-templates select='$thisdoc/*' mode='nested'/>
						<!--
						2. xsl:for-each will catch each first-level peer, but we need to recurse each time.
						   This present implementation is just to start exploring the algorithm. Needs work!
						<hr/>
						<xsl:for-each select='$thisdoc/*/*[contains(@class," topic/topic ")]'>
							<div class='nestedComposite' style="border:thin pink solid; margin-left:2em;">
								<h3><xsl:value-of select='*[contains(@class," topic/title ")]'/></h3>
								<xsl:apply-templates select='*[contains(@class," topic/shortdesc ")]'/>
								<xsl:apply-templates select='*[contains(@class," topic/body ")]'/>
							</div>
						</xsl:for-each>
						-->
					</xsl:when>
					
					<xsl:when test="name($thisdoc/*[1]) = 'article'">
						<!-- is a wddx template -->
						<xsl:comment>-{is_wddx_template}</xsl:comment>
						<h3>UX Control: <xsl:value-of select="substring-before(@href,'.')"/></h3>
						<!--<h4>Shortdesc: (none)</h4>-->
						<xsl:apply-templates select='$thisdoc/*/data'/>
					</xsl:when>
					
					<xsl:otherwise>
						<!-- is a topic -->
						<xsl:comment>-{is_topic}</xsl:comment>
						<xsl:element name="h{$topicref_nesting}">
							<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
							<xsl:if test="$GENERATE-OUTLINE-NUMBERING='yes'">
								<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/><xsl:text>. </xsl:text>
							</xsl:if>
							<xsl:variable name='doctitle'><xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/title ")]'/></xsl:variable>
							<xsl:choose>
								<xsl:when test="@navtitle">
									<xsl:call-template name="newlink"/>
								</xsl:when>
								<xsl:when test="$doctitle">
									<xsl:value-of select="$doctitle"/>
								</xsl:when>
								<xsl:otherwise>
									<!-- force a value so that the element is not left empty. -->
									<xsl:value-of select="@href"/><br/>
									<xsl:call-template name="newlink"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
	<xsl:variable name="filename">
	<xsl:value-of select='substring-before($path,".dita")'/>
	</xsl:variable>
	<!-- This works. Now, wrap it with authentication.
	<sup><a class="a nav" href='browse/topic/{$filename}?edit'>·</a></sup>
	-->
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/titlealts ")]'/>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]'/>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/body ")]'/>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/related-links ")]'/>
		<xsl:if test='$thisdoc//*[contains(@class," topic/fn ")]'>
			<xsl:variable name="refseq"><xsl:value-of select="$thisdoc/*/@id"/></xsl:variable>
			<p>________</p>
			<dl style="margin-top: 0;">
			<xsl:for-each select='$thisdoc//*[contains(@class," topic/fn ")]'>
				<xsl:variable name="fnseq"><xsl:number count="fn" level="any"/></xsl:variable>
				<xsl:variable name="docpath"><xsl:value-of select="concat($serviceType,'/',$queryType,'/',$resourceName)"/></xsl:variable>
				<dt><sup><a href="{$docpath}#fntarg{$refseq}-{$fnseq}" name="fndesc{$refseq}-{$fnseq}">Footnote <xsl:value-of select="$fnseq"/></a></sup></dt>
				<dd style="font-size: smaller;"><xsl:apply-templates mode="endnotes"/></dd>
			</xsl:for-each>
			</dl>
		</xsl:if>
						<!-- now deal with literally nested topics in the local context (not just child topicrefs) -->
						<xsl:if test='$thisdoc/*/*[contains(@class," topic/topic ")]'>
							<div class='childTopics'>
								<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/topic ")]/*[contains(@class," topic/topic ")]' mode='nested'/>
							</div>
						</xsl:if>
						<!-- nested topicrefs are equivalent to child topics.  mode='ref-as-topic' -->
						<xsl:if test='*[contains(@class," map/topicref ")]'>
							<xsl:apply-templates/>
						</xsl:if>
					</xsl:otherwise>
					
				</xsl:choose>
	
				<xsl:if test='*[contains(@class," map/topicref ")]'>
					<xsl:comment>This mode causes duplicatiton, hence commented out for now.</xsl:comment>
					<!--xsl:apply-templates select='*[contains(@class," map/topicref ")]'/-->
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match='data'>
			<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topichead ")]'>
	    <xsl:variable name="topicref_nesting">
	      <xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref ")])'/>
	    </xsl:variable>
		<div class='{local-name(parent::*)} topichead'>
			<xsl:element name="h{$topicref_nesting}">
				<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
				<xsl:if test="$GENERATE-OUTLINE-NUMBERING='yes'">
					<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/><xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@navtitle">
						<xsl:value-of select="@navtitle"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- force a value so that the element is not left empty. -->
						<span style="color:red;"><xsl:value-of select="@href"/></span>
					</xsl:otherwise>
				</xsl:choose>
<xsl:comment>-{is_topichead}</xsl:comment>
			</xsl:element>
			<!-- Since topichead has no referenced content, we are done after placing the title. Time to recurse. -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topicgroup ")]'>
		<div class='{local-name(parent::*)} topicgroup'>
			<!-- Since topicgroup has no referenced content, we are done after creating a grouping div. Time to recurse. -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
		<div class='{local-name(parent::*)} topicmeta'>
			<b class="navtitle"><xsl:value-of select="@navtitle"/></b>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
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
				<!--
						<xsl:value-of select='$resource-fn'/>
				-->
				<xsl:variable name="dotted-href">
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text" select="$resource-fn" />
						<xsl:with-param name="replace" select="'/'" />
						<xsl:with-param name="by" select="'-'" />
					</xsl:call-template>
				</xsl:variable>
				<!-- The groupName and mapName values were passed in by the calling context (known context) -->
				<xsl:value-of select="$groupName"/>/<xsl:value-of select="$mapName"/>/<xsl:value-of select="$dotted-href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
	<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
	<span class="navtitle">
		<xsl:choose>
			<xsl:when test="@navtitle">
				<xsl:value-of select="@navtitle"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- force a value so that the element is not left empty. -->
				<span style="color:darkgreen;text-decoration:italic;"><xsl:value-of select="@href"/></span>
			</xsl:otherwise>
		</xsl:choose>
	</span>
	<!--
	<sup><a class="a nav" href='{$fixedhref}?edit'>·</a></sup>
	-->
</xsl:template>


	<!-- Misc Elements -->
	<xsl:template match='*[contains(@class," topic/fn ")]'>
		<xsl:variable name="refseq"><xsl:value-of select="/*/@id"/></xsl:variable>
		<xsl:variable name="fnseq"><xsl:number count="fn" level="any"/></xsl:variable>
		<xsl:variable name="docpath"><xsl:value-of select="concat($serviceType,'/',$queryType,'/',$resourceName)"/></xsl:variable>
  		<sup><a href="{$docpath}#fndesc{$refseq}-{$fnseq}" name="fntarg{$refseq}-{$fnseq}">Footnote <xsl:value-of select="$fnseq"/></a></sup>
	</xsl:template>

	<xsl:template name="mapendnotes"><!-- called from topic element context; var $thisdoc can't work in named template :( -->
	</xsl:template>


</xsl:stylesheet>