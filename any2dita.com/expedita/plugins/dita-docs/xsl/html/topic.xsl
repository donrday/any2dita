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
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:lookup="http://example.com/lookup"
    extension-element-prefixes="lookup"
    xmlns:php="http://php.net/xsl"
    xsl:extension-element-prefixes="php"
	exclude-result-prefixes="php" 
    >

	<!-- table support -->
	<xsl:import href="cals2htmlRagulf.xsl"/>
	<xsl:import href="t2hsimpletable.xsl"/>
	<!--xsl:import href="t2htables.xsl"/-->

	<!-- local parameters -->
	<!--     layout related -->
	<xsl:param name="GENERATE-TASK-LABELS" select="'yes'"/>
	<xsl:param name="DEBUG" select="'no'"/>
	<xsl:param name="SHOW-CONREFMARKUP" select="'yes'"/>
	<xsl:param name="SHOW-INDEXTERM" select="'no'"/>
	<xsl:param name="SHOW-SLIDES" select="'yes'"/>
	<xsl:param name="DRAFT" select="'no'"/>


	<xsl:param name="mode" select="'content'"></xsl:param>
	<xsl:param name='userRole' select="''"/>
	<xsl:param name='siteRole' select="''"/>
	
	<!-- internal constants -->
	<xsl:param name="Lang" select="'en-US'"/>
	<xsl:param name="get_call" select="''"/>
	<!-- the path for the strings file must be relative to where THIS file is located -->
	<xsl:variable name="StringFile" select="document('../strings/strings.xml')"/>
	<xsl:variable name="PrimaryLang" select="substring-before($Lang,'-')"/>
	
	<!-- application values used in transforms -->
<xsl:param name="byelement" select="'topictitle'"/>
<xsl:param name="headlevel1" select="'1'"/>
<xsl:param name="headclass1" select="''"/>
<xsl:param name="classlevel1" select="''"/>
	<xsl:param name="themePath" select="''"/>
	<xsl:param name="contentPath" select="''"/>
	<xsl:param name="restPath" select="''"/>
	<xsl:param name="contentDir" select="''"/>
	<xsl:param name="groupName" select="'Home'"/>
	<xsl:param name="mapName" select="'Home'"/>
	<xsl:param name="serviceType" select="'admin'"/>
	<xsl:param name="queryType" select="'topic'"/><!-- holds the context for links in the application space -->
	<xsl:param name="resourceType" select="'topic'"/><!-- less meaningful here than queryType -->
	<xsl:param name="resourceName" select="'Home'"/>
	<xsl:param name="resourceExt" select="''"/>
	<xsl:param name="contentFile" select="''"/>
	<xsl:param name="topictitleMeta" select="''"/>
	<xsl:param name="contentFile" select="'Home.dita'"/>
	<xsl:param name="userDir" select="''"/>
	<xsl:param name="conditionalRules" select="''"/>
	<xsl:param name="relPath" select="'../'"/>
	<xsl:param name="phpmsg" select="''"/>
	<xsl:param name="queryPath" select="''"/>

  <xsl:variable name="adjustedPath">
 	 <xsl:value-of select="$groupName"/><!-- might be serviceType for other URL schemes... -->
  </xsl:variable>

<!-- set a value to determine edit authority. Any value causes prevention; values show which condition triggered -->
<!-- successive matches exit when the last valid match is made; the value at that point is the return value.-->
<xsl:variable name="isPrevented">
<xsl:if test='$userRole != "siteadmin"'>
	<xsl:choose>
		<xsl:when test='$siteRole = "open"'></xsl:when>
		<xsl:when test='$siteRole = "publish"'>read-only, </xsl:when>
		<xsl:when test='$siteRole = "collaborate"'>
			<xsl:if test='$groupName != $userGroup'>not the user's group, </xsl:if>
			<xsl:if test='$userRole = "reader"'>user is reader, </xsl:if>
			<xsl:if test='$userRole = ""'>user is not logged in, </xsl:if>
		</xsl:when>
		<xsl:when test='$userRole = "groupadmin"'></xsl:when>
		<xsl:otherwise>prevented by default--some test failed.</xsl:otherwise>
	</xsl:choose>
</xsl:if>
</xsl:variable>
<!-- groupadmin privileges mainly apply to admin access; they are a normal group user otherwise. -->
	
	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/>
	  
	  
	<!-- utilities for the php interaction -->
	
	<!-- language utilities -->
<!-- some language/directionality templates -->
<lookup:languages>
    <lookup:lang lang-code='de'>ltr</lookup:lang>
    <lookup:lang lang-code='en'>ltr</lookup:lang>
    <lookup:lang lang-code='es'>ltr</lookup:lang>
    <lookup:lang lang-code='ja'>ltr</lookup:lang>

    <lookup:lang lang-code='ar'>rtl</lookup:lang>
    <lookup:lang lang-code='he'>rtl</lookup:lang>
    <lookup:lang lang-code='yi'>rtl</lookup:lang>
</lookup:languages>

