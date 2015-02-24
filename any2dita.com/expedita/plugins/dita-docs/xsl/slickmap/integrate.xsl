<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:lookup="http://yourdomain.com/lookup"
    extension-element-prefixes="lookup"
>


<!-- table outputclass styling -->
<xsl:template match='*[contains(@class," topic/dl ")][@outputclass = "asTable"]'>
	<div class='simpletable'>
		<table>
			<xsl:apply-templates mode="asTable"/>
		</table>
	</div>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dlentry ")]' mode="asTable">
  <tr>
    <xsl:apply-templates select='*[contains(@class," topic/dt ")]' mode="asTable"/>
    <xsl:apply-templates select='*[contains(@class," topic/dd ")]' mode="asTable"/>
  </tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dlhead ")]' mode="asTable">
  <tr>
    <xsl:apply-templates select='*[contains(@class," topic/dthd ")]' mode="asTable"/>
    <xsl:apply-templates select='*[contains(@class," topic/ddhd ")]' mode="asTable"/>
  </tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dthd ")]' mode="asTable">
  <th valign="top" align="left" >
    <xsl:apply-templates/>
  </th>
</xsl:template>

<xsl:template match='*[contains(@class," topic/ddhd ")]' mode="asTable">
  <th valign="top" align="left" >
    <xsl:apply-templates/>
  </th>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dt ")]' mode="asTable">
  <td valign="top" style="padding-top: 3pt;" width="25%" >
    <xsl:apply-templates/>
  </td>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dd ")]' mode="asTable">
  <td valign="top" style="padding-top: 3pt;" width="75%" >
    <xsl:apply-templates/>
  </td>
</xsl:template>

	<!-- toggle element visibility on and off -->
	<xsl:template match='*[@outputclass = "toggle"]'>
		<xsl:variable name="label">
			<xsl:choose>
				<xsl:when test='title'>
					<xsl:value-of select="title"/>
				</xsl:when>
				<xsl:when test='@base'>
					<xsl:value-of select="@base"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Toggle</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@base = 'anchor'">
				<a class='uxcontrol' href="javascript:;" onmousedown="toggleVis('asdf{generate-id()}');"><xsl:value-of select="$label"/></a>
			</xsl:when>
			<xsl:when test="@base = 'button'">
				<button onclick="toggleVis('asdf{generate-id()}')"><xsl:value-of select="$label"/></button>
			</xsl:when>
			<xsl:otherwise>
				<button onclick="toggleVis('asdf{generate-id()}')"><xsl:value-of select="$label"/></button>
			</xsl:otherwise>
		</xsl:choose>
		<div id="asdf{generate-id()}" style="display:block;">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- slide content from the tab content  -->
	<xsl:template match='*[contains(@class," topic/dl ")][@outputclass = "aside"]'>
	    <div class="tabwrapper">
	        <ul class="tabs" persist="true">
	 			<xsl:apply-templates select='*[contains(@class," topic/dlentry ")]' mode='tabs'/>
			</ul>
		</div>
	</xsl:template>

	<!-- tab content (occurs in body, hence is not a themed element) -->
	<xsl:template match='*[contains(@class," topic/dl ")][@outputclass = "tabcontent"]'>
	    <div class="tabwrapper">
	        <ul class="tabs" persist="true">
	 			<xsl:apply-templates select='*[contains(@class," topic/dlentry ")]' mode='tabs'/>
			</ul>
	        <div class="tabcontents">
	 			<xsl:apply-templates select='*[contains(@class," topic/dlentry ")]' mode='tabcontents'/>
	        </div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dlentry ")]' mode='tabs'>
		<xsl:variable name="sequence" select="count(preceding-sibling::*) + 1"/>
		<li>
			<a href="#" rel="view{$sequence}">
				<xsl:value-of select='*[contains(@class," topic/dt ")]'/>
			</a>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dlentry ")]' mode='tabcontents'>
		<xsl:variable name="sequence" select="count(preceding-sibling::*) + 1"/>
       <div id="view{$sequence}" class="tabcontent">
			<xsl:if test="contains(parent::*/@base,'titleON')">
				<h5><xsl:value-of select='*[contains(@class," topic/dt ")]'/></h5>
			</xsl:if>
			<xsl:apply-templates select='*[contains(@class," topic/dd ")]'/>
 		    <br /><br />
			<xsl:if test="contains(parent::*/@base,'linkON')">
				<xsl:variable name="targ-fn" select="substring-before(@href,'.')"/>
				<a class="read_more" href="{$serviceType}/topic/{$targ-fn}">Learn more...</a>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template select='*[contains(@class," topic/dd ")]' mode='tabcontents'>
		<xsl:apply-templates/><!-- prevent standard rule from inserting dd markup -->
	</xsl:template>
	


