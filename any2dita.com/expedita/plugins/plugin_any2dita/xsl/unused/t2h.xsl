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
<!DOCTYPE xsl:stylesheet [
<!-- entities to substitute during editing to prevent literal instantiation -->
  <!ENTITY gt            "&amp;gt;"> 
  <!ENTITY lt            "["> 
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>


<!-- patch #3 DRD -->
<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/>
  
  
<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>
<xsl:param name="contentDir" select="''"/>
<xsl:param name="groupName" select="''"/>
  
<!-- utilities for the php interaction -->

<!-- markup conversion: topic elements -->

	<!-- drop the processing into the first document element -->
	<xsl:template match='/' >
		<xsl:apply-templates/>
	</xsl:template>
	



	<!-- =============dita (compound)=============== -->

	<xsl:template match='dita'>
		<xsl:message>The 'compound' topic type is not supported by the h2t return transform.</xsl:message>
		<div class="compound">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

<!-- markup conversion: topic elements -->
	
	<!-- =============topic=============== -->

	<xsl:template match='*[contains(@class," topic/topic ")]'>
	<html>
	<body>
		<xsl:apply-templates/>
	</body>
	</html>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/titlealts ")]'>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/body ")]'>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/section ")]'>
		<div class="section">
		<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/example ")]'>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Ignored for now; support via forms? -->
	
	<xsl:template match='*[contains(@class," topic/prolog ")]'/>
	

	<!-- all specializations restore their structure from the local-name cue stored in @class here -->
	<xsl:template match='*[contains(@class," topic/topic ")]/*[contains(@class," topic/title ")]'>
		<h1 class="topictitle1 {local-name(parent::*)}">
	 		<xsl:if test="ancestor::*/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::*/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:if test='ancestor::*/@xml:lang'>
				<xsl:attribute name="lang"><xsl:value-of select="ancestor::*/@xml:lang"/></xsl:attribute>
			</xsl:if>
			<xsl:if test='ancestor::*/@outputclass'>
				<xsl:attribute name="style"><xsl:value-of select="ancestor::*/@outputclass"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</h1>
	</xsl:template>

