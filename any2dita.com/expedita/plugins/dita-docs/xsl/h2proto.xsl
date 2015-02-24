<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='1.0'
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

	<xsl:output method="xml"
            encoding="utf-8"
            indent="yes"
			standalone="no"
			omit-xml-declaration="yes"/>

	<xsl:strip-space elements="html head body div"/>

	<!-- strip whatever anonymous wrapper this content came in with (ostensibly body but does not matter; these are all import noise) -->
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="html">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="head">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="body">
		<xsl:apply-templates/>
	</xsl:template>

<!-- specifically to feed an available XHTML semantic through that validation path -->
	<xsl:template match='center'>
		<shortdesc>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
            <xsl:apply-templates/>
		</shortdesc>
	</xsl:template>

<!-- specifically to feed an available XHTML semantic through that validation path. Not idea. -->
	<xsl:template match='div'>
		<body>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
            <xsl:apply-templates/>
		</body>
	</xsl:template>

	<!-- this is specifically for Markdown Extra insertions. Full support is for another phase, not now. -->
	<xsl:template match='div[@markdown="1"]'>
		<section>
            <xsl:apply-templates/>
		</section>
	</xsl:template>

	
	<xsl:template match="*">
		<required-cleanup outputclass="{name()}"><xsl:apply-templates/></required-cleanup>
     </xsl:template>
	
	<!-- Remove rich-text attribution sometimes copied into the content inadvertently. -->
	<xsl:template match="span[@class = 'Apple-style-span']">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- Remove rich-text attribution sometimes copied into the content inadvertently. -->
	<xsl:template match="span[@class = 'Apple-style-span Apple-style-span']">
		<xsl:apply-templates/>
	</xsl:template>


	<xsl:template match="br"/>

	<xsl:template match="nobr"/>

	<xsl:template match="hr"/>
	
	<xsl:template match='h1 | h2 | h3 | h4 | h5 | h6'>
		<!-- convert invalid titles to bold paragraphs -->
		<p outputclass='{local-name()}'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<b><xsl:apply-templates/></b>
		</p>
	</xsl:template>
	
	<xsl:template match="font|size|color">
		<xsl:apply-templates/>
	</xsl:template>

