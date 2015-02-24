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
<xsl:stylesheet version='1.0'
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
 


<!--
For xslt 1.0, xsl:output assignments can't take attribute value templates, eg ="{$systemid}",
so see the forced root rule below.
&#xa;
			doctype-public="-//OASIS//DTD DITA Topic//EN"
			doctype-system="../dtd/topic.dtd"
-->

	<xsl:output method="xml"
            encoding="utf-8"
            indent="yes"
			standalone="no"
			omit-xml-declaration="no"/>

	<xsl:strip-space elements="html head body div"/>


	<xsl:template match="/">
		<xsl:param name="infotype"><xsl:value-of select="//h1[1]/@class"/></xsl:param>
		<xsl:variable name="doctype">
		    <xsl:choose>
		        <xsl:when test='contains($infotype,"concept")'>concept</xsl:when>
		        <xsl:when test='contains($infotype,"task")'>task</xsl:when>
		        <xsl:when test='contains($infotype,"reference")'>reference</xsl:when>
		        <xsl:otherwise>topic</xsl:otherwise>
		    </xsl:choose>
		</xsl:variable>
		<!--xsl:message>[<xsl:value-of select="$infotype"/>:<xsl:value-of select="//h1[1]"/>]</xsl:message-->
		<xsl:variable name="publicid">
		    <xsl:choose>
		        <xsl:when test="$infotype='concept'">-//OASIS//DTD DITA Concept//EN</xsl:when>
		        <xsl:when test="$infotype='task'">-//OASIS//DTD DITA Task//EN</xsl:when>
		        <xsl:when test="$infotype='reference'">-//OASIS//DTD DITA Reference//EN</xsl:when>
		        <xsl:otherwise>-//OASIS//DTD DITA Topic//EN</xsl:otherwise>
		    </xsl:choose>
		</xsl:variable>
	
		<xsl:variable name="systemid">
		    <xsl:choose>
		        <xsl:when test='contains($infotype,"concept")'>../dtd/concept.dtd</xsl:when>
		        <xsl:when test='contains($infotype,"task")'>../dtd/task.dtd</xsl:when>
		        <xsl:when test='contains($infotype,"reference")'>../dtd/reference.dtd</xsl:when>
		        <xsl:otherwise>../dtd/topic.dtd</xsl:otherwise>
		    </xsl:choose>
		</xsl:variable>
		<xsl:value-of disable-output-escaping="yes"
			select="concat('&lt;!DOCTYPE ', $doctype, ' PUBLIC &quot;', 
			$publicid, '&quot; &quot;',
			$systemid, '&quot;&gt;')"/>
	<xsl:comment>Leaving ROOT</xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='html'>
		<xsl:comment>Got into HTML</xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='head'>
		<xsl:comment>Got into HEAD</xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='body' priority="100">
		<xsl:param name="infotype"><xsl:value-of select="//h1[1]/@class"/></xsl:param>
		<xsl:comment>Got into BODY</xsl:comment>
		<xsl:choose>
	        <xsl:when test='contains($infotype,"concept")'>
				<concept>
					<xsl:if test='//h1[@lang]'>
						<xsl:attribute name='xml:lang'><xsl:value-of select="//h1/@lang"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="//h1[@id]">
						<xsl:attribute name="id"><xsl:value-of select="//h1/@id"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="//h1[@class]" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'titlealts']" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'shortdesc']" mode="once"/>
			
					<conbody>
						<!--[rest of the converted content]-->
						<xsl:apply-templates/>
					</conbody>
				</concept>
		    </xsl:when>
		    <xsl:when test='contains($infotype,"task")'>
				<task>
					<xsl:if test='//h1[@lang]'>
						<xsl:attribute name='xml:lang'><xsl:value-of select="//h1/@lang"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="//h1[@id]">
						<xsl:attribute name="id"><xsl:value-of select="//h1/@id"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="//h1[@class]" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'tagline']" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'shortdesc']" mode="once"/>
			
					<taskbody>
						<!--[rest of the converted content]-->
						<xsl:apply-templates/>
					</taskbody>
				</task>
		    </xsl:when>
		    <xsl:when test='contains($infotype,"reference")'>
				<reference>
					<xsl:if test='//h1[@lang]'>
						<xsl:attribute name='xml:lang'><xsl:value-of select="//h1/@lang"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="//h1[@id]">
						<xsl:attribute name="id"><xsl:value-of select="//h1/@id"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="//h1[@class]" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'tagline']" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'shortdesc']" mode="once"/>
			
					<refbody>
						<!--[rest of the converted content]-->
						<xsl:apply-templates/>
					</refbody>
				</reference>
		    </xsl:when>
		    <xsl:when test='contains($infotype," topic")'><!-- note the " " delimiter, otherwise will match on trimmed strings -->
				<topic>
					<xsl:if test="//h1[@style]">
						<xsl:attribute name="outputclass"><xsl:value-of select="//h1/@style"/></xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="//h1[@id]">
							<xsl:attribute name="id"><xsl:value-of select="//h1/@id"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="id">dmz<xsl:value-of select="generate-id()"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test='//h1[@lang]'>
						<xsl:attribute name='xml:lang'><xsl:value-of select="//h1/@lang"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="//h1[@class]" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'tagline']" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'shortdesc']" mode="once"/>
			
					<body>
						<!--[rest of the converted content]-->
						<xsl:apply-templates/>
					</body>
				</topic>
		    </xsl:when>
		    <xsl:otherwise>
		        	<topic id="tempid">
						<xsl:apply-templates select="//h1[1]" mode="once"/>
						<xsl:apply-templates select="//p[@class = 'tagline']" mode="once"/>
						<xsl:apply-templates select="//xp[1]" mode="once"/><!-- pull the first para into shortdesc usage -->
						<body>
							<!--[rest of the converted content]-->
							<xsl:apply-templates/>
						</body>
		        	</topic>
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>

	<xsl:template match="div[@class = 'compound']">
		<xsl:message>The 'compound' topic type is not supported by the h2t return transform.</xsl:message>
		<dita>
			<xsl:apply-templates/>
		</dita>
	</xsl:template>
	
	<!-- get rid of rich-text attribution sometimes copied into the content inadvertently -->
	<xsl:template match="span[@class = 'Apple-style-span']">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- get rid of rich-text attribution sometimes copied into the content inadvertently -->
	<xsl:template match="span[@class = 'Apple-style-span Apple-style-span']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="p[@class = 'tagline']" mode="once">
		<titlealts><navtitle><xsl:apply-templates/></navtitle></titlealts>
	</xsl:template>

	<xsl:template match="p[@class = 'shortdesc']" mode="once">
		<shortdesc><xsl:apply-templates/></shortdesc>
	</xsl:template>

	<!-- DITA body elements are generated by the first H1 context -->
	<xsl:template match="body">
		<xsl:apply-templates/>
	</xsl:template>

    <!-- this uses @class to hint the topic type. If present, it implies the topic title as well -->
	<xsl:template match="h1[@class]" mode="once">
		<title><xsl:apply-templates/></title>
	</xsl:template>
	
	<xsl:template match="h1[1]" mode="once">
		<title><xsl:apply-templates/></title>
	</xsl:template>
	
	<!-- turn off unintended reuse of hinted elements already processed elsewhere -->
	<xsl:template match="h1"/>
	<xsl:template match="p[@class = 'shortdesc']"/>
	<xsl:template match="p[@class = 'tagline']"/>
	<xsl:template match="xp[1]"/>
	
	<!-- in case there was no shortdesc, use any first paragraph in that role instead -->
	<xsl:template match="xp[1][not(@outputclass)]" mode="once">
		<shortdesc><xsl:apply-templates/></shortdesc>
	</xsl:template>
	
	<xsl:template match='h2 | h3 | h4 | h5 | h6'>
		<!-- convert invalid titles to bold paragraphs -->
		<p outputclass='{local-name()}'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<b><xsl:apply-templates/></b>
		</p>
	</xsl:template>

	<xsl:template match='blockquote'>
		<lq>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
            <xsl:apply-templates/>
		</lq>
	</xsl:template>

	<xsl:template match='div'>
