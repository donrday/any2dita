<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--
|
| XSLT April 1999 WD Compliant Version of IE5 Default Stylesheet
|
| Original version by Jonathan Marsh (jmarsh@xxxxxxxxxxxxx)
| http://msdn.microsoft.com/xml/samples/defaultss/defaultss.xsl
|
+-->

<!-- include common templates -->

<!-- XHTML output with XML syntax -->
<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
/>

<xsl:template match="/">
  <HTML>
    <HEAD>
      <STYLE>
        BODY {font:x-small 'Verdana'; margin-right:1.5em}
      <!-- container for expanding/collapsing content -->
        .c  {cursor:hand}
      <!-- button - contains +/-/nbsp -->
        .b  {color:red; font-family:'Courier New'; font-weight:bold;
text-decoration:none}
      <!-- element container -->
        .e  {margin-left:1em; text-indent:-1em; margin-right:1em}
      <!-- comment or cdata -->
        .k  {margin-left:1em; text-indent:-1em; margin-right:1em}
      <!-- tag -->
        .t  {color:#990000}
      <!-- tag in xsl namespace -->
        .xt {color:#990099}
      <!-- attribute in xml or xmlns namespace -->
        .ns {color:red}
      <!-- attribute in dt namespace -->
        .dt {color:green}
      <!-- markup characters -->
        .m  {color:blue}
      <!-- text node -->
        .tx {font-weight:bold}
      <!-- multi-line (block) cdata -->
        .db {text-indent:0px; margin-left:1em; margin-top:0px;
margin-bottom:0px;
             padding-left:.3em; border-left:1px solid #CCCCCC; font:small
Courier}
      <!-- single-line (inline) cdata -->
        .di {font:small Courier}
      <!-- DOCTYPE declaration -->
        .d  {color:blue}
      <!-- pi -->
        .pi {color:blue}
      <!-- multi-line (block) comment -->
        .cb {text-indent:0px; margin-left:1em; margin-top:0px;
margin-bottom:0px;
             padding-left:.3em; font:small Courier; color:#888888}
      <!-- single-line (inline) comment -->
        .ci {font:small Courier; color:#888888}
        PRE {margin:0px; display:inline}
      </STYLE>
    </HEAD>

    <BODY class="st"><xsl:apply-templates/></BODY>

  </HTML>
</xsl:template>

<!-- Template for pis not handled elsewhere -->
<xsl:template match="processing-instruction()">
  <DIV class="e">
  <SPAN class="b"><xsl:text> </xsl:text></SPAN>
  <SPAN class="m">&lt;?</SPAN><SPAN class="pi"><xsl:value-of
select="name(.)"/> <xsl:value-of select="."/></SPAN><SPAN
class="m">?&gt;</SPAN>
  </DIV>
</xsl:template>

<!-- Template for the XML declaration.  Need a separate template because the
pseudo-attributes
    are actually exposed as attributes instead of just element content, as
in other pis -->
<xsl:template match="processing-instruction()">
  <DIV class="e">
  <SPAN class="b"><xsl:text> </xsl:text></SPAN>
  <SPAN class="m">&lt;?</SPAN><SPAN class="pi">xml <xsl:for-each
select="@*"><xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"
</xsl:for-each></SPAN><SPAN class="m">?&gt;</SPAN>
  </DIV>
</xsl:template>

<!-- Template for attributes not handled elsewhere -->
<xsl:template match="@*" xml:space="preserve"><SPAN><xsl:attribute
name="class"><xsl:if test="*/@*">x</xsl:if>t</xsl:attribute>
<xsl:value-of select="name(.)"/></SPAN><SPAN
class="m">="</SPAN><B><xsl:value-of select="."/></B><SPAN
class="m">"</SPAN></xsl:template>

<!-- Template for attributes in the xmlns or xml namespace -->
<!--xsl:template match="@xmlns:*|@xmlns|@xml:*"><SPAN class="ns"> <xsl:value-of
select="name(.)"/></SPAN><SPAN class="m">="</SPAN><B
class="ns"><xsl:value-of select="."/></B><SPAN
class="m">"</SPAN></xsl:template-->


<!-- Template for text nodes -->
<xsl:template match="text()">
  <DIV class="e">
  <SPAN class="b"><xsl:text> </xsl:text></SPAN>
  <SPAN class="tx"><xsl:value-of select="."/></SPAN>
  </DIV>
</xsl:template>

<!-- Template for comment nodes -->
<xsl:template match="comment()">
  <DIV class="k">
  <SPAN> <SPAN class="m">&lt;!--</SPAN></SPAN>
  <SPAN id="clean" class="ci"><PRE><xsl:value-of select="."/></PRE></SPAN>
  <SPAN class="b"><xsl:text> </xsl:text></SPAN> <SPAN
class="m">--&gt;</SPAN>
  </DIV>
</xsl:template>

<!-- Template for cdata nodes
<xsl:template match="cdata()">
  <DIV class="k">
  <SPAN> <SPAN class="m">&lt;![CDATA[</SPAN></SPAN>
  <SPAN id="clean" class="di"><PRE><xsl:value-of select="."/></PRE></SPAN>
  <SPAN class="b"><xsl:text> </xsl:text></SPAN> <SPAN
class="m">]]&gt;</SPAN>
  </DIV>
</xsl:template>
-->

<!-- Template for elements not handled elsewhere (leaf nodes) " -->
<xsl:template match="*">
  <DIV class="e"><DIV STYLE="margin-left:1em;text-indent:-2em">
  <SPAN class="b"><xsl:text> </xsl:text></SPAN>
  <SPAN class="m">&lt;</SPAN><SPAN><xsl:attribute name="class"><xsl:if
test="*">x</xsl:if>t</xsl:attribute><xsl:value-of
select="name(.)"/></SPAN> <xsl:apply-templates select="@*"/><SPAN
class="m"> /&gt;</SPAN>
  </DIV></DIV>
</xsl:template>

<!-- Template for elements with comment, pi and/or cdata children -->
<xsl:template match="*[node()]">
  <DIV class="e">
  <DIV class="c"> <SPAN class="m">&lt;</SPAN><SPAN><xsl:attribute
name="class"><xsl:if test="*">x</xsl:if>t</xsl:attribute><xsl:value-of
select="name(.)"/></SPAN><xsl:apply-templates select="@*"/> <SPAN
class="m">&gt;</SPAN></DIV>
  <DIV><xsl:apply-templates/>
  <DIV><SPAN class="b"><xsl:text> </xsl:text></SPAN> <SPAN
class="m">&lt;/</SPAN><SPAN><xsl:attribute name="class"><xsl:if
test="*">x</xsl:if>t</xsl:attribute><xsl:value-of
select="name(.)"/></SPAN><SPAN class="m">&gt;</SPAN></DIV>
  </DIV></DIV>
</xsl:template>

<!-- Template for elements with only text children -->
<xsl:template match="*[text() and not (comment() or processing-instruction())]">
  <DIV class="e"><DIV STYLE="margin-left:1em;text-indent:-2em">
  <SPAN class="b"><xsl:text> </xsl:text></SPAN> <SPAN
class="m">&lt;</SPAN><SPAN><xsl:attribute name="class"><xsl:if
test="*">x</xsl:if>t</xsl:attribute><xsl:value-of
select="name(.)"/></SPAN><xsl:apply-templates select="@*"/>
  <SPAN class="m">&gt;</SPAN><SPAN class="tx"><xsl:value-of
select="."/></SPAN><SPAN class="m">&lt;/</SPAN><SPAN><xsl:attribute
name="class"><xsl:if test="*">x</xsl:if>t</xsl:attribute><xsl:value-of
select="name(.)"/></SPAN><SPAN class="m">&gt;</SPAN>
  </DIV></DIV>
</xsl:template>

<!-- Template for elements with element children -->
<xsl:template match="*[*]">
  <DIV class="e">
  <DIV class="c" STYLE="margin-left:1em;text-indent:-2em"> <SPAN
class="m">&lt;</SPAN><SPAN><xsl:attribute name="class"><xsl:if
test="*">x</xsl:if>t</xsl:attribute><xsl:value-of
select="name(.)"/></SPAN><xsl:apply-templates select="@*"/> <SPAN
class="m">&gt;</SPAN></DIV>
  <DIV><xsl:apply-templates/>
  <DIV><SPAN class="b"><xsl:text> </xsl:text></SPAN> <SPAN
class="m">&lt;/</SPAN><SPAN><xsl:attribute name="class"><xsl:if
test="*">x</xsl:if>t</xsl:attribute><xsl:value-of
select="name(.)"/></SPAN><SPAN class="m">&gt;</SPAN></DIV>
  </DIV></DIV>
</xsl:template>

</xsl:stylesheet>
