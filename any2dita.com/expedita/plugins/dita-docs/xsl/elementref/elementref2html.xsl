<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
    Sourceforge.net. See the accompanying license.txt file for 
    applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!--  
 | Specific override stylesheet for elementref (demo)
 | This demonstrates the XSLT override mechanism tied to a specialization.
 |
 *-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- generated string values (translatable) -->
	<xsl:variable name="StringFile" select="document('elementref_strings.xml')"/>
	<xsl:param name='label-Purpose'>Purpose</xsl:param>
	<xsl:param name='label-Containedby'>Contained by</xsl:param>
	<xsl:param name='label-Contains'>Contains</xsl:param>
	<xsl:param name='label-Examples'>Examples</xsl:param>
	<xsl:param name='label-Attributes'>Attributes</xsl:param>
	<xsl:param name='label-Name'>Name</xsl:param>
	<xsl:param name='label-Description'>Description</xsl:param>
	<xsl:param name='label-Type'>Type</xsl:param>
	<xsl:param name='label-DefaultValue'>Default Value</xsl:param>
	<xsl:param name='label-Required'>Req.</xsl:param>


<!-- this element is based on "term" which has implicit linking, so we provide
  processing to ensure that it does not default -->
<xsl:template match="*[contains(@class,' elementref/element ')]">
  <xsl:apply-templates/>
</xsl:template>

<!-- new behavior for longname (apply parentheses) -->
<xsl:template match="*[contains(@class,' elementref/longname ')]"><xsl:text> (</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
</xsl:template>


<xsl:template name="gen-user-styles">
<style type="text/css">
.optoffset { display: block; margin-left: 12pt;}
</style>
</xsl:template>


<!-- title subsections: -->
<xsl:template match="*[contains(@class,' elementref/elementname ')]">
  <h2 class="topictitle1"><xsl:apply-templates select="*[contains(@class,' elementref/element ')]"/><xsl:apply-templates select="longname"/></h2>
</xsl:template>


<!-- new behaviors for booleans in attrequired context -->
<xsl:template match="attrequired/boolean[@state='no']">No</xsl:template>
<xsl:template match="attrequired/boolean[@state='yes']"><b>Yes</b></xsl:template>



<!-- Section level headings: purpose, containedby, contains, attributes, examples-->

<xsl:template match="*[contains(@class,' elementref/purpose ')]">
  <div style="margin-top: 1em;">
    <span style="font-weight: bold;">
      <xsl:call-template name="get-label-title">
        <xsl:with-param name="label-type"><xsl:value-of select="$label-Purpose"/></xsl:with-param>
      </xsl:call-template>
    <!--
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Purpose'"/>
        <xsl:with-param name="stringFile" select="$StringFile"/>
      </xsl:call-template>
	-->
    </span>
  </div>
  <div class="optoffset"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="*[contains(@class,' elementref/containedby ')]">
  <div style="margin-top: 1em;">
    <span style="font-weight: bold;">
      <xsl:call-template name="get-label-title">
        <xsl:with-param name="label-type"><xsl:value-of select="$label-Containedby"/></xsl:with-param>
      </xsl:call-template>
    <!--
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Contained by'"/>
        <xsl:with-param name="stringFile" select="$StringFile"/>
      </xsl:call-template>
      -->
    </span>
  </div>
  <div class="optoffset"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="*[contains(@class,' elementref/contains ')]">
  <div style="margin-top: 1em;">
    <span style="font-weight: bold;">
      <xsl:call-template name="get-label-title">
        <xsl:with-param name="label-type"><xsl:value-of select="$label-Contains"/></xsl:with-param>
      </xsl:call-template>
    <!--
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Contains'"/>
        <xsl:with-param name="stringFile" select="$StringFile"/>
      </xsl:call-template>
      -->
    </span>
  </div>
  <div class="optoffset"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="*[contains(@class,' elementref/examples ')]">
  <div style="margin-top: 1em;">
    <span style="font-weight: bold;">
      <xsl:call-template name="get-label-title">
        <xsl:with-param name="label-type"><xsl:value-of select="$label-Examples"/></xsl:with-param>
      </xsl:call-template>
    <!--
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Examples'"/>
        <xsl:with-param name="stringFile" select="$StringFile"/>
      </xsl:call-template>
      -->
    </span>
  </div>
  <div class="optoffset"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="*[contains(@class,' elementref/attributes ')]">
  <div class="optoffset" id="{//elementref/@id}_attr">
  <div style="margin-top: 1em;">
    <span style="font-weight: bold;">
      <xsl:call-template name="get-label-title">
        <xsl:with-param name="label-type"><xsl:value-of select="$label-Attributes"/></xsl:with-param>
      </xsl:call-template>
    <!--
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Attributes'"/>
        <xsl:with-param name="stringFile" select="$StringFile"/>
      </xsl:call-template>
      -->
    </span>
  </div>
    <xsl:apply-templates/>
  </div>
</xsl:template>


<xsl:template match="*[contains(@class,' elementref/attlist ')]">
  <table border="1" cellpadding="4">
    <tr>
      <th bgcolor="silver">
      <xsl:call-template name="get-label-title">
			<xsl:with-param name="label-type"><xsl:value-of select="$label-Name"/></xsl:with-param>
      </xsl:call-template>
    <!--
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Name'"/>
          <xsl:with-param name="stringFile" select="$StringFile"/>
        </xsl:call-template>
        -->
      </th>
      <th bgcolor="silver">
		<xsl:call-template name="get-label-title">
			<xsl:with-param name="label-type"><xsl:value-of select="$label-Description"/></xsl:with-param>
		</xsl:call-template>
    <!--
       <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Description'"/>
          <xsl:with-param name="stringFile" select="$StringFile"/>
        </xsl:call-template>
        -->
      </th>
      <th bgcolor="silver">
      	<xsl:call-template name="get-label-title">
			<xsl:with-param name="label-type"><xsl:value-of select="$label-Type"/></xsl:with-param>
		</xsl:call-template>
      </th>
      <th bgcolor="silver">
      	<xsl:call-template name="get-label-title">
			<xsl:with-param name="label-type"><xsl:value-of select="$label-DefaultValue"/></xsl:with-param>
		</xsl:call-template>
      </th>
      <th bgcolor="silver">
      	<xsl:call-template name="get-label-title">
			<xsl:with-param name="label-type"><xsl:value-of select="$label-Required"/></xsl:with-param>
		</xsl:call-template>
      </th>
    </tr>
    <xsl:apply-templates/>
  </table>
</xsl:template>

<!-- we let this default to pick up conref processing for its base class -->
<xsl:template match="xattribute">
  <tr><xsl:apply-templates/></tr>
</xsl:template>

<!-- support only attname and attdesc for compact output -->
<xsl:template match="attname|attdesc">
  <td valign="top"><xsl:apply-templates/></td>
</xsl:template>

<!-- which means we need to consume these events to prevent fallthrough -->
<xsl:template match="*[contains(@class,' elementref/atttype ')]|*[contains(@class,' elementref/attdefvalue ')]|*[contains(@class,' elementref/attrequired ')]">
  <!--td valign="top"><xsl:apply-templates/></td-->
</xsl:template>



</xsl:stylesheet>
