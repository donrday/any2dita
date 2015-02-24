<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:output method="xml" indent="yes" encoding="utf-8"/>

<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," map/map ")]'>
		<ul>
			<!-- need to apply "active" flag per themeconfig value -->
			<xsl:apply-templates select="topicref"/>
		</ul>
</xsl:template>

<xsl:template match='*[contains(@class," map/map ")]' mode="all">
	<header>
		<h1><xsl:value-of select="title"/></h1>
		<p><xsl:value-of select="@title"/></p>
	</header>
	<nav id="navigation">
  		<!-- outerwrap and outerprop? -->
		<ul>
			<xsl:apply-templates select="topicref"/>
		</ul>
	</nav>
	<div style="clear:both;"></div>
</xsl:template>

<xsl:template match='*[contains(@class," topic/title ")]'/>

 <xsl:template match='*[contains(@class," map/topicref ")]'>
 	<!-- for each button, get its serviceType (@type), queryTYpe (derived from extension), and resourceName (filename sans ext)-->
	<xsl:variable name="serviceType"><xsl:value-of select="@type"/></xsl:variable>
	<xsl:variable name="ext"><xsl:value-of select="substring-after(@href,'.')"/></xsl:variable>
	<xsl:variable name="queryType">
		<xsl:choose>
			<xsl:when test='$ext = "dita"'>topic</xsl:when>
			<xsl:when test='$ext = "ditamap"'>map</xsl:when>
			<xsl:when test='$ext = "ditaval"'>val</xsl:when>
			<!-- Support other formal queryType values; parameter? -->
			<xsl:otherwise><xsl:text>fix_</xsl:text><xsl:value-of select="$ext"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="resourceName"><xsl:value-of select="substring-before(@href,'.')"/></xsl:variable>
	<xsl:variable name="docpath"><xsl:value-of select="concat($serviceType,'/',$queryType,'/',$resourceName)"/></xsl:variable>
	<xsl:element name="li">
   		<!-- activeprop? -->
 		<a href="{$docpath}">
  			<!-- anchorprop? -->
  			<xsl:value-of select="@navtitle"/>
  		</a>
		<!-- nested topicrefs are equivalent to child topics.  mode='ref-as-topic' -->
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul><xsl:apply-templates/></ul>
		</xsl:if>
	</xsl:element>
 </xsl:template>      

 <xsl:template match="topichead">
	<xsl:element name="li">
		<b>
		[<xsl:value-of select="@navtitle"/>]
		</b>
		<!-- nested topicrefs are equivalent to child topics.  mode='ref-as-topic' -->
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul><xsl:apply-templates/></ul>
		</xsl:if>
    </xsl:element>
 </xsl:template>      

</xsl:stylesheet>

