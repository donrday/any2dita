<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- http://www.biglist.com/lists/xsl-list/archives/200505/msg01081.html -->
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version='1.0'>

<xsl:template match='*[contains(@class," topic/table ")]'>
	<xsl:variable name="Class">
		<xsl:choose>
			<xsl:when test="@frame='sides'">l r</xsl:when>
			<xsl:when test="@frame='top'">t</xsl:when>
			<xsl:when test="@frame='bottom'">b</xsl:when>
			<xsl:when test="@frame='topbot'">t b</xsl:when>
			<xsl:when test="@frame='all'">t b l r</xsl:when>
			<xsl:when test="@frame='none'"></xsl:when>
			<xsl:otherwise>t b l r</xsl:otherwise>	<!-- default -->
		</xsl:choose>
	</xsl:variable>
	
	<!-- added div to encapsulate the title and description pulled outside of the usual CALS table structure; 
	     more like fig and simpletable -->
	<!-- Get the specialized title element name in case it is needed for class "namespacing" etc.. (think faq/question) -->
	<xsl:variable name="thisTitleName"><xsl:value-of select='name(*[contains(@class," topic/title ")])'/></xsl:variable>
	<div class='sectionDiv table'>
		<!-- Apply id for xref to this container -->
	    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="/*/@id"/></xsl:attribute></xsl:if>
		<xsl:call-template name="check-atts"/>
		<xsl:call-template name="check-rev"/>
	    <!-- Instance the caption -->
		<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
		<xsl:apply-templates select='*[contains(@class," topic/desc ")]'/>
		<!-- Instance the body -->
		<div class='tablecontent'>
			<!-- Apply scale and frame styling to this container -->
			<xsl:variable name="scale">
				<xsl:choose>
				<xsl:when test="@scale">
					<xsl:value-of select="@scale div 100.0"/>
				</xsl:when>
					<xsl:otherwise>1.0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="style">
				<xsl:value-of select="concat('font-size:',1 * $scale,'em;')"/><!-- The '1*' is a scale factor; increase as needed. -->
			</xsl:attribute>
			<!-- Instance the body -->
			<table class="table {$Class}">
				<xsl:apply-templates select='*[contains(@class," topic/tgroup ")]'/>
			</table>
		</div>
	</div>
</xsl:template>

<!-- the main transforms may have this template already -->
<xsl:template match='*[contains(@class," topic/table ")]/*[contains(@class," topic/title ")]'>
	<p class="tableTitle"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match='*[contains(@class," topic/table ")]/*[contains(@class," topic/desc ")]'>
	<p><xsl:apply-templates/></p>
</xsl:template>


<xsl:template match='*[contains(@class," topic/tgroup ")]'>
	<xsl:variable name="total-percents-colwidth">
		<xsl:call-template 	name="total-width"/>
	</xsl:variable>
	<colgroup>
		<xsl:apply-templates select='*[contains(@class," topic/colspec ")]'>
			<xsl:with-param name="total-percents-colwidth" select="$total-percents-colwidth"/>
		</xsl:apply-templates>
	</colgroup>
	<xsl:apply-templates select='*[contains(@class," topic/thead ")]'/>
	<xsl:apply-templates select='*[contains(@class," topic/tbody ")]'/>
</xsl:template>

<xsl:template name="total-width">
	<xsl:param name="percents" select="colspec[contains(@colwidth,'*')]/@colwidth"/>
	<xsl:param name="total" select="'0'"/>
	<xsl:choose>
		<xsl:when test="count($percents)&gt;1">
			<xsl:call-template name="total-width">
				<xsl:with-param name="percents" select="$percents[position()&gt;1]"/>
				<xsl:with-param name="total" select="number($total)+number(substring-before($percents[1],'*'))"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="number($total)+number(substring-before($percents[1],'*'))"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match='*[contains(@class," topic/colspec ")]'>
	<xsl:param name="total-percents-colwidth" select="'1'"/>
	<xsl:choose>
		<xsl:when test="contains(@colwidth,'pt')">
			<col width="{substring-before(@colwidth,'pt')}" />
		</xsl:when>
		<xsl:when test="contains(@colwidth,'*')">
			<col width="{100 * number(substring-before(@colwidth,'*')) div number($total-percents-colwidth)}%" />
		</xsl:when>
		<xsl:otherwise>
			<col />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match='*[contains(@class," topic/thead ")]'>
	<thead>
		<xsl:apply-templates select='*[contains(@class," topic/row ")]'/>
	</thead>
