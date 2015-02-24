<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
    Sourceforge.net. See the accompanying license.txt file for 
    applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!--  faq.xsl
 | Specific override stylesheet for FAQ (demo)
 | This demonstrates the XSLT override mechanism tied to a specialization.
 |
 *-->

<xsl:stylesheet version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- layout related -->
	<xsl:param name="GENERATE-FAQ-LABELS" select="'no'"/>

	<!-- generated string values (translatable) -->
	<xsl:variable name="StringFile" select="document('faq_strings.xml')"/>
	<xsl:param name='label-Question'>Question</xsl:param>
	<xsl:param name='label-Answer'>Answer</xsl:param>



<!-- Most of the faq demo elements rely on default stylesheet support
     for the base class of the derived elements (ie, faqgroup is processed
     by its base section support) -->

<!-- Some faq elements require specific new behavior rather than the default, 
     base class support of the derived elements.  These new behaviors are
     given below.  Overrides to the overall behavior of the output (tweaks, or
     things that are independent of the topic content, typically) can be 
     added to the shell stylesheet that imports both the base class and the
     specialization-specific behaviors. -->

<!-- The faqlist is modelled on simpletable, which has a tabular output by default.
     This implementation overrides the default by producing a sequentially-presented
     list instead.  Both are valid, but the sequential flow is more readable in
     a Web environment. -->

<xsl:template match="*[contains(@class,' faq/faqlist ')]">
  <ol>
    <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match="*[contains(@class,' faq/faqitem ')]">
  <li>
  <a>
     <xsl:attribute name="name"><xsl:value-of select="generate-id()"/></xsl:attribute>
     <xsl:text> </xsl:text>
  </a>
    <!-- suppress faqprop by selecting all child elements BUT faqprop -->
    <xsl:apply-templates select="*[not( contains(@class,' faq/faqprop ') )]"/>
  </li>
</xsl:template>

<xsl:template match="*[contains(@class,' faq/faqquest ')]">
  <!-- a real version would style the element via a class defined 
       in an external CSS file -->
  <span style="font-style: italic;">
    <xsl:if test='$GENERATE-FAQ-LABELS = "yes"'>
      <xsl:call-template name="get-label-title">
        <xsl:with-param name="label-type"><xsl:value-of select="$label-Question"/></xsl:with-param>
      </xsl:call-template>
    <!--
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Question'"/>
        <xsl:with-param name="stringFile" select="$StringFile"/>
      </xsl:call-template>
	-->
    </xsl:if>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="*[contains(@class,' faq/faqans ')]">
 <a style="text-decoration:none;font-size:smaller" href="javascript:;" onmousedown="toggleVis('faqans{generate-id()}');">
		<xsl:text> </xsl:text><span style="font-weight:bold;background:lightgray">Answer:</span>
	</a>
	<br />
	<div id="faqans{generate-id()}" style="display:none; background:#F4F4F4">
    <xsl:if test='$GENERATE-FAQ-LABELS = "yes"'>
      <xsl:call-template name="get-label-title">
        <xsl:with-param name="label-type"><xsl:value-of select="$label-Answer"/></xsl:with-param>
      </xsl:call-template>
    <!--
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Answer'"/>
        <xsl:with-param name="stringFile" select="$StringFile"/>
      </xsl:call-template>
	-->
    </xsl:if>
    <xsl:apply-templates/>
  </div>
</xsl:template>


<!-- A specialized rule can customize the processing of a base element
     within its content.  This rule provides special behavior for keyword
     elements in the context of a faqlist. -->

<xsl:template match="*[contains(@class,' faq/faqlist ')] // 
    *[contains(@class,' topic/keyword ')]">
  <span style="font-style: italic;">
    <xsl:apply-templates/>
  </span>
</xsl:template>

</xsl:stylesheet>
