<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:output method="xml" indent="yes" encoding="utf-8"/>

<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," map/map ")]'>
	<xsl:processing-instruction name="xml-stylesheet">
	href="opml.xsl" type="text/xsl" version="1.0"
	</xsl:processing-instruction>
	<opml version="1.0">
		<head>
			<title>
				<xsl:value-of select="title"/>
				<xsl:value-of select="@title"/>
			</title> 
			<dateCreated />
			<ownerName /> 
		</head>
		<body>  
			<xsl:apply-templates/>
		</body>
	</opml>
</xsl:template>

<xsl:template match='*[contains(@class," topic/title ")]'/>

 <xsl:template match='*[contains(@class," map/topicref ")]'>
	<xsl:element name="outline">
		<xsl:attribute name="title" >
			<xsl:value-of select="@navtitle"/>
		</xsl:attribute>
		<xsl:attribute name="xmlUrl" >
			<xsl:value-of select="@href" />
		</xsl:attribute>
		<xsl:apply-templates/>
	</xsl:element>
 </xsl:template>      

 <xsl:template match="topichead">
	<xsl:element name="outline">
		<xsl:attribute name="title" >
			<xsl:value-of select="@navtitle"/>
		</xsl:attribute>
		<xsl:apply-templates/>
    </xsl:element>
 </xsl:template>      

</xsl:stylesheet>