<!-- equate language settings with directionality for @dir (see strings/languages.xml) -->
<xsl:key name='langdir' match='lookup:languages/lang' use='@lang-code' />
<xsl:variable name='languages' select='document("")//lookup:languages' />

	
	<!-- markup conversion: topic elements -->
	<!--
	Architectural elements
		dita*
	
	Topic elements
	    Basic topic elements
	        topic* (and application context variants)
	        title*
	        titlealts
	        searchtitle
	        navtitle
	        shortdesc*
	        abstract
	        body*
	        bodydiv
	        related-links
	-->
	
	
	<!-- ============= root (direct incoming modes) 
	xsl:when test='$getbyelement ="shortdesc"'>
				<xsl:apply-templates select=""/>
			</xsl:when>
			<xsl:when test='$getbyelement ="body"'>
				<xsl:apply-templates select=""/>
			</xsl:when>
			<=============== -->
	<xsl:template match='/'>
	</xsl:template>

	<!-- =============dita (compound)=============== -->
	<xsl:template match='dita'>
		<div class="compound">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	

	<!-- =============topic=============== -->
	<!-- Note that this transform specifically uses class="topictitle", class="shortdesc", and class="body" for parts -->
	<!--<p>Writing direction for language "<xsl:value-of select="$thislang"/>": 
	<xsl:value-of select="$languages//lookup:lang[@lang-code=$thislang]"/></p>-->
	<xsl:template name='topic' match='*[contains(@class," topic/topic ")]'>
		<!--div class="topic"-->
		    <xsl:call-template name="check-atts"/>
			<xsl:if test="not(@xml:lang = '')">
				<xsl:variable name="lang"><xsl:value-of select="@xml:lang"/>-</xsl:variable>
				<xsl:variable name="thislang"><xsl:value-of select="substring-before($lang,'-')"/></xsl:variable>
				<!-- TBD: The following two rules need $thislang context before instancing. -->
				<!--
				<xsl:attribute name="lang">
					<xsl:value-of select="$thislang"/>
				</xsl:attribute>
				<xsl:attribute name="dir">
					<xsl:value-of select="$languages//lookup:lang[@lang-code=$thislang]"/>
				</xsl:attribute>	
				-->
			</xsl:if>
			<!-- This is activated by setparams currently commented out in the transform call -->
			<!--
			<h2>content by element: [<xsl:value-of select="$byelement"/>]</h2>
			<xsl:choose>
				<xsl:when test='$byelement ="topictitle"'>
					<xsl:apply-templates select='/*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]' />
				</xsl:when>
				<xsl:when test='$byelement ="shortdesc"'>
					<xsl:apply-templates select='/*[contains(@class," topic/topic ")]/*[contains(@class," topic/shortdesc ")]' />
				</xsl:when>
				<xsl:when test='$byelement ="body"'>
					<xsl:apply-templates select='/*[contains(@class," topic/topic ")]/*[contains(@class," topic/body ")]' />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
			<hr />
			-->
			<!--div>[$SHOW-CONREFMARKUP: '<xsl:value-of select="$SHOW-CONREFMARKUP"/>']</div-->
		
		    <xsl:apply-templates/>
		<!--/div-->
		<!-- for now, this will be called for any nested topics, duplicating the results. Need to exclude child topics in the endnotes template. -->
		<xsl:call-template name="endnotes"/>
	</xsl:template>

	<!-- specifically process a title in topic context (the processing does not apply to fig or table titles, for example) -->
	<xsl:template match='*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]' mode="contentonly">
 			<xsl:apply-templates/>
	</xsl:template>

	<!-- specifically process a title in topic context (the processing does not apply to fig or table titles, for example) -->
	<xsl:template match='*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]' mode="default">
		<xsl:variable name="nestedtopicdepth"><xsl:value-of select='count(ancestor::*[contains(@class," topic/topic ")])'/></xsl:variable>
		<xsl:element name="h{$nestedtopicdepth}">
			<xsl:attribute name="class">topictitle<xsl:value-of select="$nestedtopicdepth"/></xsl:attribute>
 			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!-- specifically process a title in template context (the heading level is relative to surroundings) -->
	<!-- ideally need to bind first topicdepth to the $headlevel1 parameter and count down from there. -->
	<xsl:template match='*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]'>
		<xsl:comment>[split]</xsl:comment>
		<xsl:comment>[title]</xsl:comment>
		<!--xsl:comment>TESTING HEADLEVEL1: <xsl:value-of select="$headlevel1"/></xsl:comment-->
		<xsl:variable name="nestedtopicdepth">
			<xsl:value-of select='(count(ancestor::*[contains(@class," topic/topic ")]) + $headlevel1 - 1)'/>
		</xsl:variable>
		<xsl:element name="h{$nestedtopicdepth}">
			<xsl:attribute name="data-class"><xsl:value-of select="local-name(parent::*)"/><xsl:value-of select="local-name(.)"/></xsl:attribute>
			<xsl:if test='not($headclass1 = "")'>
				<xsl:attribute name="class">
					<xsl:value-of select=" $headclass1"/>
				</xsl:attribute>
			</xsl:if>
 			<xsl:apply-templates/>
		</xsl:element>
		<!--xsl:comment>Topic title derived from <xsl:value-of select="$contentFile"/></xsl:comment-->
	</xsl:template>


	<!-- ================== regular post content (covers all other standard info types) ===================== -->

	<xsl:template match='*[contains(@class," topic/prolog ")]'/> <!-- normally no prolog rendering outside of a mode -->

	<xsl:template match='*[contains(@class," topic/prolog ")]' mode='viewprolog'>
		<div style='border:1px silver solid;background:#F0F0F0;'>
		<xsl:apply-templates mode='viewprolog'/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/prolog ")]' mode='skip'>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/titlealts ")]'>
			<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/navtitle ")]'>
		<!-- The topic title is the only item normally rendered in full rendition; navtitle is by query.  -->
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/searchtitle ")]'>
		<!-- Used by query at rendering time for meta keywords.  -->
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]' mode="topiccontent">
		<xsl:variable name="fixedhref">
			<xsl:variable name="resource-fn">
				<xsl:value-of select="substring-before($contentFile,'.')"/>
			</xsl:variable>
			<!-- The groupName and mapName values were passed in by the calling context (known context) -->
			<xsl:value-of select="$groupName"/>/<xsl:value-of select="$queryType"/>/<xsl:value-of select="$resource-fn"/>
		</xsl:variable>
		<div id="topicheading">
			<xsl:element name="h{$headlevel1}">
				<xsl:attribute name="data-class"><xsl:value-of select="local-name(parent::*)"/><xsl:value-of select="local-name(.)"/></xsl:attribute>
				<xsl:if test='not($headclass1 = "")'>
					<xsl:attribute name="class">
						<xsl:value-of select=" $headclass1"/>
					</xsl:attribute>
				</xsl:if>
		 		<xsl:if test="ancestor::*/@id">
					<xsl:attribute name="id"><xsl:value-of select="ancestor::*/@id"/></xsl:attribute>
				</xsl:if>
				<xsl:if test='ancestor::*/@xml:lang'>
					<xsl:attribute name="lang"><xsl:value-of select="ancestor::*/@xml:lang"/></xsl:attribute>
				</xsl:if>
				<!-- if user is authorized to edit, add edit link to title, else show normal title -->
				<xsl:choose>
					<xsl:when test="'yes' = 'no'">
						<a class="a nav" style="color:black;" href='{$fixedhref}?edit'>
							<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
							<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
							<xsl:apply-templates/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:if test="$topictitleMeta != ''">
				<div style="border:thin gray solid; background-color: #F0F0F0; width: 100%; font-size:smaller;font-family:sans;">
				<xsl:value-of select="$topictitleMeta"/>
				<xsl:if test="'yes' = 'yes'">
					<a class="a nav" style="color:black;" href='{$fixedhref}?edit'>
						<b> [Edit]</b>
					</a>
				</xsl:if>
			</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/abstract ")]'>
		<xsl:comment>[split]</xsl:comment>
		<xsl:comment>[abstract]</xsl:comment>
		<div class='abstract'>
				<xsl:call-template name="check-atts"/>
				<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/abstract ")]/*[contains(@class," topic/shortdesc ")]'>
		<xsl:comment>[abstract/shortdesc]</xsl:comment>
		<ph class='shortdesc' style="background-color:#FAFAFA">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</ph>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/shortdesc ")]'>
		<xsl:comment>[split]</xsl:comment>
		<xsl:comment>[shortdesc]</xsl:comment>
		<p class='shortdesc'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/body ")]'>
		<xsl:comment>[split]</xsl:comment>
		<xsl:comment>[body]</xsl:comment>
		<div class='topicbody'>
			<xsl:apply-templates/>
			<!-- DRD: following added to give some themes at least a CSS context for managing column spacing, floats, media queries, etc.. -->
			<xsl:if test=" . = ''"><p/></xsl:if>
	    </div>
	</xsl:template>