</xsl:template>

<xsl:template match='*[contains(@class," topic/tbody ")]'>
	<tbody>
		<xsl:apply-templates select='*[contains(@class," topic/row ")]'/>
	</tbody>
</xsl:template>

<xsl:template match='*[contains(@class," topic/thead ")]/*[contains(@class," topic/row ")]'>
	<tr>
		<xsl:apply-templates select="entry">
			<xsl:with-param name="up-rowsep">
				<xsl:choose>
					<xsl:when test="@rowsep"><xsl:value-of select="@rowsep"/></xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="td" select="'th'"/>
		</xsl:apply-templates>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/tbody ")]/*[contains(@class," topic/row ")]'>
	<tr>
		<xsl:apply-templates select="entry">
			<xsl:with-param name="up-rowsep">
			<xsl:choose>
				<xsl:when test="@rowsep"><xsl:value-of select="@rowsep"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/entry ")]'>
	<xsl:param name="up-rowsep"/>
	<xsl:param name="td" select="'td'"/>
	<xsl:variable name="align">
		<xsl:choose>
			<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
			<xsl:when test='ancestor::*[contains(@class," topic/tgroup ")][1]/*[contains(@class," topic/colspec ")][position()]/@align'>
				<xsl:value-of select='ancestor::*[contains(@class," topic/tgroup ")][1]/*[contains(@class," topic/colspec ")][position()]/@align'/>
			</xsl:when>
			<xsl:when test='ancestor::*[contains(@class," topic/tgroup ")][1]/@align'>
				<xsl:value-of select='ancestor::*[contains(@class," topic/tgroup ")][1]/@align'/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="valign">
		<xsl:choose>
			<xsl:when test="@valign"><xsl:value-of select="@valign"/></xsl:when>
			<xsl:when test='*[contains(@class," topic/row ")]/@valign'><xsl:value-of select='*[contains(@class," topic/row ")]/@valign'/></xsl:when>
			<xsl:when test='parent::*[contains(@class," topic/tbody ")]/@valign'>
				<xsl:value-of select='parent::*[contains(@class," topic/tbody ")]/@valign'/>
			</xsl:when>
			<xsl:when test='parent::*[contains(@class," topic/thead ")]/@valign'>
				<xsl:value-of select='parent::*[contains(@class," topic/thead ")]/@valign'/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:element name="{$td}">
		<xsl:if test="@namest">
			<xsl:attribute name="colspan"><xsl:value-of select="number(@nameend)-number(@namest)+1"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@morerows">
			<xsl:attribute name="rowspan"><xsl:value-of select="number(@morerows)+1"/></xsl:attribute>
		</xsl:if>
		<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="@rowsep='0'"></xsl:when>
				<xsl:when test='../following-sibling::*[contains(@class," topic/row ")]'>
					<xsl:choose>
						<xsl:when test="@rowsep='1' or $up-rowsep='1'">b </xsl:when>
						<xsl:when test='ancestor::*[contains(@class," topic/tgroup ")]/colspec[position()]/@rowsep="1"'>b</xsl:when>
						<xsl:when test='ancestor::*[contains(@class," topic/tgroup ")]/@rowsep="1"'>b </xsl:when>
						<xsl:when test='ancestor::*[contains(@class," topic/table ")]/@rowsep="1"'>b </xsl:when>
						<xsl:otherwise>x </xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- DRD: Added a case to handle a thead with a single row. How does CALS turn off a header bottom border, though? -->
				<xsl:when test='ancestor::*[contains(@class," topic/thead ")]'>b </xsl:when>
				<xsl:otherwise>q </xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@colsep='0'"></xsl:when>
				<xsl:when test="following-sibling::entry">
					<xsl:choose>
						<xsl:when test="@colsep='1'">r </xsl:when>
						<xsl:when test='ancestor::*[contains(@class," topic/tgroup ")]/colspec[position()]/@colsep="1"'>r</xsl:when>
						<xsl:when test='ancestor::*[contains(@class," topic/tgroup ")]/@colsep="1"'>r </xsl:when>
						<xsl:when test='ancestor::*[contains(@class," topic/table ")]/@colsep="1"'>r </xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$valign!=''">
			<xsl:attribute name="valign">
				<xsl:value-of select="$valign"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="$align!=''">
			<xsl:attribute name="align">
				<xsl:value-of select="$align"/>
			</xsl:attribute>
		</xsl:if>
		
		<xsl:apply-templates/>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>