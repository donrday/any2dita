<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lookup="http://yourdomain.com/lookup"
    extension-element-prefixes="lookup"
    xmlns:php="http://php.net/xsl"
    xsl:extension-element-prefixes="php"
	exclude-result-prefixes="php" 
>


<!-- transforms for topics and their derivations html/topic.xsl -->
<!--
<xsl:import href="xsl-dot/dita2xhtml.xsl"/>
-->
<!--
<xsl:import href="xslhtml/ut-d.xsl"></xsl:import>
<xsl:import href="xslhtml/sw-d.xsl"></xsl:import>
<xsl:import href="xslhtml/pr-d.xsl"></xsl:import>
<xsl:import href="xslhtml/ui-d.xsl"></xsl:import>
<xsl:import href="xslhtml/hi-d.xsl"></xsl:import>
-->
<xsl:import href="html/topic.xsl"/>
<xsl:import href="html/domains.xsl"/>
<xsl:import href="html/utilities.xsl"/>
<xsl:import href="html/task.xsl"/>
<xsl:import href="html/reference.xsl"/>
<!--
-->

<!-- Transforms for maps -->
<xsl:import href="html/map.xsl"/> <!-- map is needed in this top-level shell; not needed in aggregatemap, which IS the map shell -->

<!-- Transforms for ditaval visualization/editing -->
<xsl:import href="html/props.xsl"/>

<!-- import specializations in the override priority position -->
<xsl:import href="recipe/recipe2html.xsl"/>
<xsl:import href="elementref/elementref2html.xsl"/>
<xsl:import href="enote/enote2html.xsl"/>
<xsl:import href="faq/faq2html.xsl"/>
<xsl:import href="msgref/msg2xhtml.xsl"/>
<xsl:import href="ts/tsTroubleshooting.xsl"/>
<xsl:import href="tutorial/xsl/tutorial2xhtml.xsl"/>
<!--xsl:import href="omanual/omanual2html.xsl"/-->
<!--xsl:import href="tabcontent/integrate.xsl"/-->
<!-- Note: cannot import "dynamic" paths because XSLT is compiled by the time this point is executed -->

<xsl:output method="xml" encoding="utf-8" indent="no" omit-xml-declaration="yes"/>


<xsl:param name="DITAEXT" select="'.xml'"/>
<xsl:param name="OUTEXT" select="'.html'"/>
<xsl:param name="mode" select="'content'"/>
<xsl:param name="newline" select="'
'"/>
<xsl:param name="htmltype" select="'HTML5'"/> <!-- use this to set modes for proper template selection -->

			
<!-- backup templates and future overrides -->
<xsl:template match="/">
	<xsl:apply-templates></xsl:apply-templates>
</xsl:template>


<!-- just for 20K leagues -->

	<xsl:template match="*[contains(@class,' topic/ph ')][@class = 'h2']">
		<span class='ph2'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/ph ')][@class = 'h3']">
		<span class='ph3'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<!-- Template for pis not handled elsewhere -->

<xsl:template match="processing-instruction('xpd-html')">
  <xsl:choose>
  	<xsl:when test='. = "linebreak"'>
  		<br/>
  	</xsl:when>
  	<xsl:when test='. = "wordbreak"'>
  		<wbr/>
  	</xsl:when>
  	<xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- for special rendering -->

	<xsl:template match="xdata">
		<p><b><xsl:apply-templates select='@type'/>/<xsl:apply-templates select='@name'/>: </b> <xsl:apply-templates/></p>
	</xsl:template>

	<xsl:template match="section[@class='overallData']">
		<div>
			<h4><xsl:apply-templates select='@class'/></h4>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="section[@class='topicReport']">
		<div>
			<h4><xsl:apply-templates select='@class'/><xsl:apply-templates select='@id'/></h4>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	
	<!-- use xref to represent a content query *[contains(@class,' topic/ph ')][@class = 'h3']-->
	<xsl:template match='*[contains(@class," topic/xref ")][@format = "query"]'>
		<xsl:variable name="gatherkey"><xsl:value-of select="@href"/></xsl:variable>
		<!-- Algorithm: use this value to query a list of relevant topics and display as a list -->
		<ol>
			<xsl:for-each select="//dlentry">
				<li><b><xsl:value-of select="dt"/></b><xsl:apply-templates select="dd"/></li>
			</xsl:for-each>
		</ol>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dl ")][@id = "fodder"]'/>

	<xsl:template match="*[contains(@class,' topic/shortdesc ')][@outputclass='what']">
		<div><h2>What it does</h2><xsl:apply-templates/></div>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/shortdesc ')][@outputclass='why']">
		<div><h2>Why it matters</h2><xsl:apply-templates/></div>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/body ')][@outputclass='definition']">
		<div><h2>In depth</h2><xsl:apply-templates/></div>
	</xsl:template>

</xsl:stylesheet>