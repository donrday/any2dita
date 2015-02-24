 <xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

 <xsl:template match="/">
 	<xsl:apply-templates select="map" />
 </xsl:template>
 
 <xsl:template match="map">
 	<map version="0.8.0">
 		<node ID="_" TEXT="map imported from any2dita/txt2map">
 		<xsl:apply-templates />
 		</node>
 	</map>
 </xsl:template>
 
 <xsl:template match="title">
 		<node ID="_" TEXT="{.}">
 		</node>
 </xsl:template>
 
 <xsl:template match="topicref">
 	<node CREATED="0" MODIFIED="0">
 		<xsl:attribute name="TEXT">
 			<xsl:value-of select="@navtitle" />
 		</xsl:attribute>
 		<xsl:if test="@href != ''">
 			<xsl:attribute name="LINK">
 				<xsl:value-of select="@href" />			
 			</xsl:attribute>
 		</xsl:if>
 		<xsl:attribute name="ID">D2M_<xsl:value-of select="@id" /></xsl:attribute>
 		<xsl:apply-templates select="standardflag" />		
 		<xsl:apply-templates select="topicref" />
 	</node><xsl:text>
 </xsl:text>
 </xsl:template>
 
 <xsl:template match="standardflag">
 	<xsl:choose>
 		<xsl:when test=". = 'lifebelt'"><icon BUILTIN="flag"/></xsl:when>
 		<xsl:when test=". = 'flash'"><icon BUILTIN="clanbomber"/></xsl:when>
 		<xsl:when test=". = 'heart'"><icon BUILTIN="bookmark"/></xsl:when>
 		<xsl:when test=". = 'thumb-down'"><icon BUILTIN="button_cancel"/></xsl:when>
 		<xsl:when test=". = 'thumb-up'"><icon BUILTIN="button_ok"/></xsl:when>
 		<xsl:when test=". = 'arrow-down'"><icon BUILTIN="full-7"/></xsl:when>
 		<xsl:when test=". = 'arrow-up'"><icon BUILTIN="full-1"/></xsl:when>
 		<xsl:when test=". = 'lamp'"><icon BUILTIN="idea"/></xsl:when>
 		<xsl:when test=". = 'clock'"><icon BUILTIN="bell"/></xsl:when>
 		<xsl:when test=". = 'smiley-sad'"><icon BUILTIN="button_cancel"/></xsl:when>
 		<xsl:when test=". = 'smiley-good'"><icon BUILTIN="ksmiletris"/></xsl:when>
 		<xsl:when test=". = 'stopsign'"><icon BUILTIN="stop"/></xsl:when>
 		<xsl:when test=". = 'cross-red'"><icon BUILTIN="button_cancel"/></xsl:when>
 		<xsl:when test=". = 'hook-green'"><icon BUILTIN="button_ok"/></xsl:when>
 		<xsl:when test=". = 'questionmark'"><icon BUILTIN="help"/></xsl:when>
 		<xsl:when test=". = 'exclamationmark'"><icon BUILTIN="messagebox_warning"/></xsl:when>
 	</xsl:choose>
 </xsl:template>
 
 </xsl:transform>