<!-- ========== Structural elements that generate restoration cues =========== -->

	<xsl:template match='*[contains(@class," topic/shortdesc ")]'>
		<p class='shortdesc'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/navtitle")]'>
		<p class="navtitle">Navtitle: <xsl:apply-templates/></p>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/searchtitle")]'>
		<p class="searchtitle">Searchtitle: <i><xsl:apply-templates/></i></p>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]'>
		<h2 class="sectionTitle">
 			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
 			<!-- support conref on the parent element level of granularity (ie, section and example only) -->
			<xsl:apply-templates/>
		</h2>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/example ")]/*[contains(@class," topic/title ")]'>
		<h2 class="exampleTitle">
 			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]' mode="label">
		<h2><xsl:apply-templates/></h2>
	</xsl:template>

	<!-- =============common topic content=============== -->

	<xsl:template match='cite'>
		<span class='cite'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='q'>
		<span class='q'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='dl'>
		<dl>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</dl>
	</xsl:template>

	<xsl:template match='dlentry'>
		<div class='dlentry'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='dt'>
		<dt>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<xsl:template match='dd'>
		<dd>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<xsl:template match='fig'>
		<div class='fig'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='fig/title'>
		<h4 class='figTitle'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</h4>
	</xsl:template>

    <xsl:template match="image[@placement='break']">
        <img src='{@href}'>
			<xsl:attribute name="class">imageBreak<xsl:if test="@class"><xsl:text> </xsl:text><xsl:value-of select="@class"/></xsl:if></xsl:attribute>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test='@width'><xsl:attribute name='width'><xsl:value-of select='@width'/></xsl:attribute></xsl:if>
			<xsl:if test='@height'><xsl:attribute name='height'><xsl:value-of select='@height'/></xsl:attribute></xsl:if>
			<!-- do no content processing; restore image from metadata on output-->
			<b>[image:<xsl:value-of select="@href"/>]</b>
		</img>
	</xsl:template>

	<xsl:template match='image'>
        <img src='{@href}'>
			<xsl:attribute name="class">image<xsl:if test="@class"><xsl:text> </xsl:text><xsl:value-of select="@class"/></xsl:if></xsl:attribute>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test='@width'><xsl:attribute name='width'><xsl:value-of select='@width'/></xsl:attribute></xsl:if>
			<xsl:if test='@height'><xsl:attribute name='height'><xsl:value-of select='@height'/></xsl:attribute></xsl:if>
			<!-- do no content processing; restore image from metadata on output-->
			<xsl:if test="@title">
			<br/><b><xsl:value-of select="@title"/></b>
			</xsl:if>
		</img>
	</xsl:template>

	<xsl:template match='b'>
		<strong>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</strong>
	</xsl:template>

	<xsl:template match='i'>
		<em>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</em>
	</xsl:template>

	<xsl:template match='u'>
		<span  class="u" style="text-decoration: underline">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='lq'>
		<blockquote>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>

	<xsl:template match='pre'>
		<pre>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<xsl:template match='codeblock'>
		<pre class='codeblock' xml:space="preserve">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<xsl:template match='lines'>
		<pre class='lines' xml:space="preserve" style="font-family:arial, helvetica, sans-serif;">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<!-- address is a native editable element in RTEs, so it can't be cast as pre as we do for lines. Retaining breaks is hard, though. -->
	<xsl:template match='lines[@outputclass="address"]'>
		<address>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</address>
	</xsl:template>


	<xsl:template match='p'>
		<p class="p">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='note'>
		<p class='note'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
			<xsl:if test="@othertype"><xsl:attribute name="othertype"><xsl:value-of select="@othertype"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='xref'>
		<a>
			<xsl:attribute name='href'><xsl:value-of select='@href'/></xsl:attribute>
			<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
			<xsl:if test='@type'><xsl:attribute name='type'><xsl:value-of select='@type'/></xsl:attribute></xsl:if>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:choose>
				<xsl:when test="normalize-space(.)">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<span class="null"><xsl:value-of select='@href'/></span>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template match='ul'>
		<ul>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match='ol'>
		<ol>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<xsl:template match='li'>
		<li>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='sl'>
		<ul class="sl">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match='sli'>
		<li class="sli">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='indexterm'>
		<span class='indexterm'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
<!-- dcm: add handling for ph element -->
	<xsl:template match='ph'>
		<span class='phrase'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match='term'>
		<span class='term'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	


	<!-- missed element catch-all -->
	<!-- pass any other nodes through unchanged/ use class value to retrieve unchanged -->
	<xsl:template match="*">
		<span class="unmatched {name(.)}" style="background-color: yellow">
			<xsl:copy-of select="."/>
		</span>
	</xsl:template>
	
	<xsl:template name="leftovers">
		<!-- bug: case of both @title and title were calling BOTH transforms; pick one -->
		<xsl:choose>
			<xsl:when test="title">
				<xsl:apply-templates select='title'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@title">
					<xsl:apply-templates select="@title"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
		<!-- drd: table to html editors 
	<simpletable>
	-->
	<xsl:template match='simpletable'>
		<div class='simpletable'>
			<xsl:if test='@relcolwidth'>
				<xsl:attribute name='relcolwidth'><xsl:value-of select='@relcolwidth'/></xsl:attribute>
			</xsl:if>
			<xsl:if test='@id'>
				<xsl:attribute name='id'><xsl:value-of select='@id'/></xsl:attribute>
			</xsl:if>
			<table border="1" ><!-- style="border:1px #ccffff solid;border-collapse:collapse;"-->
				<xsl:apply-templates select='p[@class = "caption"]' mode='once'/>
				<tbody>
					<xsl:apply-templates/>
				</tbody>
			</table>
		</div>
	</xsl:template>
	
	<xsl:template match='p[@class = "caption"]' mode='once'>
		<title><xsl:apply-templates/></title>
	</xsl:template>

	<xsl:template match='sthead'>
		<tr><xsl:apply-templates mode='sthead'/></tr>
	</xsl:template>

	<xsl:template match='strow'>
		<tr><xsl:apply-templates mode='strow'/></tr>
	</xsl:template>

	<xsl:template match='stentry' mode='sthead'>
		<th>
			<xsl:apply-templates/>
		</th>
	</xsl:template>

	<xsl:template match='stentry' mode='strow'>
		<td>
			<xsl:choose>
				<xsl:when test='node()'>
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<span>.</span>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>
	
	
		<!-- drd: table to html editors 
	<table frame="all" id="S0036D47F">
	-->