<!-- straightforward normalizing towards DITA equivalents -->
	
	<xsl:template match="p">
		<p><xsl:apply-templates/></p>
	</xsl:template>
	
	<xsl:template match="center/p">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="title">
		<title><xsl:apply-templates/></title>
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

	<xsl:template match="blockquote[name(parent::*) = 'blockquote']">
		<note type="other" othertype="Faux blockquote">
			<xsl:apply-templates/>
		</note>
	</xsl:template>

	<xsl:template match='blockquote'>
		<lq>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</lq>
	</xsl:template>

	<xsl:template match='style'/>
	
	<xsl:template match='br'/>

	
	<!-- inline phrases often pick up trailing space that needs to be transferred outside. -->
	<xsl:template match="strong">
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<b><xsl:value-of select="normalize-space(.)"/></b>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>
	
	<xsl:template match="em">
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<i><xsl:value-of select="normalize-space(.)"/></i>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>
	
	<xsl:template match="u">
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<u><xsl:value-of select="normalize-space(.)"/></u>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>
	
	<xsl:template match="sup">
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<sup><xsl:value-of select="normalize-space(.)"/></sup>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>
	
	<xsl:template match="sub">
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<sub><xsl:value-of select="normalize-space(.)"/></sub>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>

	<xsl:template match='tt'>
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<tt><xsl:value-of select="normalize-space(.)"/></tt>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>

	<xsl:template match='del'>
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<ph outputclass='strikethrough'><xsl:value-of select="translate(.,' ','')"/></ph>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>

	<xsl:template match='xspan'>
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<ph><xsl:value-of select="translate(.,' ','')"/></ph>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>

	<xsl:template match='code'>
		<xsl:variable name="delta"><xsl:value-of select="string-length(.) - string-length(normalize-space(.))"/></xsl:variable>
		<codeph><xsl:value-of select="normalize-space(.)"/></codeph>
		<xsl:if test='$delta &gt; 0'>&#160;</xsl:if>
	</xsl:template>


	<xsl:template match='span'>
		<xsl:variable name="daddy" select="name(parent::*)"/>
		<xsl:choose>
			<!-- Now we can get rid of characters that occur in unwanted contexts. -->
			<xsl:when test=". = 'NBSP' and $daddy = 'p'"></xsl:when>
			<xsl:when test=". = 'CR' and $daddy = 'div'"></xsl:when>
			<xsl:when test=". = 'LF' and $daddy = 'div'"></xsl:when>
			<xsl:when test=". = 'CR' and $daddy = 'p'"></xsl:when>
			<xsl:when test=". = 'LF' and $daddy = 'p'"></xsl:when>
			<xsl:when test=". = 'CR' and $daddy = 'ul'"></xsl:when>
			<xsl:when test=". = 'LF' and $daddy = 'ul'"></xsl:when>
			<xsl:otherwise>
				<!--xsl:processing-instruction name="{.}"><xsl:value-of select="name(parent::*)"/></xsl:processing-instruction-->
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- dcm: temp experimental handling of img -->
	<xsl:template match="img">
		<image href="{@src}">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:if test='@width'><xsl:attribute name='width'><xsl:value-of select='@width'/></xsl:attribute></xsl:if>
			<xsl:if test='@height'><xsl:attribute name='height'><xsl:value-of select='@height'/></xsl:attribute></xsl:if>
			<xsl:if test='@align'><xsl:attribute name='align'><xsl:value-of select='@align'/></xsl:attribute></xsl:if>
				<xsl:if test='@alt'><alt><xsl:value-of select="@alt"/></alt></xsl:if>
		</image>
			<xsl:if test="@title"><draft-comment>Title: <xsl:value-of select="@title"/></draft-comment></xsl:if>
	</xsl:template>

<!-- manipulations -->
	
	<!-- This algorithm provides grouping for dd / dt pairs (one of each) -->
	<!-- http://stackoverflow.com/questions/2165566/xslt-select-following-sibling-until-reaching-a-specified-tag -->
	<xsl:template match="dl">
		<dl>
			<!-- assuming one term followed by one dd for now, hence use dt nodes as wrapper indicators -->
			<xsl:for-each select="dt">
				<dlentry>
					<dt><xsl:apply-templates/></dt>
					<!-- need to get each successive dd up to next non-dd node -->
					<xsl:apply-templates select="following-sibling::dd" mode="deep"/>
				</dlentry>
			</xsl:for-each>
		</dl>
	</xsl:template>
	
	<xsl:template match="dd" mode="deep">
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>
	
	<xsl:template match="dd | dt"></xsl:template>


	

<!-- case of HTML table generated in the Whizzywing editor -->

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


<!-- URL conversion logic: Note by Don Day
These templates do an extensive decomposition of URL components. 
The efficiency is probably not great but the design intent is to be thorouch and reliable for migration purposes. 

External references with http protocol are passed through as is (ie, <a href="http://example.com">).
However, relative external references won't necessarily have the base protocol and hostname passed in
(eg, <a href="/project/markdown/syntax">, which servers would concatenate onto a hostname and application folder).
These probably indicate "local" or "peer" relationships within a CMS and are passed through as such, and that URL 
will likely need cleanup to point to its presumeably migrated endpoint. Because this is happening in an editor
and not a migration tool, this use case should not blindly chase after presumed peer resources for automatic migration.

