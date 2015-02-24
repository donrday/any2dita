<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>


	<xsl:output method="html"
	            indent="no"
	/>
	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/>
  
    
	<xsl:param name="groupName" select="''"/>
	<xsl:param name="mapName" select="''"/>

  	
<!-- Template to generate Business Model Canvas -->
  <xsl:template match="*[contains(@outputclass,'se-bmc-head')]">
    <xsl:apply-templates/>
    <div class="tablenoborder"><table
      cellpadding="4" cellspacing="0" summary="" id="ref-bmc-main01__tabblank01madeup" class="table" width="100%" frame="border" border="1" rules="all"><xsl:value-of select="$newline"/>
      <tbody class="tbody"><xsl:value-of select="$newline"/>
        <tr class="row"><xsl:value-of select="$newline"/>
          <td class="entry" rowspan="2" valign="top" width="20%"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Key Partners (KP)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-kp')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/kp-cell</xsl:comment><xsl:value-of select="$newline"/>
         
          <td class="entry" valign="top" width="20%"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Key Activities (KA)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-ka')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/ka-cell</xsl:comment><xsl:value-of select="$newline"/>
         
          <td class="entry" rowspan="2" colspan="2" valign="top"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Value Propositions (VP)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-vp')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/vp-cell</xsl:comment><xsl:value-of select="$newline"/>
         
          <td class="entry" valign="top" width="20%"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Customer Relationships (CR)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-cr')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/cr-cell</xsl:comment><xsl:value-of select="$newline"/>
         
          <td class="entry" rowspan="2" valign="top" width="20%"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Customer Segments (CS)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-cs')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/cs-cell</xsl:comment><xsl:value-of select="$newline"/>
         
        </tr><xsl:value-of select="$newline"/>
       
        <tr class="row"><xsl:value-of select="$newline"/>
          <td class="entry" valign="top" width="20%"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Key Resources (KR)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-kr')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/kr-cell</xsl:comment><xsl:value-of select="$newline"/>
         
          <td class="entry" valign="top" width="20%"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Channels (CH)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-ch')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/ch-cell</xsl:comment><xsl:value-of select="$newline"/>
         
        </tr><xsl:value-of select="$newline"/>
       
        <tr class="row"><xsl:value-of select="$newline"/>
          <td class="entry" colspan="3" valign="top"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Cost Structure (C$)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-c$')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/cs-cell</xsl:comment><xsl:value-of select="$newline"/>
         
          <td class="entry" colspan="3" valign="top"><xsl:value-of select="$newline"/>
            <div class="jks-bmc-cell-head">Revenue Streams (R$)</div><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="..//section[contains(@outputclass,'se-r$')]/*" mode="bmc-cell-contents"/>
          </td><xsl:comment>/rs-cell</xsl:comment><xsl:value-of select="$newline"/>
         
        </tr><xsl:comment>/bot-row</xsl:comment><xsl:value-of select="$newline"/>
       
      </tbody><xsl:comment>/kp-cell</xsl:comment><xsl:value-of select="$newline"/>
     
    </table><xsl:comment>/bmc-table</xsl:comment><xsl:value-of select="$newline"/>
     
    </div><xsl:comment>/kbmc-div</xsl:comment><xsl:value-of select="$newline"/>
   
   
  </xsl:template>
 
  <!-- Process with rules for bmc content -->
  <!-- This needs some attention - I should not need to directly refer to title (should use class,
      but cannot get right priority if I do.) -->
  <xsl:template match="title" mode="bmc-cell-contents">
    <xsl:comment>/wasyyydirect</xsl:comment>
    <div class="jks-bmc-grouptitle"><xsl:apply-templates/></div><xsl:value-of select="$newline"/>
  </xsl:template>
 
  <xsl:template match="*[contains(@class,' title ')]" mode="bmc-cell-contents" priority="2.0">
    <xsl:comment>/waszzz</xsl:comment>
    <div class="jks-bmc-grouptitle"><xsl:apply-templates/></div><xsl:value-of select="$newline"/>
  </xsl:template>
 
  <xsl:template match="p" mode="bmc-cell-contents" priority="2.0">
    <xsl:comment>/waspppdirect</xsl:comment>
    <p class="jks-bmc-sticker"><xsl:apply-templates/></p><xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' p ')]" mode="bmc-cell-contents" priority="2.0">
    <xsl:comment>/wasppp</xsl:comment>
    <p class="jks-bmc-sticker"><xsl:apply-templates/></p><xsl:value-of select="$newline"/>
  </xsl:template>
 
  <xsl:template  match="*"  mode="bmc-cell-contents">
    <xsl:apply-templates select="." />
  </xsl:template>

 
  <!-- Suppress bmc sections outside the table -->
  <xsl:template match="section[contains(@outputclass,'se-kp')]"/>
  <xsl:template match="section[contains(@outputclass,'se-ka')]"/>
  <xsl:template match="section[contains(@outputclass,'se-kr')]"/>
  <xsl:template match="section[contains(@outputclass,'se-vp')]"/>
  <xsl:template match="section[contains(@outputclass,'se-cr')]"/>
  <xsl:template match="section[contains(@outputclass,'se-ch')]"/>
  <xsl:template match="section[contains(@outputclass,'se-cs')]"/>
  <xsl:template match="section[contains(@outputclass,'se-c$')]"/>
  <xsl:template match="section[contains(@outputclass,'se-r$')]"/>



</xsl:stylesheet>