<xsl:template match='xtable'>
	<div class='table'>
		<xsl:if test='@frame'><!-- if converting from HTML table to simpletable, this would be implicit, thus unnecessary-->
			<xsl:attribute name='frame'><xsl:value-of select='@frame'/></xsl:attribute>
		</xsl:if>
		<xsl:if test='@id'>
			<xsl:attribute name='id'><xsl:value-of select='@id'/></xsl:attribute>
		</xsl:if>
		<table border="1" ><!--style="border:thin #ccffff solid;border-collapse:collapse;"-->
			<xsl:apply-templates select='title'/>
			<xsl:apply-templates select='desc'/>
			<xsl:apply-templates select='tgroup'/>
		</table>
	</div>
</xsl:template>

<!-- use class or style to convey DITA table metadata into the HTML instance; use h2t to restore those. -->
<xsl:template match='table'>
		<table border="1" ><!--style="border:thin #ccffff solid;border-collapse:collapse;"-->
		<xsl:apply-templates select='title'/>
		<xsl:apply-templates select='desc'/>
		<xsl:apply-templates select='tgroup'/>
	</table>
</xsl:template>

<xsl:template match='table/title'>
	<caption><xsl:apply-templates/></caption>
</xsl:template>

<xsl:template match='tgroup'>
	<tgroup>
		<xsl:if test='@colsep'>
			<xsl:attribute name='colsep'><xsl:value-of select='@colsep'/></xsl:attribute>
		</xsl:if>
		<xsl:if test='@cols'>
			<xsl:attribute name='cols'><xsl:value-of select='@cols'/></xsl:attribute>
		</xsl:if>
		<xsl:apply-templates/>
	</tgroup>
</xsl:template>

<!-- for some reason, colspecs are nesting and tgroup shows up out of sequence. -->
	<xsl:template match='colspec'>
		<colspec>
			<xsl:copy-of select="@*"/>
		</colspec>
<!--
    <xsl:for-each select="colspec">
      <colgroup>
        <xsl:attribute name='align'>center</xsl:attribute>
      </colgroup>
    </xsl:for-each>
-->
	</xsl:template>
 
	<xsl:template match='thead'>
		<thead><xsl:apply-templates mode='thead'/></thead>
	</xsl:template>

	<xsl:template match='tbody'>
		<tbody><xsl:apply-templates mode='tbody'/></tbody>
	</xsl:template>

	<xsl:template match='row' mode='thead'>
		<tr>
			<xsl:apply-templates mode='thead'/>
		</tr>
	</xsl:template>

	<xsl:template match='row' mode='tbody'>
		<tr>
			<xsl:apply-templates mode='tbody'/>
		</tr>
	</xsl:template>

	<xsl:template match='entry' mode='thead'>
		<th>
			<xsl:apply-templates/>
		</th>
	</xsl:template>

	<xsl:template match='entry' mode='tbody'>
		<td>
			<xsl:apply-templates/>
		</td>
	</xsl:template>






<!-- hi domain -->

	<xsl:template match='b'>
		<strong><xsl:apply-templates/></strong>
	</xsl:template>

	<xsl:template match='i'>
		<em><xsl:apply-templates/></em>
	</xsl:template>

	<xsl:template match='u'>
		<u><xsl:apply-templates/></u>
	</xsl:template>

	<xsl:template match='sup'>
		<sup><xsl:apply-templates/></sup>
	</xsl:template>

	<xsl:template match='sub'>
		<sub><xsl:apply-templates/></sub>
	</xsl:template>

	<xsl:template match='tt'>
		<tt><xsl:apply-templates/></tt>
	</xsl:template>
<!-- /hi domain -->

