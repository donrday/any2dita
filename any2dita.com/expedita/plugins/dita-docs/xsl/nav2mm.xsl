 <xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
 <xsl:template match="/">
 	<xsl:apply-templates select="nav" />
 </xsl:template>
 
 <xsl:template match="nav">
 	<map version="0.8.0">
 		<node ID="_" TEXT="map imported from any2dita/txt2map">
 		<xsl:apply-templates select="ul" />
 		</node>
 	</map>
 </xsl:template>
 
 <xsl:template match="ul">
 <xsl:text>Ba ba booie</xsl:text>
 </xsl:template>
 
 <xsl:template name="junk">
 	<node CREATED="0" MODIFIED="0">
 		<xsl:attribute name="TEXT">
 			<xsl:value-of select="heading" />
 		</xsl:attribute>
 		<xsl:attribute name="COLOR">
 			<xsl:value-of select="heading/@textColor" />
 		</xsl:attribute>
 		<xsl:if test="@url != ''">
 			<xsl:attribute name="LINK">
 				<xsl:value-of select="@url" />			
 			</xsl:attribute>
 		</xsl:if>
 		<xsl:attribute name="ID">VYM_<xsl:value-of select="@x1" />_<xsl:value-of select="@y1" /></xsl:attribute>
 		<xsl:apply-templates select="standardflag" />		
 		<xsl:apply-templates select="branch" />
 	</node>
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