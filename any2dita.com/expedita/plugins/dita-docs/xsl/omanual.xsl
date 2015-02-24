<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="xsi"
>

<!--
| C:\DITA-OT1.5.3>java -jar lib\saxon\saxon9.jar omanual_procedure_0.3.xsd xsd2dtd.xsl > omanual.dtd
+-->


	<!-- transforms for topics and their derivations -->
	<!--
	<xsl:import href="html/topic.xsl"/>
	<xsl:import href="html/domains.xsl"/>
	<xsl:import href="html/utilities.xsl"/>
	<xsl:import href="html/task.xsl"></xsl:import>
	<xsl:import href="html/reference.xsl"></xsl:import>
	-->
	<xsl:import href="html/utilities.xsl"/>
	<!-- Transforms for maps -->
	<!-- Not needed in aggregatemap, which IS the map shell -->
	
	<!-- Transforms for ditaval visualization/editing -->
	<!--
	<xsl:import href="html/props.xsl"/>
	-->
	
	<!-- import specializations in the override priority position -->
	<!--
	<xsl:import href="msgref/msg2xhtml.xsl"/>
	<xsl:import href="faq/faq2html.xsl"/>
	<xsl:import href="ts/tsTroubleshooting.xsl"/>
	-->

	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/>
  
    

	<!--     layout related -->
	<xsl:param name="groupName" select="'Home'"/>
	<xsl:param name="mapName" select="''"/>
	<xsl:param name="contentDir" select="'content'"/>
	<xsl:param name="contentFile" select="'Overview.dita'"/>
	<xsl:param name="userDir" select="'.'"/>
	<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>
	<xsl:param name="GENERATE-OUTLINE-NUMBERING" select="'no'"/>
	<xsl:param name="SHOW-TOPIC" select="'yes'"/>
	

	<xsl:output method="xml"
	            encoding="utf-8"
	            indent="yes"
	 />

 <xsl:variable name="outermostElementName" select="name(/*)" />
	
	<!-- markup conversion: map elements -->
	<xsl:template match='/' >
		<xsl:comment>[<xsl:value-of select="$outermostElementName"/>]</xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>


	<xsl:template name='map' match='map | *[contains(@class," map/map ")]'>
			<!-- specifically process the title here -->
			<xsl:apply-templates select='*[contains(@class," map/title ")]'/>
			<!-- specifically process the top-level metadata here -->
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
			
			<!-- ( topicref or topichead or topicgroup or... -->
			<!-- QUESTION: for oManual production, should we serialize or follow the nesting? -->
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			
			<!-- ( navref or anchor or reltable or data or data-about) (any number) )-->
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
	</xsl:template>


	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- Need to add processing support for these eventually! -->
	</xsl:template>


	<!-- =============common content=============== -->

	<xsl:template match='@title' mode='skip'/>
	<xsl:template match='*[contains(@class," topic/title ")]' mode='skip'/>

	<xsl:template match='dita' mode='passthru'>
		<p>In 'dita' template.</p>
		<xsl:apply-templates mode='passthru'/>
	</xsl:template>

	<!-- =============recursive topicrefs=============== -->



	<xsl:template name='topicref' match='*[contains(@class," map/topicref ")][@format="dita" or not(@format)]'>
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
		<xsl:variable name="fullPath">
			<xsl:value-of select="concat($contentDir,'/',$groupName,'/',@href)"/>
		</xsl:variable>
		<!-- in expeDITA, at least, the fullPath is the wrong relative path; use $path here -->
		<xsl:variable name='thisdoc' select='document($path,.)'/>

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
			<xsl:otherwise>
				<!-- is a topic -->
 				<xsl:variable name="outermostExtEntName" select="name($thisdoc/*)" />
				<xsl:comment>-{is_topic of type: <xsl:value-of select='$outermostExtEntName'/>}</xsl:comment>
				<!--
				<xsl:element name="h{$topicref_nesting}">
					<xsl:attribute name="class">topictitle<xsl:value-of select="$topicref_nesting"/></xsl:attribute>
					<xsl:if test="$GENERATE-OUTLINE-NUMBERING='yes'">
						<xsl:number level="multiple" format="1.1" count='*[contains(@class," map/topicref ")]'/><xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="@navtitle">
							<xsl:call-template name="newlink"/>
						</xsl:when>
						<xsl:otherwise>
							<span style="color:red;"><xsl:value-of select="@href"/>/<xsl:call-template name="newlink"/></span>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				-->
<!--
-->
	
				<procedure locale="en"
						 xmlns="http://omanual.com" 
						 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
						 xsi:schemaLocation="http://omanual.com/openmanual_0.2.xsd"
						 >
					
				  	<!-- These elements must occur, exactly once each -->
					<title>
						<xsl:apply-templates select='$thisdoc/*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]' />
					</title><xsl:text>
</xsl:text>
					<summary>
						<xsl:value-of select="'{summary}'"/>
					</summary><xsl:text>