Ultimately, the mapping at the end needs to be to the path conventions of the CMS. expeDITA paths presume resolution within
a flat folder space, although imported folders are tolerated for Read operations (not for Update, Delete, or Create).
In practice, xrefs may not need @format and @scope since these can be inferred, but here we pass through what is known
because it is available anyway and may help in interchange to CMSs that require possibly redundant attribution.
-->

	<!-- Higher priority case of element with a non-null href (after precedence matching) -->
	<xsl:template match='a[@href]'>

		<xsl:variable name='hrefval'><xsl:value-of select='@href'/></xsl:variable>

		<!-- a series of chunks to normalize http-based hrefs -->
		<xsl:variable name='test1'><xsl:value-of select='substring($hrefval, 1, 4)'/></xsl:variable>

		<xsl:variable name="hostpathtarg">
			<xsl:choose>
				<xsl:when test='$test1 = "http"'><xsl:value-of select="substring-after($hrefval,'://')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$hrefval"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="hostname">
			<xsl:choose>
				<xsl:when test='$test1 = "http"'><xsl:value-of select="substring-before($hostpathtarg,'/')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$hrefval"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="pathtarg">
			<xsl:choose>
				<xsl:when test='$test1 = "http"'><xsl:value-of select="substring-after($hostpathtarg,'/')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$hostpathtarg"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="attrscope">
			<xsl:choose>
				<xsl:when test='$test1 = "http"'>external</xsl:when>
				<xsl:otherwise>peer</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- split any extant # fragment identifier from path segments -->
		<xsl:variable name="segments">
			<xsl:choose>
				<xsl:when test='contains($pathtarg,"#")'><xsl:value-of select="substring-before($pathtarg,'#')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$pathtarg"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fragpart">
			<xsl:choose>
				<xsl:when test='contains($pathtarg,"#")'><xsl:value-of select="substring-after($pathtarg,'#')"/></xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<!-- split segments into sitemap and endpoint -->
		<xsl:variable name="endpoint">
			<xsl:call-template name="GetLastSubstring">
				<xsl:with-param name="value" select="$segments" />
				<xsl:with-param name="separator" select="'/'" />
			</xsl:call-template>
		</xsl:variable>
		<!-- Note: an empty endpoint could mean "index.dita" rather than "{last_segment}.dita"; user must determine intent. -->
		
		<xsl:variable name="sitemap"><xsl:value-of select="substring-before($segments,concat('/',$endpoint))"/></xsl:variable>
		<!-- sitemap is the string of segments that represent RESTful categories or controllers; these segments will need
			to be migrated into CMS categories or possible literal folder names. expeDITA addressing presumes 
			"destined for current folder" and does not need to rationalize these values. They might mean something to a
			migration tool, however.
		-->

		<!-- split endpoint into filename and extension -->
		<xsl:variable name="extension">
			<xsl:choose>
				<xsl:when test='contains($endpoint,".")'>
					<xsl:call-template name="GetLastSubstring">
						<xsl:with-param name="value" select="$endpoint" />
						<xsl:with-param name="separator" select="'.'" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="filename">
			<xsl:choose>
				<xsl:when test='contains($endpoint,".")'><xsl:value-of select="substring-before($endpoint,concat('.',$extension))"/></xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Because we know the extension, we know something about the format. Normalize for use in format attribute. -->
		<!-- NOTE:  In a choose list, the first test that evaluates to true is instantiated and skips the rest of the list. -->
		<!-- Therefore put the most likely candidates first. -->
		<!-- Possible future issue: what if the referenced resource is DocBook or SPFE? All .xml are not the same. -->
		<xsl:variable name="attrformat">
			<xsl:choose>
				<xsl:when test="$attrscope='external' and $extension = ''">html</xsl:when>
				<xsl:when test="$attrscope='peer' and $extension = ''">dita</xsl:when>
				<xsl:when test="$extension='html'">html</xsl:when>
				<xsl:when test="$extension='pdf'">pdf</xsl:when>
				<xsl:when test="$extension='zip'">zip</xsl:when>
				<xsl:otherwise><xsl:value-of select="$extension"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	<!-- Use your own preferred way to evaluate to true to turn in inserting this development trace data.-->
	<xsl:if test="1=0"><xsl:text>
	</xsl:text><xsl:comment><xsl:text>
	</xsl:text>attrscope: <xsl:value-of select="$attrscope"/><xsl:text>
	</xsl:text>hostname: <xsl:value-of select="$hostname"/><xsl:text>
	</xsl:text>pathtarg: <xsl:value-of select="$pathtarg"/><xsl:text>
	</xsl:text>segments: <xsl:value-of select="$segments"/><xsl:text>
	</xsl:text>fragpart: <xsl:value-of select="$fragpart"/><xsl:text>
	</xsl:text>sitemap: <xsl:value-of select="$sitemap"/><xsl:text>
	</xsl:text>endpoint: <xsl:value-of select="$endpoint"/><xsl:text>
	</xsl:text>filename: <xsl:value-of select="$filename"/><xsl:text>
	</xsl:text>extension: <xsl:value-of select="$extension"/><xsl:text>
	</xsl:text>attrformat: <xsl:value-of select="$attrformat"/><xsl:text>
	</xsl:text></xsl:comment><xsl:text>