<!-- simpletable as source for tabbed content -->

	<!-- tab content (occurs in body, hence is not a themed element) -->
	<!-- Demo only; need to put tabs on the bottom and buld header into labels for the content divs -->
	<xsl:template match='*[contains(@class," topic/simpletable ")][@outputclass = "compare"]'>
	    <div class="tabwrapper">
	        <ul class="tabs" persist="true">
	 			<xsl:apply-templates select='*[contains(@class," topic/strow ")][@outputclass = "set"]' mode='tabs'/>
			</ul>
	        <div class="tabcontents">
	 			<xsl:apply-templates select='*[contains(@class," topic/strow ")][@outputclass = "set"]' mode='tabcontents'/>
	        </div>
		</div>
	</xsl:template>

	<!-- build the nav -->
	<xsl:template match='*[contains(@class," topic/strow ")][@outputclass = "set"]' mode='tabs'>
		<xsl:variable name="sequence" select="count(preceding-sibling::*) + 1"/>
		<li>
			<a href="#" rel="view{$sequence}">
				<xsl:value-of select='*[contains(@class," topic/stentry ")][@outputclass = "title"]'/>
			</a>
		</li>
	</xsl:template>

	<!-- build the content bin -->
	<xsl:template match='*[contains(@class," topic/strow ")][@outputclass = "set"]' mode='tabcontents'>
		<xsl:variable name="sequence" select="count(preceding-sibling::*) + 1"/>
       <div id="view{$sequence}" class="tabcontent">
			<table border="1" width="90%">
				<tr>
					<td colspan="2" style="background:#F0F0F0;">
						<h4>Comparison: <xsl:value-of select='../*[contains(@class," topic/sthead ")][@outputclass = "type"]/*[contains(@class," topic/stentry ")][@outputclass = "comparison"]'/></h4>
						<xsl:apply-templates select='                                                             *[contains(@class," topic/stentry ")][@outputclass = "comparison"]'/>
					</td>
				</tr>
				<tr>
					<td style="background:#F0F0D0;" width="50%">
						<h4>Pro: <xsl:value-of select='../*[contains(@class," topic/sthead ")][@outputclass = "type"]/*[contains(@class," topic/stentry ")][@outputclass = "pro"]'/></h4>
						<xsl:apply-templates select='*[contains(@class," topic/stentry ")][@outputclass = "pro"]'/>
					</td>
		 			<td style="background:#F0D0F0;">
						<h4>Con: <xsl:value-of select='../*[contains(@class," topic/sthead ")][@outputclass = "type"]/*[contains(@class," topic/stentry ")][@outputclass = "con"]'/></h4>
		 				<xsl:apply-templates select='*[contains(@class," topic/stentry ")][@outputclass = "con"]'/>
		 			</td>
	 			</tr>
		    </table>
		</div>
	</xsl:template>

	<xsl:template select='*[contains(@class," topic/stentry ")][@outputclass = "comparison"]' mode='tabcontents'>
		<xsl:apply-templates/><!-- prevent standard rule from inserting dd markup -->
	</xsl:template>




	<xsl:template match='*[contains(@class," map/topicref ")]' mode='tabcontentx'>
		<!-- emit the queried data into the required display structure -->
        <ul class="tabs" persist="true">
            <li><a href="#" rel="view{$sequence}"><xsl:value-of select="$tablabel"/></a></li>
		</ul>
        <div class="tabcontents">
            <div id="view{$sequence}" class="tabcontent">
            	<!-- from here on we can fall back to the default slideshow templates' handing of the content -->
				<xsl:apply-templates select='$doc/*/*[contains(@class," topic/shortdesc ")]' mode='slideshow'/>
			    <br /><br />
				<xsl:if test="1 = 1">
					<xsl:variable name="targ-fn" select="substring-before(@href,'.')"/>
					<a class="read_more" href="{$serviceType}/topic/{$targ-fn}">Learn more...</a>
				</xsl:if>
            </div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/body ")]' mode='slideshow'>
		<p>Got into body</p><xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/shortdesc ")]' mode='slideshow'>
		<xsl:value-of select="text()"/>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/image ")]' mode='slideshow'>
		<xsl:variable name="filePath">
			<xsl:value-of select="$contentDir"/>/<xsl:value-of select="$groupName"/>/<xsl:value-of select="@href"/>
		</xsl:variable>

		<a href="{$filePath}"><img class="s3Img imgzoom" src="{$filePath}" alt="1" /></a>
	</xsl:template>


	
	
	<xsl:template match='*[contains(@class," topic/simpletable ")][@outputclass = "comparetable"]'>
		<div class='simpletable'>
			<xsl:if test='@id'>
				<xsl:attribute name='id'><xsl:value-of select='@id'/></xsl:attribute>
			</xsl:if>
			<table><!--  border="1" style="border:1px #silver solid;border-collapse:collapse;" cellpadding="10" -->
				<tbody>
					<xsl:apply-templates mode="comparetable"/>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/sthead ")]' mode="comparetable">
		<tr>1
			<xsl:apply-templates mode='stheadcompare'/>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/stentry ")]' mode='stheadcompare'>
		<th>2
			<button>
				<xsl:attribute name="onclick">toggleVis('<xsl:value-of select="generate-id()"/>')</xsl:attribute>
				<xsl:apply-templates/>
			</button>
		</th>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/strow ")]' mode="comparetable">
		<xsl:variable name="connectID">cmptbl<xsl:value-of select="generate-id()"/></xsl:variable>
		<tr id="$connectID" style="display:block;">3
			<xsl:apply-templates mode='strowcompare'/>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/stentry ")]' mode='strowcompare'>
		<td valign='top'>4
			<xsl:choose>
				<xsl:when test='node()'>
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<span>.</span>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>


</xsl:stylesheet>