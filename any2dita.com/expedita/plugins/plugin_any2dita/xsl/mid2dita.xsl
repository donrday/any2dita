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
	<xsl:param name="targPath">./</xsl:param>
	<xsl:param name="outputpath">./</xsl:param>
	<xsl:param name="fullpath" select="'http://example.com'"/>

	<xsl:param name="outproc">test</xsl:param>
	<xsl:param name="prefix">c_</xsl:param>
	<xsl:param name="setname">BZQ_</xsl:param>
	<xsl:param name="itemname">n_</xsl:param>
	<xsl:param name="namebase">topic/title:lower:spacetodash</xsl:param>
	<xsl:param name="namepattern">{prefix}{setname}{itemname}{namebase}</xsl:param>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="dontusethisroot">
		<xsl:param name="infotype"><xsl:value-of select="//article[1]/@class"/></xsl:param>
		<xsl:variable name="doctype">
		    <xsl:choose>
		        <xsl:when test="$infotype='concept'">concept</xsl:when>
		        <xsl:when test="$infotype='task'">task</xsl:when>
		        <xsl:when test="$infotype='reference'">reference</xsl:when>
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
		        <xsl:when test="$infotype='concept'">../dtd/concept.dtd</xsl:when>
		        <xsl:when test="$infotype='task'">../dtd/task.dtd</xsl:when>
		        <xsl:when test="$infotype='reference'">../dtd/reference.dtd</xsl:when>
		        <xsl:otherwise>../dtd/topic.dtd</xsl:otherwise>
		    </xsl:choose>
		</xsl:variable>
		<xsl:value-of disable-output-escaping="yes"
			select="concat('&lt;!DOCTYPE ', $doctype, ' PUBLIC &quot;', 
			$publicid, '&quot; &quot;',
			$systemid, '&quot;&gt;')"/>
		<xsl:apply-templates/>
	</xsl:template>



	<xsl:template match="protomap">
		<!-- apply lightweight DITA map doctype here -->
		<xsl:value-of disable-output-escaping="yes"
			select="concat('&lt;!DOCTYPE ', 'map', ' PUBLIC &quot;', 
			'-//OASIS//DTD DITA Map//EN', '&quot; &quot;',
			'../dtd/map.dtd', '&quot;&gt;')"/>
		<map>
			<xsl:attribute name="id">cgid-<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:apply-templates/>
		</map>
	</xsl:template>

	<xsl:template match="protomaptitle">
		<title><xsl:apply-templates/></title>
	</xsl:template>

	<xsl:template match="protomap/meta">
		<data type="meta"><xsl:apply-templates/></data>
	</xsl:template>

	<xsl:template match="protomap/script">
		<data type="script"><xsl:copy-of select="@*" /></data>
	</xsl:template>

	<xsl:template match="protomap/link">
		<data type="link"><xsl:apply-templates/></data>
	</xsl:template>

	<!-- metadata comment: multiple profiles could be provided here. expeDITA does not yet utilize topicmeta as standard functional content.-->
	<xsl:template match="protomapmeta"/>

	<xsl:template match="xprotomapmeta">
		<topicmeta>
			<!--navtitle>Secondary title for this document</navtitle-->
			<shortdesc>Abstract for this document</shortdesc>
			<author>Author of this document</author>
			<copyright>
				<copyryear year="2013-04-12"></copyryear>
				<copyrholder>Copyright holder for this document</copyrholder>
			</copyright>
			<xsl:comment>
			<xsl:for-each select="//meta">
				<othermeta><xsl:copy-of select="@*|node()"/></othermeta>
			</xsl:for-each>
			</xsl:comment>
		</topicmeta>
	</xsl:template>

	<xsl:template match="body/meta"/> <!-- gleaned this in the map's topicmeta -->


	<!-- Complex nesting in a source may indicate a heading used as a "big bold" rather than a true topic.
		Here we test some possible options by looking at the parent of topicref. This probably should be
		moved to an override location so new logic will be easier to upload into place. -->
	<xsl:template match="topicref">
	<xsl:choose>
		<xsl:when test="name(parent::node()) = 'topicref'">
			<xsl:call-template name="topicref"/>
		</xsl:when>
		<xsl:when test="name(parent::node()) = 'protomap'">
			<xsl:call-template name="topicref"/>
		</xsl:when>
		<xsl:when test="name(parent::node()) = 'prototopic'">
			<xsl:call-template name="topicref"/>
		</xsl:when>
		<xsl:otherwise>
			<!-- When the parent node is not logical, default to blurb style. Might provide options here. -->
			<!-- Lightweight DITA special structures or defaults could be handled here. -->
			<xsl:call-template name="blurb"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>

	<xsl:template name="blurb">
		<xsl:variable name="thistitle">
			<xsl:choose>
				<xsl:when test='prototopic/title'>
					<xsl:value-of select='prototopic/title'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select='@href'/><!-- was @id, but that's on the prototopic-->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<lq>
			<p><b><xsl:value-of select="normalize-space($thistitle)"/></b></p>
			<xsl:apply-templates select="prototopic/*[not(name()='title')]"/>
		</lq>
	</xsl:template>

	<xsl:template name="topicref">
		<xsl:variable name="namespace">c_</xsl:variable>
		<xsl:variable name="thistitle">
			<xsl:choose>
				<xsl:when test='prototopic/title'>
					<xsl:value-of select='prototopic/title'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select='@href'/><!-- was @id, but that's on the prototopic-->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="spacedash1"><xsl:value-of select="translate($thistitle,' - ','-')"/></xsl:variable>
		<xsl:variable name="spacedash"><xsl:value-of select="translate($spacedash1,' ','-')"/></xsl:variable>
		<xsl:variable name="topictitle"><xsl:value-of select="$namespace"/><xsl:value-of select="translate($spacedash, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:variable>
		<xsl:variable name="unfixtitle">
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="$thistitle" />
				<xsl:with-param name="replace" select="'TT'" />
				<xsl:with-param name="by" select="'T'" />
			</xsl:call-template>
		</xsl:variable>
		<topicref>
			<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
			<!-- some pretty-printed heading content gets to this point with excessive whitespace-->
			<xsl:attribute name="navtitle"><xsl:value-of select="normalize-space($thistitle)"/></xsl:attribute>
			<xsl:attribute name="type"><xsl:value-of select="$outproc"/></xsl:attribute>
			<xsl:apply-templates/>
		</topicref>
	</xsl:template>
	<!-- Note that proto topicref/@href normally DOES contain the .dita extension since it is a pre-formed full value.
		 However, the prototopic/@id does not because it is an id. However, that id value conflates to the name part of the filename 
		 (ie, we need to add '.dita' when using @id as part of any filename in these transforms).
	-->
	
	<!-- reconstruct individual DITA topic nodes -->
	
	<xsl:template match="prototopic">
		<!-- generate result sets here -->
		<!-- http://www.ibm.com/developerworks/xml/library/x-tipmultxsl/index.html -->
		<!-- xslt 2.0: xsl:result-document href="{@id}.dita" format="xml"-->
		<!-- for PHP's libxslt, use exsl extension: http://www.exslt.org/exsl/elements/document/index.html -->
		<xsl:variable name="namespace">c_</xsl:variable>
		<xsl:variable name="thistitle">
			<xsl:choose>
				<xsl:when test='title'>
					<xsl:value-of select='title'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select='@id'/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="spacedash1"><xsl:value-of select="translate($thistitle,' - ','-')"/></xsl:variable>
		<xsl:variable name="spacedash"><xsl:value-of select="translate($spacedash1,' ','-')"/></xsl:variable>
		<xsl:variable name="del">"':;,.?</xsl:variable> 
		<xsl:variable name="badchars"><xsl:value-of select="translate($spacedash,$del,'')"/></xsl:variable>
		<xsl:variable name="topictitle"><xsl:value-of select="$namespace"/><xsl:value-of select="translate($badchars, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:variable>