<xsl:text>
</xsl:text>
		<p>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
<xsl:text>
</xsl:text>
	</xsl:template>


	<xsl:template match='span[@class = "cite"]'>
		<cite>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</cite>
	</xsl:template>

	<xsl:template match='span[@class = "q"]'>
		<q>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</q>
	</xsl:template>

	<xsl:template match='dl'>
		<dl>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</dl>
	</xsl:template>

	<xsl:template match='div[@class = "dlentry"]'>
		<dlentry>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</dlentry>
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
	
	<xsl:template match="div[@class = 'fig']">
		<fig>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</fig>
	</xsl:template>

	<xsl:template match="b[@class = 'figTitle']">
		<title><xsl:apply-templates/></title>
	</xsl:template>

	<xsl:template match="div[@class = 'section']">
		<section>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</section>
	</xsl:template>

	<xsl:template match="div[@class = 'example']">
		<example>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</example>
	</xsl:template>

	<xsl:template match="h4[@class = 'sectionTitle']">
		<title>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</title>
	</xsl:template>

	<xsl:template match="div[@class = 'sectionConref']">
		<section conref="{@id}">
		</section>
	</xsl:template>

	<xsl:template match="img[@class = 'imageBreak']">
		<image href="{@src}" placement="break">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test='@width'><xsl:attribute name='width'><xsl:value-of select='@width'/></xsl:attribute></xsl:if>
			<xsl:if test='@height'><xsl:attribute name='height'><xsl:value-of select='@height'/></xsl:attribute></xsl:if>
		</image>
	</xsl:template>

	<xsl:template match="img[@class = 'image']">
		<image href="{@src}">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test='@width'><xsl:attribute name='width'><xsl:value-of select='@width'/></xsl:attribute></xsl:if>
			<xsl:if test='@height'><xsl:attribute name='height'><xsl:value-of select='@height'/></xsl:attribute></xsl:if>
		</image>
	</xsl:template>

