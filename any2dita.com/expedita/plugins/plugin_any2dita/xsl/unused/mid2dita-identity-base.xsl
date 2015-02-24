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
 <!--
     	xmlns:php="http://php.net/xsl"
    		extension-element-prefixes="php"
 -->
<xsl:stylesheet version='1.0'
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:exsl="http://exslt.org/common"
        	extension-element-prefixes="exsl">
 


<!--
For xslt 1.0, xsl:output assignments can't take attribute value templates, eg ="{$systemid}",
so see the forced root rule below.
&#xa;
			doctype-public="-//OASIS//DTD DITA Topic//EN"
			doctype-system="../dtd/topic.dtd"
-->

	<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
			standalone="no"
			omit-xml-declaration="yes"/>

	<xsl:strip-space elements="html head body div pre"/>

	<xsl:param name="scopeval"></xsl:param>
	<xsl:param name="outputpath">../Content/Xfer</xsl:param>

	<xsl:param name="outproc">concept</xsl:param>
	<xsl:param name="prefix">c_</xsl:param>
	<xsl:param name="setname">BZQ_</xsl:param>
	<xsl:param name="itemname">n_</xsl:param>
	<xsl:param name="namebase">topic/title:lower:spacetodash</xsl:param>
	<xsl:param name="namepattern">{prefix}{setname}{itemname}{namebase}</xsl:param>

<xsl:template match="*">
   <xsl:variable name="class" select="generate-id(@class)"/>
   <xsl:variable name="space" select="generate-id(@xml:space)"/>
   <xsl:copy>
      <xsl:copy-of select="@*[(generate-id(.)!=$class) and (generate-id(.)!=$space)]" />
      <xsl:apply-templates />
   </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()">
   <xsl:copy />
</xsl:template>	



</xsl:stylesheet>