</xsl:text>
</xsl:if>

		<!-- Now we con convert this parsed data into a sensible DITA address space. 
			The CMS can provide new "sitemap" prefix strings as needed. expeDITA presumes
			"going into the current group folder".
		-->
		<xsl:variable name="resolvedhref">
			<xsl:choose>
				<xsl:when test="$attrscope = 'external'"><xsl:value-of select="@href"/></xsl:when>
				<xsl:when test="$attrscope='peer' and $extension = ''"><xsl:value-of select="$endpoint"/>.dita</xsl:when>
				<xsl:otherwise><xsl:value-of select="$pathtarg"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xref href="{$resolvedhref}">
			<xsl:if test="not($attrscope = '')">
				<xsl:attribute name="scope"><xsl:value-of select="$attrscope"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="not($attrformat = '')">
				<xsl:attribute name="format"><xsl:value-of select="$attrformat"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:if test='@type'>
				<xsl:attribute name='type'><xsl:value-of select='@type'/></xsl:attribute>
			</xsl:if>
			<!-- Now generate any linktext content. -->
			<xsl:apply-templates/>
			<!-- DITA xrefs lack a title semantic, but we won't throw that value away. For now left for auhor cleanup. -->
			<xsl:if test="@title"><b>[Title: <xsl:value-of select="@title"/>]</b></xsl:if>
		</xref>
	</xsl:template>

<!-- One possible xref test not integrated yet. This approach is just pseudocode for the issue.
	We already know if a URL is external, so this HTML semantic may not be needed.
	An application's output use case will really determine how a generated HTML hyperlink behaves.
	
<xsl:if test='@target'>
	<xsl:attribute name="scope">
		<xsl:choose>
			<xsl:when test='@target="_new"'>external</xsl:when>
			<xsl:when test='@target="_blank"'>external</xsl:when>
			<xsl:when test='@target = ""'>local</xsl:when>
			<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
		</xsl:choose>
	</xsl:attribute>
</xsl:if>
<xsl:apply-templates/>
-->


	<!-- A more-specific priority case of empty href, which cannot be a hyperlink. -->
	<xsl:template match='a[not(normalize-space(@href))]'>
		<ph>
			<xsl:apply-templates/>
			<xsl:if test="@title"><b>[Title: <xsl:value-of select="@title"/>]</b></xsl:if>
		</ph>
	</xsl:template>

	<!-- A more specific priority case of element without an href, which cannot be a hyperlink. -->
	<xsl:template match='a'>
		<ph>
			<xsl:apply-templates/>
			<xsl:if test="@title"><b>[Title: <xsl:value-of select="@title"/>]</b></xsl:if>
		</ph>
	</xsl:template>
	
	<!-- For URL parsing, some splits may occur at the end of a string of segments or periods. -->
	<!-- This tool may be used to parse any string based on a delimiter at a last location in the string. -->
	<xsl:template name="GetLastSubstring">
		<xsl:param name="value" />
		<xsl:param name="separator" select="'/'" />
		<xsl:choose>
			<xsl:when test="contains($value, $separator)">
				<xsl:call-template name="GetLastSubstring">
					<xsl:with-param name="value" select="substring-after($value, $separator)" />
					<xsl:with-param name="separator" select="$separator" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>