<!-- Dynamic support for XHTML or HTML5 name switching -->
	<xsl:template match='*[contains(@class," topic/section ")]'>
		<!-- Get the specialized title element name in case it is needed for class "namespacing" etc.. (think faq/question) -->
		<xsl:variable name="thisTitleName"><xsl:value-of select='name(*[contains(@class," topic/title ")])'/></xsl:variable>
		<xsl:call-template name="makeSection">
			<xsl:with-param name="sectionType" select="'section'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/body ")]/*[contains(@class," topic/example ")]'>
		<!-- Get the specialized title element name in case it is needed for class "namespacing" etc.. (think faq/question) -->
		<xsl:variable name="thisTitleName"><xsl:value-of select='name(*[contains(@class," topic/title ")])'/></xsl:variable>
		<xsl:call-template name="makeSection">
			<xsl:with-param name="sectionType" select="'example'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="makeSection">
		<xsl:param name="sectionType"/>
		<xsl:choose>
			<xsl:when test="$htmltype='HTML5'">
				<section>
					<xsl:attribute name="class">sectionDiv <xsl:value-of select="$sectionType"/></xsl:attribute>
					<!-- Apply id for xref to this container -->
				    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="/*/@id"/></xsl:attribute></xsl:if>
					<xsl:call-template name="check-atts"/>
					<xsl:call-template name="check-rev"/>
				    <!-- Instance the caption -->
					<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
					<!-- Instance the body -->
					<div class='sectionBody'><!-- figcontent -->
						<xsl:apply-templates select="node()[name()!='title']"/>
					</div>
				</section>
			</xsl:when>
			<xsl:otherwise><!-- case of older HTML/XHTML -->
				<div>
					<xsl:attribute name="class">sectionDiv <xsl:value-of select="$sectionType"/></xsl:attribute>
					<!-- Apply id for xref to this container -->
				    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="/*/@id"/></xsl:attribute></xsl:if>
					<xsl:call-template name="check-atts"/>
					<xsl:call-template name="check-rev"/>
				    <!-- Instance the caption -->
					<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
					<!-- Instance the body -->
					<div class='sectionBody'><!-- figcontent -->
						<xsl:apply-templates select="node()[name()!='title']"/>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


		<!--sectionTitle" xpdLabel labelDiv -->
	<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]'>
		<div class='sectionTitle section'><b>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
	  		<xsl:apply-templates/>
		</b></div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/example ")]/*[contains(@class," topic/title ")]'>
		<div class='sectionTitle section'><b>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
	  		<xsl:apply-templates/>
		</b></div>
	</xsl:template>


	<!-- =============common content=============== -->

	<xsl:template match='*[contains(@class," topic/cite ")]'>
		<cite class="cite">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</cite>
	</xsl:template>

	<!-- Need to improve both language awareness and nesting differentiation for inline quotes. Not clear docs! -->
	<!-- using span and literal quotes instead of q due to funky innate browser codepage issues (black diamonds!) -->
	<!-- using span and literal quotes instead of q due to funky innate browser codepage issues (black diamonds!) -->
	<xsl:template match='*[contains(@class," topic/q ")]'>
		<span class="q" lang="en-us">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:text>"</xsl:text><xsl:apply-templates/><xsl:text>"</xsl:text>
		</span>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dl ")]'>
		<dl class="dl">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</dl>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dlentry ")]'>
		<div class="dlentry">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dt ")]'>
		<dt class='dlterm'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dd ")]'>
		<dd class='dldesc'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dthd ")]'>
		<dt class='dlterm dthd'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ddhd ")]'>
		<dd class='dlterm ddhd'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	
	<!-- core: fig (block): improved -->

<xsl:template match='*[contains(@class," topic/fig ")]'>
	<!-- Get the specialized title element name in case it is needed for class "namespacing" etc.. (think faq/question) -->
	<xsl:variable name="thisTitleName"><xsl:value-of select='name(*[contains(@class," topic/title ")])'/></xsl:variable>
	<div class='sectionDiv fig'>
		<!-- Apply id for xref to this container -->
	    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="/*/@id"/></xsl:attribute></xsl:if>
		<xsl:call-template name="check-atts"/>
		<xsl:call-template name="check-rev"/>
	    <!-- Instance the caption -->
		<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
		<!-- Instance the body -->
		<div class='figcontent'>
			<!-- Apply scale and frame styling to this container -->
			<xsl:variable name="scale">
				<xsl:choose>
				<xsl:when test="@scale">
					<xsl:value-of select="@scale div 100.0"/>
				</xsl:when>
					<xsl:otherwise>1.0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="style">
				<xsl:value-of select="concat('font-size:',1 * $scale,'em;')"/><!-- The '1*' is a scale factor; increase as needed. -->
			</xsl:attribute>
			<!-- this id should be placed on an existing element. Watch for this in templates copied from DITA TO -->
		    <xsl:choose>
		    	<xsl:when test='@frame'>
					<xsl:choose>
						<xsl:when test="@frame='all'">
							<xsl:attribute name="class">figborder</xsl:attribute>
						</xsl:when>
						<xsl:when test="@frame='sides'">
							<xsl:attribute name="class">figsides</xsl:attribute>
						</xsl:when>
						<xsl:when test="@frame='top'">
							<xsl:attribute name="class">figtop</xsl:attribute>
						</xsl:when>
						<xsl:when test="@frame='bottom'">
							<xsl:attribute name="class">figbottom</xsl:attribute>
						</xsl:when>
						<xsl:when test="@frame='topbot'">
							<xsl:attribute name="class">figtopbot</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">fignone</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:variable name="thisName"><xsl:value-of select='name(*[contains(@class," topic/title ")])'/></xsl:variable>
					<xsl:apply-templates select="node()[name()!='title']"/>
		    	</xsl:when>
		    	<xsl:otherwise>
					<xsl:variable name="thisName"><xsl:value-of select='name(*[contains(@class," topic/title ")])'/></xsl:variable>
					<xsl:apply-templates select="node()[name()!='title']"/>
		    	</xsl:otherwise>
		    </xsl:choose>
		</div>
	</div>
</xsl:template>


