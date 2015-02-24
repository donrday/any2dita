<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!-- entities to substitute during editing to prevent literal instantiation -->
  <!ENTITY gt            "&amp;gt;"> 
  <!ENTITY lt            "["> 
]>
<xsl:stylesheet 
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  >

<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

  
<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>
<xsl:param name="contentPath" select="''"/>
<xsl:param name="zqueryPath" select="''"/>
<xsl:param name="headlevel1" select="'1'"/>
<xsl:param name="headclass1" select="''"/>
<xsl:param name="classlevel1" select="''"/>
<xsl:param name="metaline" select="'metaline'"/>
<xsl:param name="classimage" select="'image'"/>

<!--  parameters for building expeDITA links -->
<xsl:param name="targPath">./</xsl:param>
<xsl:param name="outputpath">./</xsl:param>
<xsl:param name="patchpath">./</xsl:param>
<xsl:variable name="queryPath" select="$patchpath"/>

<xsl:param name="outmode">nav</xsl:param>

<xsl:include href="a2d_map.xsl"/>
<xsl:include href="a2d_topic.xsl"/>


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