<!-- ut domain -->
	<xsl:template match='area'>
		<area><xsl:apply-templates/></area>
	</xsl:template>
	
	<xsl:template match='shape'>
		<shape><xsl:apply-templates/></shape>
	</xsl:template>
	
	<xsl:template match='coords'>
		<coords><xsl:apply-templates/></coords>
	</xsl:template>
<!-- /ut domain -->

<!-- pr domain -->
<!-- /pr domain -->

<!-- sw domain -->
<!-- /sw domain -->

<!-- ui domain -->

<xsl:template match='uicontrol'>	
  <span class="uicontrol" >
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match='shortcut'>
  <span class="shortcut" style="text-decoration:underline">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match='menucascade'>	
  <span class="menucascade">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match='wintitle'>	
  <span class="wintitle">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match='screen'>
	<pre class='screen'>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<xsl:apply-templates/>
	</pre>
</xsl:template>

<!-- /ui domain -->



<!-- support for scripting language -->

	<xsl:template match="foreign">
		<div class = 'foreign'>
			<xsl:apply-templates mode="ditascript"/>
		</div>
	</xsl:template>

	<xsl:template match="foreign/*" mode="ditascript">
		<span class='{name(.)}'>
			<xsl:if test='@title'><!-- this if test is only to migrate earlier deperecated syntax. -->
				<xsl:value-of select='@title'/>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>


<!-- Generic support for CTR specializations (beyond this, no other specializations are generically supported) -->


	<!-- =============concept=============== -->
	
	<xsl:template match='*[contains(@class," concept/concept ")]'>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," concept/conbody ")]'>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- =============task=============== -->
	
	<xsl:template match='*[contains(@class," task/task ")]'>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," task/taskbody ")]'>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," task/context ")]'>
		<div class='context'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match='prereq'>
		<div class='prereq'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
    
	<xsl:template match='postreq'>
		<div class='postreq'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match='result'>
		<div class='result'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='task/example'>
		<div class='taskexample'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='steps'>
		<ol class="steps">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<xsl:template match='step'>
		<li class="step">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='cmd'>
		<b class="cmd">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</b><xsl:text> </xsl:text>
	</xsl:template>


	<xsl:template match='info'>
		<p class="info">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='stepresult'>
		<p class="stepresult">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>




	<!-- =============reference=============== -->

	<xsl:template match='reference'>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='refbody'>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match='refsyn'>
		<div class='refsyn'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='refsyn/title'>
		<h3 class="sectionTitle">
 			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>