<!-- dcm: temp experimental handling of img -->
	<xsl:template match="img">
		<image href="{@src}" outputclass="use-img">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test='@width'><xsl:attribute name='width'><xsl:value-of select='@width'/></xsl:attribute></xsl:if>
			<xsl:if test='@height'><xsl:attribute name='height'><xsl:value-of select='@height'/></xsl:attribute></xsl:if>
			<xsl:if test='@align'><xsl:attribute name='align'><xsl:value-of select='@align'/></xsl:attribute></xsl:if>
			<xsl:if test='@alt'><xsl:attribute name='alt'><xsl:value-of select='@alt'/></xsl:attribute></xsl:if>
			<xsl:if test='@title'><xsl:attribute name='title'><xsl:value-of select='@title'/></xsl:attribute></xsl:if>
		</image>
	</xsl:template>
	
	<!-- highlighting domain elements -->
	<xsl:template match='b|strong|span[@style="font-weight: bold;"]'>
		<b><xsl:apply-templates/></b>
	</xsl:template>

	<xsl:template match='i|em|span[@style="font-style: italic;"]'>
		<i><xsl:apply-templates/></i>
	</xsl:template>

	<xsl:template match='u|span[@style="text-decoration: underline;"]'>
		<u><xsl:apply-templates/></u>
	</xsl:template>

	<xsl:template match='span[@style = "text-decoration: underline"]'>
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

	<xsl:template match='del'>
		<ph outputclass='strikethrough'><xsl:apply-templates/></ph>
	</xsl:template>
	<!-- /highlighting -->

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

