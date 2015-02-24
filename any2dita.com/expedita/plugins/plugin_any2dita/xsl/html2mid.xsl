<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
 <xsl:output omit-xml-declaration="yes" indent="yes" method="xml"/>
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
		<s><xsl:apply-templates/></s>
	</xsl:template>

	
	<xsl:template match="img">
		<xsl:variable name="hrefval"><xsl:value-of select="@src"/></xsl:variable>
		<!-- use $hrefval to copy the resource into the targ_path image folder -->
		<image href="{$hrefval}"/>
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


	<!-- Remove p within pre -->
	<xsl:template match="pre/p"><xsl:apply-templates/><xsl:text>
</xsl:text></xsl:template>

	<!-- Remove tt within pre -->
	<xsl:template match="pre/p/tt"><xsl:apply-templates/></xsl:template>

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
	
	
	


</xsl:stylesheet>