<xsl:template match='*[contains(@class," topic/fig ")]/*[contains(@class," topic/title ")]'>
	<div class='figTitle fig'><!--'labelDiv fig'-->
		<xsl:call-template name="check-atts"/>
		<xsl:call-template name="check-rev"/>
		<xsl:if test="@id">
  			<xsl:text>Figure </xsl:text><xsl:number count='fig/title' level='any' format="1. "/>
  		</xsl:if>
  		<xsl:apply-templates/>
	</div>
</xsl:template>


<xsl:template match='*[contains(@class," topic/figgroup ")]/*[contains(@class," topic/title ")]'/>
<xsl:template name="figgroup.title">
	<div class='figTitle subTitle'><!--'labelDiv subfig'-->
		<xsl:call-template name="check-rev"/>
  		<xsl:text>SubFigure </xsl:text><xsl:number count='figgroup/title' level='any' format="1. "/><xsl:apply-templates/>
	</div>
</xsl:template>


<xsl:template match='*[contains(@class," topic/figgroup ")]'>
  		<xsl:apply-templates/>
</xsl:template>

<!-- core: object -->

	<xsl:template match='*[contains(@class," topic/object ")]'>
		<xsl:apply-templates select='*[contains(@class," topic/param ")][@name="xpdctrl"]' mode="pull"/>

		<video>
			<xsl:if test="@width"><xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute></xsl:if>
			<xsl:if test="@height"><xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute></xsl:if>
			<xsl:attribute name="controls"></xsl:attribute>
		<!--src='<xsl:value-of select="@data"/>'-->
		<!--
	<div style="border:1px red solid;background:silver;margin-top:1em;">
	</div>
		<iframe type="text/html" 
		    width="{@width}" 
		    height="{@height}" 
		    src="{@data}"
		    frameborder="0">
		</iframe>
	<object width="640" height="360" type="application/x-shockwave-flash" data="__FLASH__.SWF">
		<param name="movie" value="__FLASH__.SWF" />
		<param name="flashvars" value="controlbar=over&amp;image=__POSTER__.JPG&amp;file=__VIDEO__.MP4" />
		<img src="__VIDEO__.JPG" width="640" height="360" alt="__TITLE__"
		     title="No video playback capabilities, please download the video below" />
	</object>
		-->
		<xsl:apply-templates select="param"/>
		<xsl:apply-templates select="desc"/>
		</video>
	</xsl:template>
<!--
http://www.youtube.com/watch?feature=player_embedded&v=FEyRza0rJyI
<param name="FlashVars" value="playerMode=embedded"/>
<param name="allowScriptAcess" value="sameDomain"/>
<param name="scale" value="noScale"/>
<param name="quality" value="best"/>
<param name="bgcolor" value="#FFF"/>
<param name="salign" value="TL"/>
-->

	<xsl:template match='*[contains(@class," topic/object ")]/*[contains(@class," topic/desc ")]' priority="2">
		<p><xsl:apply-templates/></p>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/param ")][@name="anythingelse"]'>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/param ")][@name="src"]'>
		<source>
			<xsl:attribute name='src'>
				<xsl:choose>
					<xsl:when test='substring(@href,1,7)="http://"'>
						<xsl:value-of select="@href"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- what kind of path do we need here? To the restful address or to the CMS source address? restpath vs contentpath short-->
						<xsl:value-of select='$short'/>/<xsl:value-of select='$groupName'/>/<xsl:value-of select='@value'/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
		</source>
	</xsl:template>

<!-- core: image -->

	<xsl:template match='*[contains(@class," topic/image ")]'>
		<img class="image">
			<xsl:if test="name(parent::*) = 'imagemap'">
				<xsl:attribute name="usemap">#<xsl:value-of select="parent::*/@id"/></xsl:attribute>
			</xsl:if>
				<xsl:attribute name='src'>
				<xsl:choose>
					<xsl:when test='substring(@href,1,7)="http://"'>
						<xsl:value-of select="@href"/>
					</xsl:when>
					<xsl:otherwise>
					 	<xsl:variable name='targetResource'>
							<xsl:choose>
								<!--xsl:when test="substring(., string-length(.)) = '#'"-->
								<xsl:when test="contains(@href, '#') > 0">
									<xsl:value-of select='substring-before(@href,"#")'/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@href"/>
								</xsl:otherwise>
							</xsl:choose>
					 	</xsl:variable><!-- result = null or filepath -->
						<xsl:value-of select='$contentPath'/><xsl:value-of select='$targetResource'/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='@width'><xsl:attribute name='width'><xsl:value-of select='@width'/></xsl:attribute></xsl:if>
			<xsl:if test='@height'><xsl:attribute name='height'><xsl:value-of select='@height'/></xsl:attribute></xsl:if>
			<!-- convert scale to percentage -->
			<xsl:variable name="scale">
				<xsl:choose>
				<!--xsl:when test="@width or @height">1.0</xsl:when-->
				<xsl:when test="@scale">
					<xsl:value-of select="@scale div 100.0"/>
				</xsl:when>
					<xsl:otherwise>1.0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- do no content processing; restore image from metadata on output-->
		</img>
	</xsl:template>

    <xsl:template match='*[contains(@class," topic/image ")][@placement="break"]'>
	    <div>
			<xsl:if test='@align'>
				<xsl:attribute name='class'>image<xsl:value-of select="@align"/></xsl:attribute>
			</xsl:if>
	        <img class="imageBreak">
				<xsl:attribute name='src'>
					<xsl:choose>
						<xsl:when test='substring(@href,1,7)="http://"'>
							<xsl:value-of select="@href"/>
						</xsl:when>
						<xsl:otherwise>
						 	<xsl:variable name='targetResource'>
								<xsl:choose>
									<!--xsl:when test="substring(., string-length(.)) = '#'"-->
									<xsl:when test="contains(@href, '#') > 0">
										<xsl:value-of select='substring-before(@href,"#")'/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@href"/>
									</xsl:otherwise>
								</xsl:choose>
						 	</xsl:variable><!-- result = null or filepath -->
							<xsl:value-of select='$contentPath'/><xsl:value-of select='$targetResource'/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:call-template name="check-atts"/>
				<xsl:call-template name="check-rev"/>
				<!-- convert scale to percentage -->
				<xsl:variable name="scale">
					<xsl:choose>
					<!--xsl:when test="@width or @height">1.0</xsl:when-->
					<xsl:when test="@scale">
						<xsl:value-of select="@scale div 100.0"/>
					</xsl:when>
						<xsl:otherwise>1.0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test='@height'>
					<xsl:attribute name="height">
						<xsl:choose>
							<xsl:when test="not(string(number(@height)) = 'NaN')"><!-- if it is a pure number -->
								<xsl:value-of select="concat(@height * $scale,'px')"/>
							</xsl:when>
							<xsl:when test="contains(@height,'px')">
								<xsl:value-of select="concat(substring-before(@height,'px') * $scale,'px')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@height"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test='@width'>
					<xsl:attribute name="width">
						<xsl:choose>
							<xsl:when test="not(string(number(@width)) = 'NaN')"><!-- if it is a pure number -->
								<xsl:value-of select="concat(@width * $scale,'px')"/>
							</xsl:when>
							<xsl:when test="contains(@width,'px')">
								<xsl:value-of select="concat(substring-before(@width,'px') * $scale,'px')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@width"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				<!-- do no content processing; restore image from metadata on output-->
			</img>
		</div>
	</xsl:template>

