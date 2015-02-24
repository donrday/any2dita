<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
 <xsl:output omit-xml-declaration="yes" indent="yes"/>
	<!-- From: http://stackoverflow.com/questions/9385981/xslt-remove-elements-and-or-attributes-by-name-per-xsl-parameters -->
 <xsl:strip-space elements="*"/>
	
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

    
	<xsl:template match="br|head|meta"/>
	
	<xsl:template match="html|body">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="body/span">
		<p><xsl:apply-templates/></p>
	</xsl:template>
	
	<xsl:template match="p[/p]"><!-- unwrap any scoping p tags (this should take out the parent) -->
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- simply remove span; it generally has only styling semantics in contentEditable -->
	<xsl:template match="span"><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="br"/>
	
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
		<ph><xsl:apply-templates/></ph>
	</xsl:template>
	
	<xsl:template match="blockquote">
	<lq><xsl:apply-templates/></lq>
	</xsl:template>

	
	<xsl:template match="img">
		<image href="{@src}">
		 	<xsl:if test="@class"><xsl:attribute name='class'><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
		 	<alt><xsl:value-of select="@alt"/></alt>
		</image>
	</xsl:template>
	
	<xsl:template match="a">
		<xref href="{@href}">
		 	<xsl:if test="@title">
		 		<xsl:comment name='navtitle'><xsl:value-of select="@title"/></xsl:comment>
		 	</xsl:if>
		 	<xsl:apply-templates/>
		</xref>
	</xsl:template>
 
 
<!-- 	
	<xsl:template match="h1">
		<title><xsl:apply-templates/></title>
	</xsl:template>
 	
	<xsl:template match="h2">
		<title><xsl:apply-templates/></title>
	</xsl:template>

	<xsl:template match="h3">
		<title><xsl:apply-templates/></title>
	</xsl:template>
	
	<xsl:template match="h4">
		<title><xsl:apply-templates/></title>
	</xsl:template>
	
	<xsl:template match="h5">
		<title><xsl:apply-templates/></title>
	</xsl:template>
-->
	
	<xsl:template match="div[@class='section']">
		<section><xsl:apply-templates/></section>
	</xsl:template>
	
	<xsl:template match="div[@class='section']/h2">
		<title><xsl:apply-templates/></title>
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


	<xsl:template match='table'>
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


</xsl:stylesheet>