<!--xsl:message>quodlibet<xsl:value-of select="concat($targPath,'/',@id,'.dita')" /></xsl:message-->
		<xsl:choose>
			<xsl:when test='$outproc = "test"'>
				<xsl:call-template name="chunkTopic"/>
			</xsl:when>
			<xsl:when test='$outproc = "topic"'>
				 <!-- apply lightweight DITA topic doctype here; apply only targpath here as this is the object of path write operation, not a url. -->
				 <!-- Application note for exsl: 
				 	"The href attribute specifies where the subsidiary document should be stored; it must be an *absolute* or *relative* URI;.."
				 	(in http://exslt.org/exsl/elements/document/)
				 	We are using absolute so that nested chunks can stay in a flat result folder structure. (no "STAGE/path/STAGE/path/file.dita" issues)
				 -->
		    	<exsl:document 
					href="{$outputpath}/{@id}.dita" 
					doctype-public = "-//OASIS//DTD DITA Topic//EN"
					doctype-system = "../dtd/topic.dtd"
					method="xml">
					<xsl:call-template name="chunkTopic"/>
				</exsl:document>
			</xsl:when>
			<xsl:when test='$outproc = "task"'>
			</xsl:when>
			<xsl:when test='$outproc = "reference"'>
			</xsl:when>
			<xsl:otherwise>
		    	<exsl:document 
					href="{$outputpath}/{@id}.dita" 
					doctype-public = "-//OASIS//DTD DITA Concept//EN"
					doctype-system = "../dtd/concept.dtd"
					method="xml">
					<xsl:call-template name="chunkConcept"/>
				</exsl:document>
			</xsl:otherwise>
		</xsl:choose>
	    <xsl:apply-templates select="topicref"/>
	</xsl:template>

	<xsl:template match="prototopic/title" mode="stitch">
		<!-- selectively replace any "TT" title deduplication strings with original character -->
		<xsl:variable name="thistitle">
		<xsl:choose>
			<xsl:when test='.'>
				<xsl:value-of select='.'/> <!-- get any text in this node -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select='@id'/>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<xsl:variable name="unfixtitle">
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="$thistitle" />
				<xsl:with-param name="replace" select="'TT'" />
				<xsl:with-param name="by" select="'T'" />
			</xsl:call-template>
		</xsl:variable>
  		<title><xsl:value-of select='$unfixtitle'/></title>
	</xsl:template>

	<xsl:template match="prototopic/title"/>
	
	<xsl:template name="chunkTopic">
		<topic>
			<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="title" mode="stitch"/>
			<xsl:apply-templates select="meta" mode="stitch"/>
			<body>
    			<xsl:apply-templates select="node()[not(name() = 'topicref')]"/>
			</body>
		</topic>
	</xsl:template>
	
	<xsl:template name="chunkConcept">
		<concept>
			<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="title" mode="stitch"/>
			<xsl:apply-templates select="meta" mode="stitch"/>
			<conbody>
    			<xsl:apply-templates select="node()[not(name() = 'topicref')]"/>
			</conbody>
		</concept>
	</xsl:template>



	<xsl:template match="required-cleanup">
		<required-cleanup>
			<xsl:apply-templates/>
		</required-cleanup>
	</xsl:template>


	<xsl:template match='blockquote'>
		<lq>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
            <xsl:apply-templates/>
		</lq>
	</xsl:template>

	<xsl:template match='div'>
		<section>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test="@class"><xsl:attribute name="outputclass"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
			<title><xsl:value-of select="ancestor::prototopic/title"/></title>
			<xsl:apply-templates/>
		</section>
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
	
	<xsl:template match='image'>
		<xsl:variable name="hrefval"><xsl:value-of select="@href"/></xsl:variable>
		<!-- use $hrefval to copy the resource into the targ_path image folder -->
		<image href="{$fullpath}{$hrefval}" outputclass="use-image">
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
	<!-- /highlighting -->

	<xsl:template match='code'>
		<codeph><xsl:apply-templates/></codeph>
	</xsl:template>

	<xsl:template match='hr'>
		<xsl:comment>horizontal rule</xsl:comment>
	</xsl:template>

	<xsl:template match='br'>
		<xsl:comment>line break</xsl:comment>
	</xsl:template>

	<xsl:template match='form'>
		<xsl:comment><xsl:copy-of select='.'/></xsl:comment>
	</xsl:template>




	<xsl:template match='p[. = ""]'>
		<xsl:apply-templates/>
	</xsl:template><!-- Don't wrap empty paragraphs but do process content (not always the correct choice) -->

	<xsl:template match='p'>
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
	
	<xsl:template match='span[@class="phrase"]'>
		<ph>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ph>
	</xsl:template>
	
	<xsl:template match='span[@class="paragraph"]'>
		<p>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	<xsl:template match='span[@class="term"]'>
		<ph>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ph>
	</xsl:template>

	<xsl:template match='style'/>
	
	<xsl:template match='br'/>


	<xsl:template match='span'>
		<ph outputclass="span"><xsl:apply-templates/></ph>
	</xsl:template>






	<xsl:template match='table' mode="simpletable">
		<!--
		<xsl:if test='@id'>
			<xsl:attribute name='id'><xsl:value-of select='@id'/></xsl:attribute>
		</xsl:if>
		<xsl:if test='p[@class="desc"]'>
			<xsl:attribute name='summary'><xsl:value-of select='p[@class="desc"]'/></xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select='p[@class = "caption"]' mode='once'/>
		-->
		<simpletable>
			<xsl:if test="parent::*[@id]"><xsl:attribute name="id"><xsl:value-of select="parent::*/@id"/></xsl:attribute></xsl:if>
			<xsl:if test='parent::*[@relcolwidth]'>
				<xsl:attribute name='relcolwidth'><xsl:value-of select='parent::*/@relcolwidth'/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</simpletable>
	</xsl:template>

	<xsl:template match="p[@class = 'desc']">
	</xsl:template>
	
	<xsl:template match='p[@class = "caption"]' mode='once'>
		<title><xsl:apply-templates/></title>
	</xsl:template>
	
	<xsl:template match='tbody'>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match='thead'>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match='tr[th]'>
		<sthead>
			<xsl:for-each select="th">
				<stentry>
					<xsl:apply-templates/>
				</stentry>
			</xsl:for-each>
		</sthead>
	</xsl:template>
	
	<xsl:template match='tr[td]'>
		<strow>
			<xsl:for-each select="td">
				<stentry>
					<xsl:apply-templates/>
				</stentry>
			</xsl:for-each>
		</strow>
	</xsl:template>

<!-- convert HTML table to DITA (OASIS Table Exchange) table model -->

	<xsl:template match='table'>
		<table>
			<xsl:if test='@border = "1"'>
				<xsl:attribute name='frame'>all</xsl:attribute>
			</xsl:if>
			<xsl:if test='@name'>
				<xsl:attribute name='id'><xsl:value-of select='@name'/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select='caption' mode='once'/>
			<xsl:variable name="numcols">
				<xsl:value-of select="count(tr[1]/td)"/>
			</xsl:variable>
			<tgroup>
				<xsl:attribute name="cols">
					<xsl:value-of select="$numcols"/>
				</xsl:attribute>
				<!-- multiple colspecs here -->
				<xsl:for-each select="tr[1]/td">
					<xsl:variable name="colnum"><xsl:number/></xsl:variable>
					<colspec colname="COLSPEC{$colnum}" colwidth="1*"/>
				</xsl:for-each>
				<!-- if present, tfoot gets moved to last row in tbody -->
				<xsl:if test='tfoot'>
					<xsl:comment> a tfoot was here </xsl:comment>
				</xsl:if>
				<!-- thead here -->
				<thead>
					<xsl:apply-templates select="tr[1]" mode="htable"/>
				</thead>
				<!-- tbody here -->
				<tbody>
					<xsl:apply-templates select="tr[position()!=1]" mode="htable"/>
					<!--
					<xsl:apply-templates select="tbody" mode="htable"/>
					<xsl:apply-templates select="tfoot" mode="htable"/>
					-->
				</tbody>
			</tgroup>
		</table>
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
				<entry outputclass="th">
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


<!-- case of CALS table coming from previous DITA topic -->

	<xsl:template match="div[@class = 'table']">
		<!-- for now, throw away attributes stored from original table import; in outputting to simpletable, these have no home-->
		<xsl:apply-templates mode='table'/>
	</xsl:template>

	<xsl:template match='table' mode='table'>
		<table>
			<xsl:if test='@frame'><!-- if converting from HTML table to simpletable, this would be implicit, thus unnecessary-->
				<xsl:attribute name='outputclass'>frame_<xsl:value-of select='@frame'/></xsl:attribute>
			</xsl:if>
			<xsl:if test='@id'>
				<xsl:attribute name='id'><xsl:value-of select='@id'/></xsl:attribute>
			</xsl:if>
			<xsl:if test='p[@class="desc"]'>
				<xsl:attribute name='summary'><xsl:value-of select='p[@class="desc"]'/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select='caption' mode='once'/>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
		
	<xsl:template match='caption' mode='once'>
		<title><xsl:apply-templates/></title>
	</xsl:template>

	<xsl:template match='tbody'>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match='thead'>
		<xsl:apply-templates/>
	</xsl:template>

	
	<xsl:template match='tr[th]'>
		<sthead>
			<xsl:for-each select="th">
				<stentry>
					<xsl:apply-templates/>
				</stentry>
			</xsl:for-each>
		</sthead>
	</xsl:template>
	
	<xsl:template match='tr[td]'>
		<strow>
			<xsl:for-each select="td">
				<stentry>
					<xsl:apply-templates/>
				</stentry>
			</xsl:for-each>
		</strow>
	</xsl:template>


	<!-- =================== Other ==================== -->

<!-- Catch any other nodes not normally transformed above -->
	<xsl:template match="*">
		<xsl:comment>Unmatched mid2dita '<xsl:value-of select="name(parent::node())"/>/<xsl:value-of select="name(.)"/>'</xsl:comment>
		<required-cleanup class="{name(.)}">
			<xsl:copy-of select="."/>
		</required-cleanup>
	</xsl:template>
	


	<xsl:template match='article'>
		<!--xsl:param name="infotype"><xsl:value-of select="//h1[1]/@class"/></xsl:param-->
		<xsl:param name="infotype"><xsl:value-of select="//article[1]/@class"/></xsl:param>
		<xsl:choose>
	        	<xsl:when test="$infotype='concept'">
				<concept>
					<xsl:if test='//h1[@lang]'>
						<xsl:attribute name='xml:lang'><xsl:value-of select="//h1/@lang"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="//h1[@id]">
						<xsl:attribute name="id"><xsl:value-of select="//h1/@id"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="//h1[@class]" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'shortdesc']" mode="once"/>
			
					<conbody>
						<!--[rest of the converted content]-->
						<xsl:apply-templates/>
					</conbody>
				</concept>
		        </xsl:when>
		        <xsl:when test="$infotype='task'">
				<task>
					<xsl:if test='//h1[@lang]'>
						<xsl:attribute name='xml:lang'><xsl:value-of select="//h1/@lang"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="//h1[@id]">
						<xsl:attribute name="id"><xsl:value-of select="//h1/@id"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="//h1[@class]" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'shortdesc']" mode="once"/>
			
					<taskbody>
						<!--[rest of the converted content]-->
						<xsl:apply-templates/>
					</taskbody>
				</task>
		        </xsl:when>
		        <xsl:when test="$infotype='reference'">
				<reference>
					<xsl:if test='//h1[@lang]'>
						<xsl:attribute name='xml:lang'><xsl:value-of select="//h1/@lang"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="//h1[@id]">
						<xsl:attribute name="id"><xsl:value-of select="//h1/@id"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="//h1[@class]" mode="once"/>
					<xsl:apply-templates select="//p[@class = 'shortdesc']" mode="once"/>
			
					<refbody>
						<!--[rest of the converted content]-->
						<xsl:apply-templates/>
					</refbody>
				</reference>
		        </xsl:when>
		        <xsl:when test="$infotype='topic'">
				<topic>
					<xsl:if test='//h1[@lang]'>
						<xsl:attribute name='xml:lang'><xsl:value-of select="//h1/@lang"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="//h1[@id]">
						<xsl:attribute name="id"><xsl:value-of select="//h1/@id"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="//h1[@class]" mode="once"/>
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
						<xsl:apply-templates select="//p[1]" mode="once"/>
						<body>
							<!--[rest of the converted content]-->
							<xsl:apply-templates/>
						</body>
		        	</topic>
	        	</xsl:otherwise>
	    	</xsl:choose>
	</xsl:template>
	
	
	<!-- http://geekswithblogs.net/Erik/archive/2008/04/01/120915.aspx -->