<!-- core: lq -->

	<xsl:template match='*[contains(@class," topic/lq ")]'>
		<blockquote>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>

<!-- core: pre -->

	<!-- Tabs and line breaks within the "preserve" extent add to the copied-through fragment. Useful for editing, not display. -->
	<xsl:template match='*[contains(@class," topic/pre ")]'>
		<pre class='pre'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<!-- Apply scale and frame styling to this container -->
			<xsl:variable name="scale">
				<xsl:choose>
				<xsl:when test="@scale">
					<xsl:value-of select="@scale div 100.0"/>
				</xsl:when>
					<xsl:otherwise>1.0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="style">
				<xsl:value-of select="concat('font-size:',1 * $scale,'em;')"/><!-- The '1*' is a scale factor; increase as needed. -->
			</xsl:attribute>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/lines ")]'>
	<pre class='lines'>
		<xsl:call-template name="check-atts"/>
		<xsl:call-template name="check-rev"/>
		<xsl:apply-templates/>
	</pre>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/p ")]'>
		<p>
		    <xsl:call-template name="check-atts"/>
		    <xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/notex ")]'>
		<p class='note'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
			<xsl:if test="@othertype"><xsl:attribute name="othertype"><xsl:value-of select="@othertype"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/note ")]'>
		<xsl:variable name="elementclass"><!-- set the note type -->
			<xsl:text>note</xsl:text>
			<xsl:choose>
				<xsl:when test="@type='other'"><xsl:text> </xsl:text><xsl:value-of select="@othertype"/></xsl:when>
				<xsl:when test="not(@type)"><xsl:text> default</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text> </xsl:text><xsl:value-of select="@type"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:attribute name="class">
				<xsl:value-of select="$elementclass"/>
			</xsl:attribute>
			<b class='label'>
				<xsl:choose>
					<xsl:when test="@type='note'">Note: </xsl:when>
					<xsl:when test="@type='tip'">Tip: </xsl:when>
					<xsl:when test="@type='fastpath'">Fastpath: </xsl:when>
					<xsl:when test="@type='restriction'">Restriction: </xsl:when>
					<xsl:when test="@type='important'"><span style='border:thin black solid;'>Important:</span><xsl:text> </xsl:text></xsl:when>
					<xsl:when test="@type='remember'">Remember: </xsl:when>
					<xsl:when test="@type='attention'"><span style='border:thin black solid;'>Attention:</span><xsl:text> </xsl:text></xsl:when>
					<xsl:when test="@type='caution'"><span style='border:thin black solid;'> Caution:</span><xsl:text> </xsl:text></xsl:when>
					<xsl:when test="@type='notice'"><span style='border:thin gray solid;'> Notice:</span><xsl:text> </xsl:text></xsl:when>
					<xsl:when test="@type='danger'"><span style='border:thin red solid;color:#A00000'>DANGER:</span><xsl:text> </xsl:text></xsl:when>
					<xsl:when test="@type='warning'"><span style='border:thin gray solid;'> Warning:</span><xsl:text> </xsl:text></xsl:when>
					<xsl:when test="@type='other'"><xsl:value-of select="@othertype"/>: </xsl:when>
					<xsl:otherwise>Note: </xsl:otherwise>
				</xsl:choose>
			</b> <xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/desc ")]'>
		<div>
		    <xsl:call-template name="check-atts"/>
		    <xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ul ")]'>
		<ul>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<!--xsl:attribute name="class"><xsl:text>ultopic </xsl:text-->
				<!--xsl:if test="@compact = 'compact'">line-height:80%;</xsl:if-->
			<!--/xsl:attribute-->
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ol ")]'>
		<ol>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:if test="@compact = 'yes'">
				<xsl:attribute name="style">line-height:80%;</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/li ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/sl ")]'>
		<ul class="sl">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:attribute name="style">
			<xsl:if test="@compact = 'compact'">line-height:80%;</xsl:if>
			</xsl:attribute>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/sli ")]'>
		<li class="sli">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</li>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/ph ")]'>
		<span class='phrase'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/term ")]'>
		<xsl:variable name="term"><xsl:apply-templates/></xsl:variable>
		<span class='term'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:value-of select="$term"/>
		</span>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/term ")][@outputclass = "themeName"]'>
		<xsl:variable name="term"><xsl:apply-templates/></xsl:variable>
		<a href="{$contentPath}/images/{$term}.jpg">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:value-of select="$term"/>
		</a>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/keywords ")]/*[contains(@class," topic/keyword ")]' priority='10'>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/keyword ")]'>
		<span class='keyword'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/state ")]'>
		<span class='boolean'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			[<xsl:value-of select="@name"/>:<xsl:value-of select="@value"/>]
		</span>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/boolean ")]'>
		<span class='boolean'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			[<xsl:value-of select="@value"/>]
		</span>
	</xsl:template>


	<!-- Related Links -->

	<xsl:template match='*[contains(@class," topic/related-links ")]'>
		<xsl:choose>
			<xsl:when test="1 = 0">
				<xsl:comment>[split]</xsl:comment>
				<xsl:comment>[related-links]</xsl:comment>
				<div>
					<xsl:call-template name="check-atts"/>
					<xsl:call-template name="check-rev"/>
					<p><b>Related Links</b></p>
					<ul>
						<xsl:apply-templates/>
					</ul>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<!-- related links should be configurable, not compulsive -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='topicref' match='*[contains(@class," topic/link ")]'>
		<li class='topicref nav'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:call-template name="newlink"/>
			<xsl:apply-templates select='*[contains(@class," topic/desc ")]'/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/llink ")]'><!--misnamed so as not to match for now; needs review.-->
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<a href='{@href}'>
				<xsl:choose>
					<xsl:when test='@scope = "external"'>
						<xsl:attribute name='target'>_new</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test='linktext'>
						<xsl:apply-templates select='linktext'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select='@href'/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
			<xsl:apply-templates select='*[contains(@class," topic/desc ")]'/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/linklist ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
			<xsl:apply-templates select='*[contains(@class," topic/desc ")]'/>
			<xsl:if test='link|linklist'>
				<ol>
					<xsl:apply-templates select='*[contains(@class," topic/link ")]|*[contains(@class," topic/linklist ")]'/>
				</ol>
			</xsl:if>
			<xsl:apply-templates select='*[contains(@class," topic/linkinfo ")]'/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/linkinfo ")]'>
		<div>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/linktext ")]'>
		<div>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>



	<!-- Misc Elements -->

	<xsl:template match='//*[contains(@class," topic/fn ")]'>
		<xsl:variable name="fnseq"><xsl:number count="fn" level="any"/></xsl:variable>
		<xsl:variable name="docpath"><xsl:value-of select="concat($contentPath,$queryType,'/',$resourceName)"/></xsl:variable>
  		<sup><a href="{$restPath}#fndesc{$fnseq}" name="fntarg{$fnseq}">Footnote <xsl:value-of select="$fnseq"/></a></sup>
	</xsl:template>

	<xsl:template name="endnotes"><!-- called from topic element context --><!-- changed serviceType to groupName; need a generic path util! -->
		<xsl:if test='//*[contains(@class," topic/fn ")]'>
			<p>________</p>
			<dl style="margin-top: 0;">
			<xsl:for-each select='//*[contains(@class," topic/fn ")]'>
				<xsl:variable name="fnseq"><xsl:number count="fn" level="any"/></xsl:variable>
				<xsl:variable name="docpath"><xsl:value-of select="concat($contentPath,$queryType,'/',$resourceName)"/></xsl:variable>
				<dt><sup><a href="{$restPath}#fntarg{$fnseq}" name="fndesc{$fnseq}">Footnote <xsl:value-of select="$fnseq"/></a></sup></dt>
				<dd style="font-size: smaller;"><xsl:apply-templates mode="endnotes"/></dd>
			</xsl:for-each>
			</dl>
		</xsl:if>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/fn ")]' mode="endnotes">
		<!--xsl:apply-templates/-->
	</xsl:template>


	<xsl:template match='*[contains(@class," topic/indexterm ")]'>
		<xsl:if test="$SHOW-INDEXTERM='yes'"> <!-- show only if requested -->
		<span class='indexterm'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/draft-comment ")]' priority="200">
       <xsl:if test="$DRAFT='yes'"> <!-- show only if requested -->
 		<div class='draftComment' style="border:2px #0f0 solid;background:#afa;">
			<b>Comment <xsl:if test='@author'>by <xsl:value-of select='@author'/>: </xsl:if></b>
			<xsl:if test='@disposition'>
				<span>
					<xsl:attribute name='style'>
						<xsl:choose>
							<xsl:when test="@disposition='completed'">color:green</xsl:when>
							<xsl:when test="@disposition='open'">color:red</xsl:when>
							<xsl:when test="@disposition='issue'">color:red</xsl:when>
							<xsl:when test="@disposition='reopened'">color:red</xsl:when>
							<xsl:when test="@disposition='accepted'">color:blue</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					(disposition: <xsl:value-of select='@disposition'/>)
				</span>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
       </xsl:if>
	</xsl:template>