<!-- ui domain -->

<xsl:template match="span[@class='uicontrol']">
  <uicontrol>
    <xsl:apply-templates/>
  </uicontrol>
</xsl:template>

<xsl:template match="span[@class='shortcut']">
  <shortcut>
    <xsl:apply-templates/>
  </shortcut>
</xsl:template>

<xsl:template match="span[@class='menucascade']">
  <menucascade>
    <xsl:apply-templates/>
  </menucascade>
</xsl:template>

<xsl:template match="span[@class='wintitle']">
  <wintitle>
    <xsl:apply-templates/>
  </wintitle>
</xsl:template>

<xsl:template match='pre[@class="screen"]'>
	<screen>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<xsl:apply-templates/>
	</screen>
</xsl:template>

<!-- /ui domain -->


	<xsl:template match='p[. = "this was supposed to trap and discard empty paragraphs. Disabled!"]'/>

	<xsl:template match='p[@class="p"]'>
		<p>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
<xsl:text>
</xsl:text>
	</xsl:template>



	<xsl:template match='p[@class = "note"]'>
		<note>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
			<xsl:if test="@othertype"><xsl:attribute name="othertype"><xsl:value-of select="@othertype"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</note>
	</xsl:template>

	<xsl:template match='a'>
		<xref>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test='@type'><xsl:attribute name='type'><xsl:value-of select='@type'/></xsl:attribute></xsl:if>
			<xsl:attribute name='href'><xsl:value-of select='@href'/></xsl:attribute>
			<xsl:choose>
				<xsl:when test='@target'>
					<xsl:attribute name="scope">
						<xsl:choose>
							<xsl:when test='@target="_new"'>external</xsl:when>
							<xsl:when test='@target="_blank"'>external</xsl:when>
							<xsl:when test='@target = ""'>local</xsl:when>
							<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test='contains(@href,"http://")'>
						<xsl:attribute name="scope">external</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="span[@class = 'null']">
					<!--Null filler-->
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xref>
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

	<xsl:template match='ul[class="sl"]'>
		<sl>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</sl>
	</xsl:template>

	<xsl:template match='li[class="sli"]'>
		<sli>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</sli>
	</xsl:template>

	<xsl:template match='address'>
		<lines outputclass="address">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</lines>
	</xsl:template>

	<xsl:template match='pre'>
		<pre>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<xsl:template match='pre[@class="lines"]'>
		<lines>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</lines>
	</xsl:template>

	<xsl:template match='pre[@class="codeblock"]'>
		<codeblock>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</codeblock>
	</xsl:template>


	<xsl:template match='span[@class="indexterm"]'>
		<indexterm>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</indexterm>
	</xsl:template>
	
	<xsl:template match='span[@class="phrase"]' priority="2">
		<ph>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ph>
	</xsl:template>
	
	<xsl:template match='span[@class="term"]'>
		<ph>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ph>
	</xsl:template>

	<xsl:template match='style'/>
	
	<xsl:template match='br'/>


	<!-- =================== reference specialization content ================= -->

	<xsl:template match="div[@class = 'refsyn']">
		<refsyn>
			<xsl:apply-templates/>
		</refsyn>
	</xsl:template>

	<!-- =================== task specialization content ================= -->
	
	<xsl:template match="div[@class = 'context']">
		<context>
			<xsl:apply-templates/>
		</context>
	</xsl:template>
	
	<xsl:template match="div[@class = 'prereq']">
		<prereq>
			<xsl:apply-templates/>
		</prereq>
	</xsl:template>
	
	<xsl:template match="div[@class = 'postreq']">
		<postreq>
			<xsl:apply-templates/>
		</postreq>
	</xsl:template>

	<xsl:template match="div[@class = 'result']">
		<result>
			<xsl:apply-templates/>
		</result>
	</xsl:template>
    
	<xsl:template match="div[@class = 'taskexample']">
		<example>
			<xsl:apply-templates/>
		</example>
	</xsl:template>
	
	<xsl:template match="ol[@class = 'steps']">
		<steps>
			<xsl:apply-templates/>
		</steps>
	</xsl:template>
	
	<xsl:template match="li[@class = 'step']">
		<step>
			<xsl:apply-templates/>
		</step>
	</xsl:template>

	<xsl:template match='b[@class="cmd"]'>
		<cmd>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</cmd>
	</xsl:template>
	
	<xsl:template match="p[@class = 'info']">
		<info>
			<xsl:apply-templates/>
		</info>
	</xsl:template>

	<xsl:template match="p[@class = 'stepresult']">
		<stepresult>
			<xsl:apply-templates/>
		</stepresult>
	</xsl:template>

	<!-- =================== Other ==================== -->
	

