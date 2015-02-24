<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method = "html" version = "4.0" encoding="ISO-8859-1" indent = "no" />
<xsl:strip-space elements = "*" />

<xsl:param name="contentFile" select="'blank'"/>


<xsl:template match = "/val" >
<html>
	<link rel="stylesheet" href="opml.css" />
	<h2>DITAval settings for props file: <xsl:value-of select="$contentFile"/></h2>
	<body>
		<table class="concise" ><!-- border="1" cellpadding="6" style="font-size:smaller;" -->
			<tr>
				<th>Rule</th> <th>Att</th> <th>Value</th> <th>Action</th> <th>Change<br/>Bar</th> <th>Effects</th>
			</tr>
			<xsl:apply-templates/>
		</table>
	</body>
</html>
</xsl:template>

<xsl:template match = "prop|revprop" >
<tr>
	<th><xsl:value-of select="name(.)"/></th>
	<td><xsl:value-of select="@att"/></td>
	<td><xsl:value-of select="@val"/></td>
	<td>
		<xsl:value-of select="@action"/>
		<xsl:choose>
			<xsl:when test='@action = "include"'>
				<span style="font-weight:bold;color:green"> &#x21e7;</span>
			</xsl:when>
			<xsl:when test='@action = "exclude"'>
				<span style="font-weight:bold;color:red"> &#x21e9;</span>
			</xsl:when>
			<xsl:when test='@action = "passthrough"'>
				<span style="font-weight:bold;color:black"> &#x21e8;</span>
			</xsl:when>
			<xsl:when test='@action = "flag"'>
				<span style="font-weight:bold;color:black">!</span>
			</xsl:when>
			<xsl:otherwise>
				<span></span>
			</xsl:otherwise>
		</xsl:choose>
	</td>
	<td style="text-align:center"><!-- case of @changebar on revprop -->
		<xsl:if test='@changebar'>
			<xsl:value-of select="@changebar"/>
		</xsl:if>
	</td>
	<td><!-- show the effects -->
		<xsl:for-each select="@*[contains('backcolor|style|color|changebar',name())]" >
			<b><xsl:value-of select="name()"/>: </b><xsl:value-of select="."/>
			<xsl:choose>
				<xsl:when test='name() = "backcolor"'>
					<span style="float:right;background-color:{.}">Sample text string.</span><br/>
				</xsl:when>
				<xsl:when test='name() = "style"'>
					<!--  values: underline|double-underline|italics|overline|bold -->
					<xsl:choose>
						<xsl:when test='. = "underline"'>
							<span style="float:right;text-decoration:underline;">Sample text string.</span><br/>
						</xsl:when>
						<xsl:when test='. = "double-underline"'>
							<span style="float:right;border-bottom: 3px double;">Sample text string.</span><br/>
						</xsl:when>
						<xsl:when test='. = "italics"'>
							<span style="float:right;font-style:italic;">Sample text string.</span><br/>
						</xsl:when>
						<xsl:when test='. = "overline"'>
							<span style="float:right;text-decoration:overline;">Sample text string.</span><br/>
						</xsl:when>
						<xsl:when test='. = "bold"'>
							<span style="float:right;font-weight:bold;">Sample text string.</span><br/>
						</xsl:when>
						<xsl:otherwise>
							<span style="float:right;">Unsupported style value.</span><br/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test='name() = "color"'>
					<span style="float:right;color:{.}">Sample text string.</span><br/>
				</xsl:when>
				<xsl:when test='name() = "changebar"'> <!-- specifically for revprops -->
					<span style="float:right;"><xsl:value-of select="."/> Sample text string.</span><br/>
				</xsl:when>
				<xsl:otherwise>
					<span  style="float:right;">Unsupported action.</span><br/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:apply-templates/>
	</td>
</tr>
</xsl:template>


<xsl:template match = "startflag|endflag" >
	<b><xsl:value-of select="name(.)"/>: </b><xsl:value-of select="@imageref"/><br/>
	<xsl:apply-templates/>
</xsl:template>


<xsl:template match = "alt-text" >
	<b>alt-text: </b>"<xsl:apply-templates/>"<br/>
</xsl:template>

<xsl:template match = "style-conflict" >
<tr>
	<th><xsl:value-of select="name(.)"/></th>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td>
	<xsl:if test='@foreground-conflict-color'>
		<b>foreground-conflict-color: </b><xsl:value-of select="@foreground-conflict-color"/><xsl:text> </xsl:text>
		<span style="float:right;border-style: solid;border-color:{@foreground-conflict-color}"> Sample text string.</span><br/>
	</xsl:if>
	<xsl:if test='@background-conflict-color'>
		<b>background-conflict-color: </b><xsl:value-of select="@background-conflict-color"/><xsl:text> </xsl:text>
		<span style="float:right;border-style: double;border-color:{@background-conflict-color}"> Sample text string.</span><br/>
	</xsl:if>
	</td>
</tr>
</xsl:template>

</xsl:stylesheet>