<!-- Process standard attributes that may appear anywhere. Previously this was "setclass" -->
<xsl:template name="commonattributes">
  <!--
	<xsl:param name="default-output-class"/>
	<xsl:apply-templates select="@xml:lang"/>
	<xsl:apply-templates select="@dir"/>
	<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass" mode="add-ditaval-style"/>
	<xsl:apply-templates select="." mode="set-output-class">
		<xsl:with-param name="default" select="$default-output-class"/>
	</xsl:apply-templates>
  -->
	<xsl:if test="@audience">
		<xsl:attribute name="data-audience"><xsl:value-of select="@audience"/></xsl:attribute>
	</xsl:if>
	<xsl:if test="@platform">
		<xsl:attribute name="data-platform"><xsl:value-of select="@platform"/></xsl:attribute>
	</xsl:if>
	<xsl:if test="@product">
		<xsl:attribute name="data-product"><xsl:value-of select="@product"/></xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template name="add-user-link-attributes">
  <!-- stub for user values -->
</xsl:template>


<!-- support for scripting language -->

	<xsl:template match='*[contains(@class," topic/foreign ")]'>
		<div class = 'foreign'>
			<xsl:value-of select="." disable-output-escaping="yes"/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/foreign ")]' mode="ditascript">
		<span class='{name(.)}'>
			<xsl:if test='@title'><!-- this if test is only to migrate earlier deperecated syntax. -->
				<xsl:value-of select='@title'/>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>


   
    <!-- =================== conref processing ====================== -->

<xsl:template match='node()[not(string(@conref) = "")]'>
	<xsl:if test="$SHOW-CONREFMARKUP='more'">
		<xsl:variable name="targetElement" select="name()"/>
		<div style="border:1px red solid">
		<p>What we know about this context:</p>
		<ul>
			<li>Common contentPath: '<xsl:value-of select="$contentPath"/>'</li>
			<li>This context ($contentFile): '<xsl:value-of select='$contentFile'/>'</li>
			<li>The calling element ($targetElement): '<xsl:value-of select="$targetElement"/>'</li>
			<li>Other atts on this element (need to copy into replaced element): 
			<ol>
				<xsl:for-each select="@*">
					<li>@<xsl:value-of select="name()"/> = '<xsl:value-of select="."/>'</li>
				</xsl:for-each>
			</ol>
			</li>
		</ul>
		</div>
	</xsl:if>
	
 	<xsl:variable name='targetResource'>
		<xsl:choose>
			<!--xsl:when test="substring(., string-length(.)) = '#'"-->
			<xsl:when test="contains(@conref, '#') > 0">
				<!--<xsl:value-of select='$contentPath'/>/-->
				<xsl:value-of select='substring-before(@conref,"#")'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@conref"/>
			</xsl:otherwise>
		</xsl:choose>
 	</xsl:variable><!-- result = null or filepath -->

 	<xsl:variable name='targetQualfier'><xsl:value-of select='substring-after(@conref,"#")'/></xsl:variable><!-- result = topicId{/targetId} -->
	<xsl:variable name='topicId'><!-- value of the target element's id -->
      	<xsl:choose>
            <xsl:when test='contains($targetQualfier,"/")'>
           		<xsl:value-of select='substring-before($targetQualfier,"/")'/>
            </xsl:when>
            <xsl:otherwise>
           		<xsl:value-of select='$targetQualfier'/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>
	<xsl:variable name='elementId'><!-- can be null if the pointer is to the topic proper -->
		<xsl:choose>
            <xsl:when test='contains($targetQualfier,"/")'>
           		<xsl:value-of select='substring-after($targetQualfier,"/")'/>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:if test="$SHOW-CONREFMARKUP='more'">
		<div style="border:1px blue solid">
		<p>Breaking down the conref: '<xsl:value-of select="@conref"/>'</p>
		<ul>
			<li>Common contentPath: '<xsl:value-of select="$contentPath"/>'</li>
			<li>That context ($targetResource) (null or filepath): '<xsl:value-of select="$targetResource"/></li>
			<li>Target context's ID: '<xsl:value-of select='$topicId'/>'</li>
			<li>Target element's ID: '<xsl:value-of select='$elementId'/>'</li>
			<!--/<xsl:value-of select="$resource-fn"/>.<xsl:value-of select="$resource-ext"/>-->
		</ul>
		</div>
	</xsl:if>
 
	<xsl:if test="$SHOW-CONREFMARKUP='yes'">
		<span style="background-color:#DDFFFF;">[<b><xsl:value-of select="name(.)"/></b> conref="<xsl:value-of select="@conref"/>"]</span>
	</xsl:if>

	<!-- Use xpath to find the matching element in the target context -->
	<!--<xsl:if test="'no' = 'no'">-->
	<xsl:if test="$SHOW-CONREFMARKUP='test'">
		<span class="showconref"><!-- title="referenced from: {@conref}"-->
			<xsl:choose>
		        <xsl:when test='string-length($targetResource) != 0 and string-length($elementId) != 0'><!-- get the remote element -->
		       		<xsl:apply-templates select='document($targetResource,.)/*//*[@id=$elementId]'/>
		        </xsl:when>
		        <xsl:when test='string-length($targetResource) != 0'><!-- get the entire remote topic -->
		       		<xsl:apply-templates select='document($targetResource,.)'/>
		        </xsl:when>
		        <xsl:otherwise><!-- within the current topic -->
		        	<xsl:apply-templates select="/*//*[@id=$elementId]"/>
		        </xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:if>

	<xsl:if test="$SHOW-CONREFMARKUP='no'">
			<xsl:choose>
		        <xsl:when test='string-length($targetResource) != 0 and string-length($elementId) != 0'><!-- get the remote element -->
		       		<xsl:apply-templates select='document($targetResource,.)/*//*[@id=$elementId]'/>
		        </xsl:when>
		        <xsl:when test='string-length($targetResource) != 0'><!-- get the entire remote topic -->
		       		<xsl:apply-templates select='document($targetResource,.)'/>
		        </xsl:when>
		        <xsl:otherwise><!-- within the current topic -->
		        	<xsl:apply-templates select="/*//*[@id=$elementId]"/>
		        </xsl:otherwise>
			</xsl:choose>
	</xsl:if>