<!-- markup conversion: map elements -->

	<!-- =============map=============== -->
	<!-- 
		Pass navtitle content into the HTML editor as if it were element content.
		This makes it plainly editable! The editor has a link dialog already, so don't bother with href. 
	-->
	<xsl:template name='map' match='*[contains(@class," map/map ")]'>
			<h1 class="topictitle1 {local-name()}">
		 		<xsl:if test="@id">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>
				<xsl:if test='@xml:lang'>
					<xsl:attribute name="lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test='@title'>
						<xsl:value-of select='@title'/>
					</xsl:when>
					<xsl:when test='title'>
						<xsl:apply-templates select='title'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Default map title</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</h1>
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
			<ul>
				<xsl:apply-templates select='topicref|topichead|topicgroup'/>
			</ul>
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]'>
		<xsl:apply-templates/>
	</xsl:template>


	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- null these out completely for now; not supported in speckedit -->
	</xsl:template>

	<!-- =============common map content=============== -->

	<xsl:template match='*[contains(@class," map/topicref ")]'>
		<li class='topicref'>
			<a>
				<xsl:attribute name='href'><xsl:value-of select='@href'/></xsl:attribute>
				<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
				<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
				<xsl:choose>
					<xsl:when test="@navtitle">
						<xsl:value-of select="@navtitle"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- force a value so that the element is not left empty. -->
						<!--{navigation title for: <xsl:value-of select="@href"/>}-->
						<!-- For low oops function, just silently fill this for now. -->
						<xsl:value-of select="document(@href)/*/title"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test='*[contains(@class," map/topicref ")]'>
					<ul>
						<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
					</ul>
				</xsl:if>
			</a>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," mapgroup-d/topicgroup ")]'>
		<li class='topicgroup'>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," mapgroup-d/topichead ")]'>
		<li class='topichead'>
			<xsl:value-of select="@navtitle"/>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
		<li class='topicmeta'>
			<xsl:value-of select="@navtitle"/>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	

	<!-- Related Links -->

	<xsl:template match='*[contains(@class," topic/related-links ")]'>
		<div class="widget news lead">
		<xsl:choose>
			<xsl:when test="1 = 0">
				<div>
					<!--h4>Related Insights</h4-->
					<xsl:apply-templates select='*[contains(@class," topic/title ")]' mode="label"/>
					<ul>
						<xsl:apply-templates/>
					</ul>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<!-- related links should be configurable, not compulsive -->
			</xsl:otherwise>
		</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template name='topicref' match='*[contains(@class," topic/link ")]'>
		<li class='topicref nav'>
			<xsl:call-template name="newlink"/>
			<xsl:apply-templates select='*[contains(@class," topic/desc ")]'/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/llink ")]'>
		<li>
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

	<xsl:template match='*[contains(@class," topic/linklist ")]' mode="null">
		<li>
			<xsl:apply-templates select='*[contains(@class," topic/title ")]' mode="label"/>
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
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/linktext ")]'>
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- This is a replacement for the PHP-based transform in doSidebar.php, built by passing a subset to transform in t2h from extract_keywords.php -->
	<xsl:template match='*[contains(@class," topic/linklist ")]'>
		<div class="widget news lead">
			<h4><xsl:apply-templates select='*[contains(@class," topic/title ")]' mode="label"/></h4>
			<xsl:if test='linklist'>
				<ul class="ui">
					<xsl:for-each select='*[contains(@class," topic/link ")]'>
						<xsl:variable name="format"><xsl:value-of select="@format"/></xsl:variable>
						<xsl:variable name="href"><xsl:value-of select="substring-before(@href,'.')"/></xsl:variable>
						<!-- $href = strip_ext($href); -->
						<xsl:variable name="resource-fn">
							<xsl:value-of select="substring-before($href,'.')"/>
						</xsl:variable>
					<li style='margin-bottom:0;'>
						<a style='text-decoration:none;' href='{$serviceType}/topic/{$href}'><xsl:value-of select="linktext/text()"/></a>
					</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<xsl:apply-templates select='*[contains(@class," topic/linkinfo ")]'/>
		</div>
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
				<!-- parse the href so that we can peek here and there -->
				<xsl:variable name='path'>
					<xsl:choose>
						<xsl:when test='contains(@href,"#") and (substring-before(@href,"#")="")'>
							<xsl:value-of select='substring-before(@href,"#")'/>
						</xsl:when>
						<xsl:when test='contains(@href,"#")'>
							<xsl:value-of select='substring-before(@href,"#")'/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select='@href'/>
						</xsl:otherwise>
					</xsl:choose>		
				</xsl:variable>
				<xsl:variable name="resource-fn">
					<xsl:value-of select="substring-before($path,'.')"/>
				</xsl:variable>
				<!-- normalize any nested path by converting path separator / into a period . -->
				<!-- 16 Dec 2011 DRD: reverted the dotted-href logic so that we can try traversing folders normally -->
				<xsl:variable name="dotted-href">
					<xsl:value-of select='$resource-fn'/>
				<!--
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text" select="$resource-fn" />
						<xsl:with-param name="replace" select="'/'" />
						<xsl:with-param name="by" select="'.'" />
					</xsl:call-template>
				-->
				</xsl:variable>
				<!-- The groupName and mapName values were passed in by the calling context (known context) -->
				<xsl:text>resource</xsl:text>/<xsl:value-of select="$groupName"/>/<xsl:value-of select="$mapName"/>/<xsl:value-of select="$dotted-href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<a class="a nav" href='{$fixedhref}'>
		<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<span class="navtitle">
			<xsl:choose>
				<xsl:when test="@navtitle">
					<xsl:value-of select="@navtitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- force a value so that the element is not left empty. -->
					<span style="color:red;">(no navtitle) <xsl:value-of select="@href"/></span>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</a>
</xsl:template>



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