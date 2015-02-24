<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 >
 <xsl:output omit-xml-declaration="yes" indent="yes"/>
 <xsl:strip-space elements="*"/>

 <xsl:template match="node()|@*">
     <xsl:copy>
       <xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
 </xsl:template>
<!--

 <ns:PeelList>
 </ns:PeelList>
 
 <ns:WhiteList>
 </ns:WhiteList>

 <xsl:template match=
  "*[not(descendant-or-self::*[name()=document('')/*/ns:WhiteList/*])]">
  	<xsl:apply-templates/>
  </xsl:template>

 <xsl:template match=
  "*[descendant-or-self::*[name()=document('')/*/ns:PeelList/*]]">
  	<xsl:apply-templates/>
  </xsl:template>
-->
	<xsl:template match="br|head|meta"/>
	
	<xsl:template match="html|body|p|blockquote|pre">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="body/span">
		<p><xsl:apply-templates/></p>
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
	

</xsl:stylesheet>