</xsl:template>




<!-- links2h logic -->

<!-- ================ cross reference links ================= -->
	
	<!-- rule for when the xref is not pointing at anything (an editing mode condition) -->
	<xsl:template match="*[contains(@class,' topic/xref ')][normalize-space(@href) = '']">
			<b style="color:red;">
				<xsl:apply-templates/>
			</b>
		<xsl:if test="$SHOW-CONREFMARKUP='yes'">
		</xsl:if>
	</xsl:template>

	<!-- special case of xref referencing a ditamap (result is indeterminate) -->
	<xsl:template match="*[contains(@class,' topic/xref ')][normalize-space(@format) = 'ditamap']" priority="3">
	 	<xsl:variable name='targetResource'>
			<xsl:choose>
				<!--xsl:when test="substring(., string-length(.)) = '#'"-->
				<xsl:when test="contains(@href, '#') > 0">
					<xsl:value-of select='substring-before(@href,"#")'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
	 	</xsl:variable><!-- result = null or filepath -->
		<xsl:variable name="targfilename" select="substring-before($targetResource,'.')"/>
		<xsl:variable name="targext" select="substring-after($targetResource,'.')"/>
		<xsl:if test="$SHOW-CONREFMARKUP='yes'">
			<b>[Reference to map: <xsl:value-of select="$targetResource"/> for fn '<xsl:value-of select="$targfilename"/>'] </b>
		</xsl:if>
		<a href="{$groupName}/map/{$targfilename}">
			<xsl:choose>
				<xsl:when test="string-length(.) &gt; 0">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>


<!-- xref big kahuna -->