<!-- case of HTML table generated in the editor (this less specific rule should trigger before other variations) -->

	<xsl:template match='table'>
		<table>
			<xsl:if test='@border = "1"'>
				<xsl:attribute name='frame'>all</xsl:attribute>
			</xsl:if>
			<xsl:if test='@id'>
				<xsl:attribute name='id'><xsl:value-of select='@id'/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select='caption' mode='once'/>
			<xsl:variable name="numcols">
				<xsl:value-of select="count(tbody/tr[1]/td)"/>
			</xsl:variable>
			<tgroup>
				<xsl:attribute name="cols">
					<xsl:value-of select="$numcols"/>
				</xsl:attribute>
				<!-- multiple colspecs here -->
				<xsl:for-each select="tbody/tr[1]/td">
					<colspec colname="COLSPEC{count(.)}" colwidth="1*"/>
				</xsl:for-each>
				<!-- if present, tfoot gets moved to last row in tbody -->
				<xsl:if test='tfoot'>
					<xsl:comment> a tfoot was here </xsl:comment>
				</xsl:if>
				<!-- thead here -->
				<!-- tbody here -->
				<xsl:apply-templates select="thead" mode="htable"/>
				<tbody>
					<xsl:apply-templates select="tbody" mode="htable"/>
					<xsl:apply-templates select="tfoot" mode="htable"/>
				</tbody>
			</tgroup>
		</table>
	</xsl:template>
		
	<xsl:template match='caption' mode='once'>
		<title><xsl:apply-templates/></title>
	</xsl:template>

	<xsl:template match='thead' mode="htable">
		<thead>
			<xsl:apply-templates mode="htable"/>
		</thead>
	</xsl:template>

	<xsl:template match='tbody|tfoot'/>

	<xsl:template match='tbody' mode="htable">
			<xsl:apply-templates mode="htable"/>
	</xsl:template>
	
	<xsl:template match='tfoot' mode="once">
			<xsl:apply-templates mode="htable"/>
	</xsl:template>
	
	<xsl:template match='tgroup' mode="htable">
		<tgroup>
			<xsl:if test='@colsep'>
				<xsl:attribute name='colsep'><xsl:value-of select='@colsep'/></xsl:attribute>
			</xsl:if>
			<xsl:if test='@cols'>
				<xsl:attribute name='cols'><xsl:value-of select='@cols'/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="htable"/>
		</tgroup>
	</xsl:template>
	
	<xsl:template match='tr[th]' mode="htable">
		<row>
			<xsl:for-each select="th">
				<entry>
					<xsl:apply-templates/>
				</entry>
			</xsl:for-each>
		</row>
	</xsl:template>
	
	<xsl:template match='tr[td]' mode="htable">
		<row>
			<xsl:for-each select="td">
				<entry>
					<xsl:apply-templates/>
				</entry>
			</xsl:for-each>
		</row>
	</xsl:template>



<!-- for now, treat keywords as singleton commands (no parms, no child elements) -->
	<xsl:template match="span[@class]" mode="ditascript">
		<xsl:element name="{@class}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="span[@class]">
		<xsl:element name="{@class}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>