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
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

	<!-- ideally,  preset a site default for it and also get this from the topic -->
	<xsl:param name="Lang" select="'en-us'"/>
	<!-- layout related -->
	<!-- (ie, set defaults for internal switches -->

	<!-- =============concept=============== -->
	<xsl:template name='concept' match='*[contains(@class," topic/topic concept/concept ")]'>
        <xsl:apply-templates select='*[contains(@class," topic/prolog ")]'/>
        <xsl:apply-templates select='*[contains(@class," topic/title ")]' mode='topiccontent'/>
        <xsl:apply-templates select='*[contains(@class," topic/titlealts ")]'/>
        <xsl:apply-templates select='*[contains(@class," topic/shortdesc ")]'/>
        <xsl:apply-templates select='*[contains(@class," topic/body concept/conbody ")]'/>
		<xsl:apply-templates select='*[contains(@class," topic/related-links ")]'/>
	</xsl:template>

	<xsl:template match='*[contains(@class," concept/conbody ")]'>
		<div class='conbody'>
			<xsl:apply-templates/>
	    </div>
	    <xsl:comment>/conbody</xsl:comment>
	</xsl:template>

</xsl:stylesheet>