<xsl:template match="*[contains(@class,' topic/xref ')][not(normalize-space(@href) = '')]">
	<xsl:choose>
		<xsl:when test="not(@scope='external') and (@format='dita' or @format='DITA' or not(@format))">
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
		
			<xsl:variable name='id'>
				<xsl:choose>
					<xsl:when test='contains(@href,"#")'>
						<xsl:value-of select='substring-after(substring-after(@href,"#"),"/")'/>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>		
			</xsl:variable>
			<!-- DRD: same logic as for image references, ideally (not using $userDir,'/',)-->
		
			<xsl:variable name="thisgroup">
				<xsl:choose>
					<xsl:when test='topicmeta//othermeta[@name="groupname"]'>
						<xsl:value-of select="//othermeta[@name = 'groupname']/@content"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$groupName"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!--<xsl:value-of select="concat('../',$thisgroup,'/',$srcPath,@href)"/>-->
			<xsl:variable name="fullPath" select="normalize-space(concat($contentDir,'/',$thisgroup,'/',$path))"/>
			<!--
			[================<br/>
			path: <xsl:value-of select='$fullPath'/><br/>
			title: <xsl:apply-templates select='document($fullPath)//title[1]'/><br/>
			================]
			-->
			<!-- show intermediate results based on method used for conref -->
			
			<!-- normalize ./ prefix (absolute path is the current directory) -->
			<xsl:variable name='topicPath'>
				<xsl:choose>
					<xsl:when test="substring($path,1,2)='./'">
						<xsl:value-of select="substring($path,3)" /><!-- strip *nix "here" prefix -->
					</xsl:when>
					<xsl:when test="substring($path,1,3)='../'">
						<xsl:value-of select="substring($path,3)" /><!-- reset relative to root -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$path" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			<xsl:variable name="targfilepath">
				<xsl:choose>
					<xsl:when test="contains($topicPath,'#')">
						<xsl:value-of select="substring-before($topicPath,'#')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$topicPath"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			<xsl:variable name="literalfilepath">
				<xsl:choose>
					<xsl:when test="contains($path,'#')">
						<xsl:value-of select="substring-before($path,'#')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$path"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="targfileext">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$targfilepath" />
					<xsl:with-param name="marker" select="'.'" />
				</xsl:call-template>
			</xsl:variable>
		
			<xsl:variable name="targqualifid" select="substring-after($topicPath,'#')"/>
			<xsl:variable name="targfilename" select="substring-before($topicPath,'.')"/>
			<xsl:variable name="targfileid" select="substring-before(substring-after($topicPath,'#'),'/')"/>
			<xsl:variable name="targparms">
				<xsl:choose>
					<xsl:when test='@type'>
						<xsl:text>?app_type=</xsl:text><xsl:value-of select="@type"/>
					</xsl:when>
					<xsl:otherwise>
						<!--xsl:text>bliki</xsl:text-->
					</xsl:otherwise>
				</xsl:choose>		
			</xsl:variable>
		
			<xsl:variable name="targfragid" select="substring-after($targqualifid,'/')"/>
		  
			<!-- this variable sets the actual URL that gets set in the anchor's href attribute -->
			<xsl:variable name="thishref">
				<xsl:choose>
					<xsl:when test="$targfilepath != ''"><!-- set the URL for an external file -->
						<!-- INTEGRATION NOTE: replace the text string below with application specific calling interface -->
						<xsl:value-of select="$get_call"/><xsl:value-of select="$targfilepath"/>
					</xsl:when>
					<xsl:otherwise><!-- set the URL for an internal target (compounded from topicid and fragid) -->
						<xsl:text>#</xsl:text><xsl:value-of select="$targfileid"/>__<xsl:value-of select="$targfragid"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		  
			<!-- create link for DITA topic content (next: test for $resourceType and set keyword accordingly)-->
			<a href="{$groupName}/{$queryType}/{$targfilename}{$targparms}">
				<xsl:variable name="targ_elem"><xsl:value-of select="name(//*[@id = $targfragid])"/></xsl:variable>
				<!-- if this is empty, we already know the link is probably external -->
				<xsl:choose>
					<!-- access nested link text -->
					<xsl:when test="normalize-space(.) != ''">
					<xsl:apply-templates/>
					</xsl:when>
					<!-- access retrieved (but in this document) link text -->
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test='$targ_elem = "fn"'>
								<xsl:apply-templates select="//fn[@id = $targfragid]" mode="crossref"/>
							</xsl:when>
							<xsl:when test='$targ_elem = "li"'>
								<xsl:apply-templates select="//li[@id = $targfragid]" mode="crossref"/>
								<!-- Some contexts (like note) may need to generate a surrounding superscript for the resulting link. -->
							</xsl:when>
							<xsl:when test='$targ_elem = "fig"'>
								<xsl:apply-templates select="//fig[@id = $targfragid]/title" mode="crossref"/>
							</xsl:when>
							<xsl:when test='$targ_elem = "table"'>
								<xsl:apply-templates select="//table[@id = $targfragid]/title" mode="crossref"/>
							</xsl:when>
							<xsl:when test='$targ_elem = "section"'>
								<xsl:apply-templates select="//section[@id = $targfragid]/title" mode="crossref"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- if users don't use @scope properly, we still need to catch the attempt at external fetch -->
								<xsl:if test='contains($fullPath,".htm")=false'>
								    <!-- <xsl:value-of select="$fullPath"/>:  -->
								    <xsl:choose>
										<xsl:when test='$path = ""'>
											<span style='color:green;'>[internal xref: <xsl:value-of select="@href"/>]</span>
										</xsl:when>
										<xsl:when test="$fullPath != ''">
											<!--p>fullPath in link: <xsl:value-of select='$fullPath'/></p  DRD: fixed issue with path being incorrect-->
											<!-- try to get text from remote target -->
											<xsl:variable name="thattopic" select="document($fullPath,.)"/>
											<xsl:apply-templates select="$thattopic/*/title" mode='crossref'/>
											<!-- (<xsl:value-of select="$thattopic//title[1]" />) -->
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@href"/><!-- was $path; might be internal link -->
										</xsl:otherwise>
								    </xsl:choose>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</xsl:when>

		<xsl:when test="@format='ditamap'">
			<a href="{@href}">
				<!-- optional target="_blank" -->
				<xsl:apply-templates/>
			</a>
		</xsl:when>
 
		<xsl:otherwise>
			<!-- It is scope=external, therefore create link for remote, non-DITA resource -->
			<a href="{@href}">
				<!-- optional target="_blank" -->
				<xsl:choose>
					<xsl:when test="* | text()">
						<xsl:apply-templates/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@href"/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/fn ')]" mode="crossref">
  <sup><xsl:number count="fn" level="single"/></sup>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/li ')]" mode="crossref">
  <xsl:number count="li" level="single"/>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]" mode="crossref">
  <b>Figure <xsl:number count='fig/title' level='any' format="1. "/><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/table ')]/*[contains(@class,' topic/title ')]" mode="crossref">
  <b>Table <xsl:number count='table/title' level='any' format="1. "/><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]" mode="crossref">
  <b><i><xsl:apply-templates/></i></b>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/example ')]/*[contains(@class,' topic/title ')]" mode="crossref">
  <b><i><xsl:apply-templates/></i></b>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]" mode="crossref">
  <b><i><xsl:apply-templates/></i></b>
</xsl:template>


<!-- some DITA 1.2 syntax that appears in more and more test samples -->
<xsl:template match="*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]" mode="crossref">
  <b><i><xsl:apply-templates/></i></b>
</xsl:template>


<xsl:template match="*[@keyref]">
  <span style="color:darkred;">[element: <xsl:value-of select="name()"/>; keyref:<xsl:value-of select="@keyref"/>]</span>
</xsl:template>

 
<!-- ========= additions from elsewhere ========= -->

<!-- recursive template to retrieve the substring after the last occurrence of specified pattern -->
<xsl:template name="substring-after-last">
	<xsl:param name="input" />
	<xsl:param name="marker" />
	<xsl:choose>
		<xsl:when test="contains($input,$marker)">
			<xsl:call-template name="substring-after-last">
				<xsl:with-param name="input" select="substring-after($input,$marker)" />
				<xsl:with-param name="marker" select="$marker" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$input" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>



<!-- handle all section like titles with common setup; perform translated string lookup here -->
<xsl:template name="get-section-title">
  <xsl:param name="label-type"></xsl:param>
    <xsl:choose> 
      <xsl:when test='*[contains(@class," topic/title ")]'>
        <xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
      </xsl:when>
      <xsl:when test="string-length($label-type) &gt; 0">
        <xsl:value-of select="$label-type"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- handle all label like titles with common setup -->
<xsl:template name="get-label-title">
	<xsl:param name="label-type">Generic label</xsl:param>
	<div class="sectionTitle label">
		<xsl:choose> 
			<xsl:when test="child::*[contains(@class,' topic/title ')]">
				<xsl:apply-templates select="title"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$label-type"/>
			</xsl:otherwise>
		</xsl:choose>
	</div>
</xsl:template>

<!-- some override behaviors for special outputclasses -->


	<xsl:template match='*[contains(@class," topic/section ")][@outputclass="aside"]'>
		<xsl:if test="$SHOW-SLIDES='yes'">
		<div class='slide-preview'>
			<!-- removed check-atts because the outputclass handler overrides the class value needed here -->
			<xsl:call-template name="check-rev"/>
		    <xsl:apply-templates select="node()[name()='title']"/>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
		</xsl:if>
	</xsl:template>



</xsl:stylesheet>