<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



	<!-- ================== START SHORTTAG SPECIALS ====================== -->
	
	<xsl:template match="li/processing-instruction('thisisnotreal')">
	<li>
		<xsl:variable name="thistitle">
		<xsl:choose>
			<xsl:when test='.'>
				<xsl:value-of select='.'/><!-- get any text in this node -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select='@id'/>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<xsl:variable name="spacedash"><xsl:value-of select="translate($thistitle,' ','-')"/></xsl:variable>
		<xsl:variable name="del">"':;,.?</xsl:variable> 
		<xsl:variable name="badchars"><xsl:value-of select="translate($spacedash,$del,'')"/></xsl:variable>
		<xsl:variable name="topictitle"><xsl:value-of select="$namespace"/><xsl:value-of select="translate($badchars, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:variable>
		<draft-comment>
			<xsl:value-of select="$topictitle"/>
		</draft-comment>
		</li>
	</xsl:template>
	
	
	<xsl:template match="processing-instruction('CCI:')">
		<xsl:variable name="picontent"><xsl:value-of select='substring(., 1, string-length(.)-1)'/></xsl:variable>
		<note audience="instructor"><xsl:value-of select="$picontent"/></note>
	</xsl:template>
	
	<xsl:template match="processing-instruction('Lab:')">
		<xsl:variable name="picontent"><xsl:value-of select='substring(., 1, string-length(.)-1)'/></xsl:variable>
		<p outputclass="lab"><xsl:value-of select="$picontent"/></p>
	</xsl:template>
	
	<xsl:template match="processing-instruction('Note:')">
		<xsl:variable name="picontent"><xsl:value-of select='substring(., 1, string-length(.)-1)'/></xsl:variable>
		<note><xsl:value-of select="$picontent"/></note>
	</xsl:template>
	
	<xsl:template match="processing-instruction('Caution:')">
		<xsl:variable name="picontent"><xsl:value-of select='substring(., 1, string-length(.)-1)'/></xsl:variable>
		<note type="caution"><xsl:value-of select="$picontent"/></note>
	</xsl:template>
	
	<xsl:template match="processing-instruction('Tip:')">
		<xsl:variable name="picontent"><xsl:value-of select='substring(., 1, string-length(.)-1)'/></xsl:variable>
		<note type="tip"><xsl:value-of select="$picontent"/></note>
	</xsl:template>
	
	<xsl:template match="processing-instruction('image:')">
		<xsl:variable name="picontent"><xsl:value-of select='substring(., 1, string-length(.)-1)'/></xsl:variable>
		<!-- ideally need to do extension checking here -->
		<draft-comment>
			<xsl:value-of select='$picontent'/>
		</draft-comment>
	</xsl:template>
	
	<xsl:template match="processing-instruction('spaces:')">
		<xsl:variable name="raw"><xsl:value-of select="."/></xsl:variable>
		<xsl:variable name="picontent"><xsl:value-of select='substring($raw, 1, string-length($raw)-1)'/></xsl:variable>
		<xsl:variable name="offset"><xsl:value-of select='number($picontent)'/></xsl:variable>
		<xsl:variable name="space"></xsl:variable>
		<!--xsl:value-of select="substring($space, 1,$offset)"/-->
		<xsl:call-template name="repeat">
			<xsl:with-param name="output"> </xsl:with-param><!-- &#160; for nbsp char -->
			<xsl:with-param name="count"><xsl:value-of select="$offset"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- remove p parent around generated shortcode element -->
	<xsl:template match="p[shortcode]">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- this might work better than the PI hack -->
	<xsl:template match="shortcode">
		<xsl:variable name="pitag"><xsl:value-of select="substring-before(text(), ' ')" /></xsl:variable>
		<xsl:variable name="textnode1"><xsl:value-of select="substring-after(text(), ' ')" /></xsl:variable>
		<xsl:choose>
			<xsl:when test='$pitag = "CCI:"'>
				<note audience="instructor">
					<xsl:value-of select="$textnode1"/><xsl:apply-templates select="node()[position()>'1']"/>
				</note>
			</xsl:when>
			<xsl:when test='$pitag = "Lab:"'>
				<p outputclass="lab">
					<xsl:value-of select="$textnode1"/><xsl:apply-templates select="node()[position()>'1']"/>
				</p>
			</xsl:when>
			<xsl:when test='$pitag = "Note:"'>
				<note>
					<xsl:value-of select="$textnode1"/><xsl:apply-templates select="node()[position()>'1']"/>
				</note>
			</xsl:when>
			<xsl:when test='$pitag = "Caution:"'>
				<note type="caution">
					<xsl:value-of select="$textnode1"/><xsl:apply-templates select="node()[position()>'1']"/>
				</note>
			</xsl:when>
			<xsl:when test='$pitag = "Tip:"'>
				<note type="tip">
					<xsl:value-of select="$textnode1"/><xsl:apply-templates select="node()[position()>'1']"/>
				</note>
			</xsl:when>
			<xsl:when test='$pitag = "image:"'>
				<draft-comment>
					<xsl:value-of select="$textnode1"/><xsl:apply-templates select="node()[position()>'1']"/>
				</draft-comment>
			</xsl:when>
			<xsl:when test='$pitag = "spaces:"'>
				<xsl:variable name="picontent"><xsl:value-of select="node()[position()>'1']"/></xsl:variable>
				<xsl:variable name="offset"><xsl:value-of select='number($picontent)'/></xsl:variable>
				<xsl:call-template name="repeat">
					<xsl:with-param name="output"> </xsl:with-param><!-- &#160; for nbsp char -->
					<xsl:with-param name="count"><xsl:value-of select="$offset"/></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<note>
					<xsl:value-of select="$textnode1"/><xsl:apply-templates select="node()[position()>'1']"/>
				</note>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	

<xsl:template name="repeat">
  <xsl:param name="output" />
  <xsl:param name="count" />
  <xsl:value-of select="$output" />
  <xsl:if test="$count &gt; 1">
    <xsl:call-template name="repeat">
      <xsl:with-param name="output" select="$output" />
      <xsl:with-param name="count" select="$count - 1" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

	<!-- ================== END SHORTTAG SPECIALs ====================== -->


</xsl:stylesheet>