</xsl:text>
					<image>
						<xsl:apply-templates select='$thisdoc//*[contains(@class," topic/image ")][1]'/>
					</image><xsl:text>
</xsl:text>

					<author id="1">
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/author ")][1]'/>
					</author><xsl:text>
</xsl:text>

					<time_required>
						<xsl:value-of select="'{time required}'"/>
					</time_required><xsl:text>
</xsl:text>

					<difficulty>
						<xsl:value-of select="'{Easy (or not)}'"/>
					</difficulty><xsl:text>
</xsl:text>

					<categories>
					  <category><xsl:value-of select="'{MacBook Core Duo}'"/></category>
					</categories><xsl:text>
</xsl:text>

					<introduction>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]/.'/>
					</introduction><xsl:text>
</xsl:text>

					<introduction_rendered>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]'/>
					</introduction_rendered><xsl:text>
</xsl:text>

					<tools>
						<xsl:value-of select="'{}'"/>
					</tools><xsl:text>
</xsl:text>

					<parts>
						<xsl:value-of select="'{}'"/>
					</parts><xsl:text>
</xsl:text>

					<flags>
						<xsl:value-of select="'{}'"/>
					</flags><xsl:text>
</xsl:text>

					<documents>
						<xsl:value-of select="'{}'"/>
					</documents><xsl:text>
</xsl:text>

					<prerequisites>
						<xsl:value-of select="'{}'"/>
					</prerequisites><xsl:text>
</xsl:text>

					<steps>
						<xsl:value-of select="'{}'"/>
					</steps><xsl:text>
</xsl:text>

					<conclusion>
						<xsl:value-of select='$thisdoc/*/*/*[contains(@class," topic/example ")]'/>
					</conclusion><xsl:text>
</xsl:text>

					<!--
					-->

				</procedure>
				<!--
				<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/titlealts ")]'/>
				<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]'/>
				<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/body ")]'/>
				<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/related-links ")]'/>
				<xsl:if test='$thisdoc/*/*[contains(@class," topic/topic ")]'>
					<div class='childTopics'>
						<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/topic ")]/*[contains(@class," topic/topic ")]' mode='nested'/>
					</div>
				</xsl:if>
				<xsl:if test='*[contains(@class," map/topicref ")]'>
					<xsl:apply-templates/>
				</xsl:if>
				-->
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<xsl:apply-templates select='*[contains(@class," map/xtopicref ")]'/>
		</xsl:if>
	</xsl:template>

	<!-- missed element catch-all -->
	<!-- pass any other nodes through unchanged/ use class value to retrieve unchanged -->
	<xsl:template match="*">
		<span class="unmatched {name(.)}" style="background-color: yellow">
			<xsl:copy-of select="."/>
		</span>
	</xsl:template>



<xsl:template match="title">
	<xsl:apply-templates/>
</xsl:template>


<xsl:template match="shortdesc">
	<xsl:apply-templates/>
</xsl:template>


<!-- Simplified HTML: extent of output variability -->
<!--
elements:
<p><a><strong><em><h1><h2><h3><h4><h5><h6><tt><pre><code><br><ul><li><sub><sup><del><ins><div>

atts:
id, class, href, style, rel, title, target
-->
	
	
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
				<xsl:variable name="dotted-href">
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text" select="$resource-fn" />
						<xsl:with-param name="replace" select="'/'" />
						<xsl:with-param name="by" select="'.'" />
					</xsl:call-template>
				</xsl:variable>
				<!-- The groupName and mapName values were passed in by the calling context (known context) -->
				<xsl:value-of select="$groupName"/>/<xsl:value-of select="$mapName"/>/<xsl:value-of select="$dotted-href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<a class="a nav" href='{$fixedhref}?edit'>
		<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<span class="navtitle">
			<xsl:choose>
			<!--
					<xsl:when test="$resource-ext = 'xml'">
						<xsl:value-of select="serviceType"/>/xml/<xsl:value-of select="$dotted-href"/>
					</xsl:when>
					<xsl:when test="$resource-ext = 'dita'">
						<xsl:value-of select="$serviceType"/>/topic/<xsl:value-of select="$dotted-href"/>
					</xsl:when>
					<xsl:when test="$resource-ext = 'ditamap'">
						<xsl:value-of select="$serviceType"/>/ditamap/<xsl:value-of select="$dotted-href"/>
					</xsl:when>
					<xsl:when test="$resource-ext = 'ditaval'">
						<xsl:value-of select="$serviceType"/>/ditaval/<xsl:value-of select="$dotted-href"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$serviceType"/>/<xsl:value-of select="$resourceType"/>/<xsl:value-of select="$dotted-href"/>
					</xsl:otherwise>
			-->
				<xsl:when test="@navtitle">
					<xsl:value-of select="@navtitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- force a value so that the element is not left empty. -->
					<span style="color:darkgreen;text-decoration:italic;"><xsl:value-of select="@href"/></span>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</a>
</xsl:template>



</xsl:stylesheet>
