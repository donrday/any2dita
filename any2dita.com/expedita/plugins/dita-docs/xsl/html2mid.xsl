<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp '&#160;'> ]>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
 <xsl:output omit-xml-declaration="yes" indent="no" method="xml"/>
	<!-- From: http://stackoverflow.com/questions/9385981/xslt-remove-elements-and-or-attributes-by-name-per-xsl-parameters -->
	
	<!--
 <xsl:strip-space elements="*"/>
 	-->
	
	<xsl:param name="removeElementsNamed" select="'|null|'"/>
	<xsl:param name="removeAttributesNamed" select="'|style|'"/>
	
	<xsl:template match="node()|@*" name="identity">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:if test=
			"not(contains($removeElementsNamed,
			            concat('|', name(), '|')
			            )
		   )">
			<xsl:call-template name="identity"/>
		</xsl:if>
     </xsl:template>

     <xsl:template match="@*">
      <xsl:if test=
      "not(contains($removeAttributesNamed,
                    concat('|', name(), '|')
                    )
           )
       ">
       <xsl:call-template name="identity"/>
      </xsl:if>
	</xsl:template>

<!--

	<ns:PeelList>
	</ns:PeelList>
	<xsl:template match=
		"*[descendant-or-self::*[name()=document('')/*/ns:PeelList/*]]">
		<xsl:apply-templates/>
	</xsl:template>
-->

    
	
	<xsl:template match="br"/>
	<xsl:template match="hr"/>
	
	<!-- this construct seems to be a "cursor home" for Chrome contentEditable in Whizzywig11 -->
	<xsl:template match="div[span[br]]"/>
	
	<xsl:template match="strong">
		<b><xsl:apply-templates/></b>
	</xsl:template>
	
	<xsl:template match="em">
		<i><xsl:apply-templates/></i>
	</xsl:template>
	
	<xsl:template match="tt">
		<tt><xsl:apply-templates/></tt>
	</xsl:template>
	
	<xsl:template match="del|strike|strikethrough|s">
		<s><xsl:apply-templates/></s>
	</xsl:template>

	
	<xsl:template match="img">
		<image href="{@src}"/>
	</xsl:template>

 
	
	<xsl:template match="html">
		<protomap>
				<xsl:attribute name="id"><xsl:value-of select="@name"/>-proto</xsl:attribute>
			<xsl:apply-templates select="body/title" mode="maponly"/>
			<xsl:apply-templates/>
		</protomap>
	</xsl:template>
	
	<xsl:template match="head">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="meta">
		<meta><xsl:apply-templates/></meta>
	</xsl:template>
	
	<xsl:template match="head">
		<protomapmeta><xsl:apply-templates/></protomapmeta>
	</xsl:template>
	
	<xsl:template match="body">
		<xsl:comment>start body</xsl:comment>
		<xsl:apply-templates/>
		<xsl:comment>end body</xsl:comment>
	</xsl:template>
	
	<xsl:template match="div[@class='section']">
		<section><xsl:apply-templates/></section>
	</xsl:template>
	
	<xsl:template match="div[@class='section']/h2">
		<title><xsl:apply-templates/></title>
	</xsl:template>

	
	<!-- this construct is specically generated in Word to HTML macro for use here -->
	<xsl:template match="body/title" mode="maponly">
		<protomaptitle><xsl:apply-templates/></protomaptitle>
	</xsl:template>

	<xsl:template match="body/title"/>

	
	<xsl:template match="h1|h2|h3|h4">
		<title><xsl:apply-templates/></title>
	</xsl:template>


	<!-- Remove p within pre (depending on the source, this might insert unwanted CRLF!) -->
	<xsl:template match="pre/p"><xsl:apply-templates/><xsl:text>
</xsl:text></xsl:template>

	<!-- Remove tt within pre -->
	<xsl:template match="pre/p/tt"><xsl:apply-templates/></xsl:template>

	<!-- Just a test to try forcing respect for record ends in pre data; may not be needed after all. Doesn't hurt tho. -->
	<xsl:template match='pre'>
		<pre xml:space="preserve"><xsl:apply-templates/></pre>
	</xsl:template>

	<xsl:template match='center'>
		<xsl:apply-templates/>
	</xsl:template>


	
	<xsl:template match="xh2">
		  <section>
			<title><xsl:apply-templates/></title><!-- place the current node's heading value here as the first element in new group -->
		    <xsl:for-each 
		        select="following-sibling::node()[not(name(.) = 'h2')]"><!-- for each next node in the traverse that is not an <h2> -->
		        <xsl:apply-templates mode='in-h2-group'/>
		    </xsl:for-each>
		  </section>
	</xsl:template>
<!-- for each next node in the traverse that is not an <h2> -->
<!--
		<xsl:for-each select="node()[not(name(.) = 'h2')]">
		</xsl:for-each>
-->
	
	<xsl:template match="p" mode='in-h2-group'>
	<p><xsl:apply-templates/></p>
	</xsl:template>
	
	<xsl:template match="ul" mode='in-h2-group'>
	<ul><xsl:apply-templates mode='in-h2-group'/></ul>
	</xsl:template>
	
	<xsl:template match="li" mode='in-h2-group'>
	<li><xsl:apply-templates/></li>
	</xsl:template>
	
	<!-- "notch out" wiki-generated content: smw edit button -->
	<xsl:template match='span[@class="editsection"]'>
	</xsl:template>

	<!-- mediawiki specific artifact conversion -->
	<xsl:template match='bdi'>
		<span lang="{@lang}"><xsl:apply-templates/></span>
	</xsl:template>

	<!-- mediawiki specific artifact removal -->
	<xsl:template match='span[@class="mw-headline"]'>
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- mediawiki specific "3 columns" removal -->
	<xsl:template match='div[@style="float: left; width: 33%;"]'>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- get rid of toc table (reflected already in the map -->
	<xsl:template match='table[@id = "toc"]'>
	</xsl:template>
	<!-- get rid of thumnail image links in nested divs (no DITA equivalence) -->
	<xsl:template match='div[@class="thumb tright"]'>
	</xsl:template>

	
	<xsl:template match="p[child::b[. = 'Note:']]">
	<!--<p><b>Note:</b> -->
	<note>
		<!-- select all nodes whose names are not 'b' (this could toss useful info; watch before and after on real data) -->
		<xsl:apply-templates select="node()[not(name() = 'b')]"/>
	</note> 
	</xsl:template>
	
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


</xsl:stylesheet