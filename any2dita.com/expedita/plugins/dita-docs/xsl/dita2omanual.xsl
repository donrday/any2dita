<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="xsi"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
>

<!-- 
| ***Note on how to convert a schema into DTD for tools requiring that format (xsd2dtd is from Syntext's old site)***
| C:\DITA-OT1.5.3>java -jar lib\saxon\saxon9.jar omanual_procedure_0.3.xsd xsd2dtd.xsl > omanual.dtd
+-->

	<!-- pick up some expeDITA utility functions -->
	<xsl:import href="html/utilities.xsl"/>
	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/> 

	<!--  layout/diagnostic related parameters -->
	<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>
	<xsl:param name="GENERATE-OUTLINE-NUMBERING" select="'no'"/>
	<xsl:param name="SHOW-TOPIC" select="'yes'"/>
	

	<!-- set the result tree (output) encoding -->
	<xsl:output method="xml"
	            encoding="utf-8"
	            indent="yes"
	 />

	<!-- Pick up some environment values that we might access globally. -->
	<xsl:variable name="outermostElementName" select="name(/*)" />
	
	<!-- Root template: first stop for all processes (common starting conditions). -->
	<xsl:template match='/' >
		<xsl:comment>Document element: <xsl:value-of select="$outermostElementName"/></xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Entry point for any topic or non-specific, topic-based specialization (maps to oManual topic). -->
	<xsl:template name='topic' match='*[contains(@class," topic/topic ")]'>
		<xsl:comment>Transform entry point for: DITA topic to oManual topic (general)</xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- Entry point for concept (maps to oManual topic). -->
	
	<!-- Entry point for reference (maps to oManual topic). -->
	
	<!-- Entry point for task (maps to oManual guide or procedure). -->
	<xsl:template name='task' match='*[contains(@class," topic/task ")]'>
		<xsl:comment>Transform entry point for: DITA task to oManual guide (procedural)</xsl:comment>
		<!-- call the topic processor essentially as a subroutine -->		
		<xsl:call-template name="template_procedure">
			<xsl:with-param name="thisdoc" select="$tempdoc"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Entry point for any map or map-based specialization. -->
	<!-- The map transforms leave behind content that was originally intended to be collected and
		saved as the "manifest" context. Next rev will convert this into a topic instead.
	-->
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

<!-- QUESTION: Should we come up with a pattern for generating filenames and pathnames for the result set? -->
<!-- eg, "{$segment_qualifier}/{$resource_qualifier}-{$product_qualifier}-{$version_number}" 
	which can be parsed for either immediate internal conversion or passed through for grep/replace.
-->
		
		<!-- ( topicref or topichead or topicgroup or... -->
		<!-- QUESTION: for oManual production, should we serialize or follow the nesting? 
				Currently, 2nd-level procedures are being skipped; need to rationalize how to
				walk a tree with respect to preferred oManual restructuring.
				logical folders vs physical source folders
		-->
		<!-- Note that based on 1.0 architecture, this will change to <topic> syntax and content model. -->
		<manifest locale="{$thislang}" id="{$thisid}"
				xmlns="http://omanual.com" 
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				>
			<title><xsl:value-of select="$thistitle"/></title>

			<!-- specifically process the top-level metadata here -->
			<!--xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/-->
			<description>{use shortdesc content here?}</description>
			<categories>
				<category>{pull topicmeta category content here}</category>
			</categories>

			<!-- wrap our recursive contained procedures (now guides; will change later) -->
			<procedures>
				<!-- this is the recursive drill-down into the map; will include topicheads and groups -->
				<!-- QUESTION: how to map a topichead or topicgroup into an oManual package view? -->
				<!-- A  topicref is the normal reference to a topic that will replace the reference on output;
					a topichead is a title-only container for titled hierarchies;
					a topicgroup is a title-less container for applying common processing/styling to a set of topics.-->
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</procedures>
			
			<!-- QUESTION: what is best practice for placement of this element in a manifest? 
				(and this might be moot now that we are changing to the <topic> output model instead)
			-->
			<documents>
				<!-- QUESTION: DITA has no direct equivalent for this data; map reltable into this? -->
				<document id="12012" type="device">iPhone-5.xml</document>
			</documents>
		</manifest>			

		<!-- QUESTION: What is best practice for package level metadata:
				1. mapping existing DITA metadata into oManual (square peg in round hole analogy)
			 	2. creating a domain specialization to represent it more directly (recommended)
			 	3. other that we have not considered yet? Same issues will apply to DocBook, for example.
		-->
		
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
					At this point, we have a topic in the variable $tempdoc. We can get the title and can generate
					a category entry for this topic/procedure/guide/manual for the manifest.
					When we call the procedure, we leave the context of the topic container, so do any
					topic attribute processing here.
				-->

				<!-- Build some values to insert into the procedure templates -->
				<xsl:variable name="outproc">procedure</xsl:variable>
				<!-- outpath is currently relative to the calling processor (c:/wamp/www/q in this case) -->
				<xsl:variable name="outputpath">_temp</xsl:variable>
				
				<xsl:variable name="thistitle">
					<xsl:apply-templates select='$tempdoc/*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]' />
				</xsl:variable>
				<xsl:variable name="namespace">om_</xsl:variable>
				<xsl:variable name="spacedash1"><xsl:value-of select="translate($thistitle,' - ','_')"/></xsl:variable>
				<xsl:variable name="spacedash"><xsl:value-of select="translate($spacedash1,' ','-')"/></xsl:variable>
				<xsl:variable name="topictitleid"><xsl:value-of select="$namespace"/><xsl:value-of select="translate($spacedash, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:variable>
				<xsl:variable name="thisid">
					<xsl:choose>
						<xsl:when test="$tempdoc/@id !=''">
							<xsl:value-of select="$tempdoc/@id"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select='$topictitleid' />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
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
				<!-- QUESTION: At this point, we need to map the filename to a published URL...
					This logic effectively changes the transform into a build system.
					Should this and other possible build behaviors be left to Dozuki?
					Should we be mapping to an intermediate "submit to Dozuki" format first?
					We'll make up a name based on our computed ID which we had anyway, but it is not
					the same logic that the publishing system would actually generate.
				-->
				<xsl:variable name="thisRESTfulName">
					<xsl:value-of select="$topictitleid"/>_topicORprocedure_v1/10525/1
				</xsl:variable>
				<!-- Based on some combo of title/id, we have a unique $thisid for this item. {$outputpath}/ -->

				<!-- build the reference wrapper for the manifest. -->
				<!-- QUESTION: All assets should be listed here; we are only processing guides and topics. What else? -->
				
				<xsl:choose>
					<xsl:when test='$outproc = "procedure"'>
						<xsl:comment>Content saved to: <xsl:value-of select="$outputpath"/><xsl:value-of select="$topictitleid"/>_procedure_v1.xml</xsl:comment>
						<!-- generate the reference for the manifest -->
						<procedure id="{$topictitleid}" subject="{$thistitle}" type="teardown">
							<title><xsl:value-of select='$thistitle' /></title>
							<url>http://www.ifixit.com/Teardown/<xsl:value-of select='$thisRESTfulName' />/10525/1</url>
							<thumbnail>http://www.ifixit.com/igi/1nDsDmwjsuxhZSJH.thumbnail</thumbnail>
							<image_url>http://www.ifixit.com/igi/1nDsDmwjsuxhZSJH</image_url>
							<path><xsl:value-of select='$thisRESTfulName' />-10525/procedure.xml</path>
						</procedure>
						<!-- generate the external file version of the transformed task -->
				    	<exsl:document 
							href="{$outputpath}/{$topictitleid}_procedure_v1.xml" 
							method="xml">
							<xsl:call-template name="chunkProcedure">
								<xsl:with-param name="thisdoc" select="$tempdoc"/>
								<xsl:with-param name="thislang" select="$thislang"/>
								<xsl:with-param name="thistitle" select="$thistitle"/>
								<xsl:with-param name="thisid" select="$thisid"/>
							</xsl:call-template>
						</exsl:document>
					</xsl:when>
					<xsl:otherwise>
						<xsl:comment>Content saved to: <xsl:value-of select="$outputpath"/><xsl:value-of select="$topictitleid"/>_topic_v1.xml</xsl:comment>
						<!-- generate the reference for the manifest -->
						<topic id="{$topictitleid}" subject="{$thistitle}" type="teardown">
							<title><xsl:value-of select='$thistitle' /></title>
							<url>http://www.ifixit.com/Teardown/<xsl:value-of select='$thisRESTfulName' />/10525/1</url>
							<thumbnail>http://www.ifixit.com/igi/1nDsDmwjsuxhZSJH.thumbnail</thumbnail>
							<image_url>http://www.ifixit.com/igi/1nDsDmwjsuxhZSJH</image_url>
							<path><xsl:value-of select='$thisRESTfulName' />-10525/procedure.xml</path>
						</topic>
						<!-- generate the external file version of the transformed task -->
				    	<exsl:document 
							href="{$outputpath}/{$topictitleid}_topic_v1.xml" 
							method="xml">
							<xsl:call-template name="chunkTopic">
								<xsl:with-param name="thisdoc" select="$tempdoc"/>
								<xsl:with-param name="thislang" select="$thislang"/>
								<xsl:with-param name="thistitle" select="$thistitle"/>
								<xsl:with-param name="thisid" select="$thisid"/>
							</xsl:call-template>
						</exsl:document>
					</xsl:otherwise>
				</xsl:choose>
				

			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<xsl:apply-templates select='*[contains(@class," map/xtopicref ")]'/>
		</xsl:if>
	</xsl:template>

<!-- QUESTION: For each type, is the pattern sequence important to expose to user customization? -->

<xsl:template name="chunkTopic">
	<!-- get the topic data that was passed in from the map or task context -->
	<xsl:param name="thisdoc"/>
	<xsl:param name="thislang"/>
	<xsl:param name="thistitle"/>
	<xsl:param name="thisid"/>

	<!-- format for a pattern driven end result: -->
	<topic locale="{$thislang}" id="{$thisid}"
			xmlns="http://omanual.com" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			xsi:schemaLocation="http://omanual.com/openmanual_0.2.xsd"
			>

<xsl:text>
</xsl:text>
		
	  	<!-- These elements must occur, exactly once each -->
		<title><xsl:value-of select='$thistitle' /></title><xsl:text>
</xsl:text>

		<!-- build out here -->

		<!-- topic_info -->

		<!-- image -->
		<!-- QUESTION: How to designate a hero or banner image? Should the alternate sizes be generated by iFixit production? -->
		<image>image:first image element anywhere<br/>
			<xsl:apply-templates select='$thisdoc//*[contains(@class," topic/image ")][1]'/>
		</image><xsl:text>
</xsl:text>
		<!-- description -->

		<!-- flags -->
		<flags>tools:no analog<br/>
			<xsl:value-of select="'{flags}'"/>
		</flags><xsl:text>
</xsl:text>

		<!-- categories -->
		<categories>
			<category><xsl:value-of select="'{MacBook Core Duo}'"/></category>
		</categories><xsl:text>
</xsl:text>

		<!-- solutions -->

		<!-- parts -->
		<parts>tools:no analog<br/>
			<xsl:value-of select="'{parts}'"/>
		</parts><xsl:text>
</xsl:text>

		<!-- tools -->
		<tools>tools:no analog<br/>
			<xsl:value-of select="'{tools}'"/>
		</tools><xsl:text>
</xsl:text>

		<!-- contents -->
		<contents>
			<xsl:apply-templates/> <!-- this is not the ideal mapping yet, just a fallthrough to see what we catch-->
		</contents><xsl:text>
</xsl:text>

	</topic>

</xsl:template>

<xsl:template name="chunkProcedure">
	<!-- get the topic data that was passed in from the map or task context -->
	<xsl:param name="thisdoc"/>
	<xsl:param name="thislang"/>
	<xsl:param name="thistitle"/>
	<xsl:param name="thisid"/>


	<!-- format for a pattern driven end result: -->
	<procedure locale="{$thislang}" id="{$thisid}"
			xmlns="http://omanual.com" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			xsi:schemaLocation="http://omanual.com/openmanual_0.2.xsd"
			><xsl:text>
</xsl:text>
		
	  	<!-- These elements must occur, exactly once each -->
		<title><xsl:value-of select='$thistitle' /></title><xsl:text>
</xsl:text>

		<!-- QUESTION: Do we want to generate a complete template, even if some elements could be empty? -->
		<summary>
			<xsl:value-of select="'{summary}'"/>
		</summary><xsl:text>
</xsl:text>

		<!-- QUESTION: How to designate a hero or banner image? Should the alternate sizes be generated by iFixit production? -->
		<image>image:first image element anywhere<br/>
			<xsl:apply-templates select='$thisdoc//*[contains(@class," topic/image ")][1]'/>
		</image><xsl:text>
</xsl:text>

		<author id="1">author:first author element anywhere<br/>
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

		<introduction>introduction:shortdesc<br/>
			<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]/.'/>
		</introduction><xsl:text>
</xsl:text>

		<introduction_rendered>introduction_rendered:copy of shortdesc<br/>
			<xsl:apply-templates select='$thisdoc/*/*[contains(@class," topic/shortdesc ")]'/>
		</introduction_rendered><xsl:text>
</xsl:text>

		<tools>tools:no analog<br/>
			<xsl:value-of select="'{tools}'"/>
		</tools><xsl:text>
</xsl:text>

		<parts>tools:no analog<br/>
			<xsl:value-of select="'{parts}'"/>
		</parts><xsl:text>
</xsl:text>

		<flags>tools:no analog<br/>
			<xsl:value-of select="'{flags}'"/>
		</flags><xsl:text>
</xsl:text>

		<documents>tools:no analog<br/>
			<xsl:value-of select="'{documents}'"/>
		</documents><xsl:text>
</xsl:text>

		<prerequisites>
			<xsl:apply-templates select='$thisdoc/*/*[contains(@class," task/prereqs ")]'/>
		</prerequisites><xsl:text>
</xsl:text>

		<steps>
			<xsl:comment>IN STEPS</xsl:comment>
			<xsl:apply-templates/><!-- select='$thisdoc/*/*[contains(@class," task/steps ")]'/-->
		</steps><xsl:text>
</xsl:text>

		<conclusion>
		<xsl:comment>Result</xsl:comment>
			<xsl:value-of select='$thisdoc//*[contains(@class," topic/result ")]'/>
		<xsl:comment>Example</xsl:comment>
			<xsl:apply-templates select='$thisdoc//*[contains(@class," topic/example ")]'/>
		<xsl:comment>Postreq</xsl:comment>
			<xsl:value-of select='$thisdoc//*[contains(@class," topic/postreq ")]'/>
		</conclusion><xsl:text>
</xsl:text>

	</procedure>
</xsl:template>

<!-- calls to these container elements simply pass through; the container is "invisible" -->
<xsl:template match='*[contains(@class," topic/example ")]'>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="title">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="shortdesc">
	<xsl:apply-templates/>
</xsl:template>



	<!-- Element matches placed here are for DITA body content that must be mapped into an available simplifiedHTML element:
		one of:
	      p | a | strong | em | h1 | h2 | h3 | h4 | h5 | h6 | tt | pre | code | ul | li | br | sub | sup | del | ins | div
	    and map DITA atts as possible into one of:
	      id | class | href | style | rel | title | target
	-->

	<!-- For DITA maps, this module maps DITA atts to closest matching oManual HTML atts. -->
	<!-- topicref-atts: collection-type, processing-role, type, scope, locktitle, format, linking, toc, print, search, chunk -->
	
	<!-- For DITA topics, this module maps DITA atts to closest matching oManual HTML atts. -->
	<!-- common: keyref, outputclass, class, xml:space (high candidates) -->
	<!-- unique issues: href, keys, keyref, con*, type, format, scope, role -->
	<!-- display-atts: scale, frame, expanse (possible mappings) -->
	<!-- global-atts: xtrf, xtrc (not applicable in the om architecture) -->
	<!-- id-atts: id, conref, conrefend, conaction, conkeyref (other than id, rest are consumed by processing) -->
	<!-- select-atts: props, base, platform, product, audience, otherprops, importance, rev, status (inspect) -->
	<!-- localization-atts: translate, xml:lang, dir (utilize xml:lang for locale) -->
	<!-- relational-atts: type, format, scope, role, otherrole (inspect) -->
	<xsl:template name="checkHTMLatts">
		<!-- Note that we are processing DITA attributes in terms of the allowed HTML result subset. -->
		<xsl:if test="@id !=''">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<xsl:if test="@outputclass !=''">
				<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
		<xsl:if test="@href !=''">
				<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute></xsl:if>
				
		<!-- These are placeholders for the result values; the test names are NOT YET mapped DITA att names! -->
		<xsl:if test="@style !=''">
				<xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute></xsl:if>
		<xsl:if test="@rel !=''">
				<xsl:attribute name="rel"><xsl:value-of select="@rel"/></xsl:attribute></xsl:if>
		<xsl:if test="@title !=''">
				<xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if>
		<xsl:if test="@target !=''">
				<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute></xsl:if>
	</xsl:template>

	<!-- allowed "simplifiedHTML" content, from github version .04 schema -->
	<!-- Note that *-- indicates a reasonably tested output, does not need to be rehashed for now. -->

<!-- p *-->
<xsl:template match='*[contains(@class," topic/p ")]'>
	<p xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<!-- a -->
<xsl:template match='*[contains(@class," topic/a ")]'>
	<a xmlns="http://omanual.com">
		<!-- need to ensure that href syntax is mapped properly per @format rules;
			grab link content per DITA processing results based on map conditions -->
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</a>
</xsl:template>

<!-- strong *-->
<xsl:template match='*[contains(@class," hi-d/b ")]'>
	<strong xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</strong>
</xsl:template>

<!-- em *-->
<xsl:template match='*[contains(@class," hi-d/i ")]'>
	<em xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</em>
</xsl:template>

<!-- h1 -->
<!-- h2 -->
<!-- h3 -->
<!-- h4 -->
<!-- h5 -->
<!-- h6 -->
<xsl:template match='*[contains(@class," topic/title ")]'>
	<xsl:variable name="hdlvl">
      <xsl:value-of select='count(ancestor-or-self::*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")])'/>
    </xsl:variable>
    <!-- QUESTION: Can this level ever *reasonably* descend past 6? Should it descend from a display context level? -->
    <!-- NOTE: We discussed the option of using an offset value to slide this presentation up or down with respect to
    	a presumed display context (if the page heading is h1, let the block content start at h2, etc.)
    -->
	<xsl:element name="h{$hdlvl}" xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</xsl:element>
</xsl:template>


<!-- tt *-->
<xsl:template match='*[contains(@class," hi-d/tt ")]'>
	<tt xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</tt>
</xsl:template>

<!-- pre *-->
<xsl:template match='*[contains(@class," topic/pre ")]'>
	<pre xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</pre>
</xsl:template>

<!-- code *-->
<xsl:template match='*[contains(@class," pr-d/codeblock ")]'>
	<code xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</code>
</xsl:template>

<!-- ul *-->
<xsl:template match='*[contains(@class," topic/ul ")]'>
	<ul xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</ul>
</xsl:template>

<!-- li *-->
<xsl:template match='*[contains(@class," topic/li ")]'>
	<li xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</li>
</xsl:template>

<!-- br *-->
<xsl:template match='*[contains(@class," topic/null ")]'><!-- No semantic equivalent -->
	<br xmlns="http://omanual.com" />
</xsl:template>

<!-- sub *-->
<xsl:template match='*[contains(@class," hi-d/sub ")]'>
	<sub xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</sub>
</xsl:template>

<!-- sup *-->
<xsl:template match='*[contains(@class," hi-d/sup ")]'>
	<sup xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</sup>
</xsl:template>

<!-- del *-->
<xsl:template match='*[contains(@class," topic/null ")]'><!-- No semantic equivalent -->
	<del xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</del>
</xsl:template>

<!-- ins *-->
<xsl:template match='*[contains(@class," topic/null ")]'><!-- No semantic equivalent -->
	<ins xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</ins>
</xsl:template>

<!-- div *-->
<xsl:template match='*[contains(@class," topic/section ")] | *[contains(@class," topic/example ")]'>
	<div xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>





<!-- DITA content for which there are no direct mappings in oManual markup. -->
<!-- Fallthrough processing will handle reasonable support for domains for now. -->

<!-- Definition list: -->
<xsl:template match='*[contains(@class," topic/dl ")]'>
	<!-- NOTE: oM lacks a dl target; convert in ul with bolded term -->
	<ul xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</ul>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dlentry ")]'>
	<li xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</li>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dt ")]'>
	<strong xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</strong>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dd ")]'>
	<!-- A paragraph within list item mimics a definition list's dd container. -->
	<p xmlns="http://omanual.com">
		<xsl:call-template name="checkHTMLatts"/>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match='*[contains(@class," topic/table ")]'>
</xsl:template>

<xsl:template match='*[contains(@class," topic/simpletable ")]'>
<!-- Note that some specializations of this might fit into ul; need to determine case by case. -->
</xsl:template>


	<!-- missed element catch-all -->
	<!-- pass any other nodes through unchanged/ use class value to retrieve unchanged -->
	<xsl:template match="*">
		<span class="unmatched {name(.)}" style="background-color: yellow">
			<xsl:copy-of select="."/>
		</span>
	</xsl:template>



<!-- Legacy code that might be needed later; currently not utilized. -->	
	
	<!-- traps for elided content -->
	<xsl:template match='@title' mode='skip'/>

	<xsl:template match='*[contains(@class," topic/title ")]' mode='skip'/>

	<xsl:template match='dita' mode='passthru'>
		<p>In 'dita' template.</p>
		<xsl:apply-templates mode='passthru'/>
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

	<!--
	format for a topic-driven end result:
	<xsl:apply-templates select='$tempdoc/*/*[contains(@class," topic/titlealts ")]'/>
	<xsl:apply-templates select='$tempdoc/*/*[contains(@class," topic/shortdesc ")]'/>
	<xsl:apply-templates select='$tempdoc/*/*[contains(@class," topic/body ")]'/>
	<xsl:apply-templates select='$tempdoc/*/*[contains(@class," topic/related-links ")]'/>
	<xsl:if test='$tempdoc/*/*[contains(@class," topic/topic ")]'>
		<div class='childTopics'>
			<xsl:apply-templates select='$tempdoc/*/*[contains(@class," topic/topic ")]/*[contains(@class," topic/topic ")]' mode='nested'/>
		</div>
	</xsl:if>
	<xsl:if test='*[contains(@class," map/topicref ")]'>
		<xsl:apply-templates/>
	</xsl:if>
	-->

	<!-- Notes on php-specific xslt multi-document output setup:  -->
	<!-- http://www.ibm.com/developerworks/xml/library/x-tipmultxsl/index.html -->
	<!-- xslt 2.0: xsl:result-document href="{@id}.dita" format="xml"-->
	<!-- for PHP's libxslt, use exsl extension: http://www.exslt.org/exsl/elements/document/index.html -->


</xsl:stylesheet>
