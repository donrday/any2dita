<?xml version="1.0" encoding="UTF-8"?>
<!--
 | Copyright 2010 Don R. Day
 | 
 |    Licensed under the Apache License, Version 2.0 (the "License");
 |    you may not use this file except in compliance with the License.
 |    You may obtain a copy of the License at
 | 
 |        http://www.apache.org/licenses/LICENSE-2.0
 | 
 |    Unless required by applicable law or agreed to in writing, software
 |    distributed under the License is distributed on an "AS IS" BASIS,
 |    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 |    See the License for the specific language governing permissions and
 |    limitations under the License.
 | 
 | Contributed to the expeDITA-cct Content Collaboration Tools Sourceforge project.
 '-->
<xsl:stylesheet
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:lookup="http://yourdomain.com/lookup"
    extension-element-prefixes="lookup"
>

	<xsl:template match='*[contains(@class," topic/simpletable ")]'>
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
			<!-- This element has no caption. -->
			<!-- Instance the body -->
			<div class='simpletablecontent'>
				<!-- now instance the simpletable itself within its context container -->
				<table class="table simpletable {$Class}"><!-- Note: the CALS rowsep/colsep/frame CSS does not apply to simpletable -->
					<!-- Apply id for xref to this container -->
				    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="/*/@id"/></xsl:attribute></xsl:if>
					<xsl:call-template name="check-atts"/>
					<xsl:call-template name="check-rev"/>
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
					<!-- Apply id for xref to this container -->
				    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="/*/@id"/></xsl:attribute></xsl:if>
					<xsl:call-template name="check-atts"/>
					<xsl:call-template name="check-rev"/>
					<tbody><xsl:apply-templates/></tbody>
				</table>
			</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/sthead ")]'>
		<tr>
			<xsl:variable name="parent-position" select="count(../preceding-sibling::*) + 1"/>
			<xsl:if test='(parent::*/@relcolwidth)'>
		        <xsl:variable name="dataList">
		            <xsl:value-of select="parent::*/@relcolwidth"/><xsl:text> </xsl:text>
		        </xsl:variable>
		        <xsl:call-template name="processingTemplate">
		            <xsl:with-param name="datalist" select="$dataList"/>
		            <xsl:with-param name="x" select="1"/>
		            <xsl:with-param name="y" select="0"/>
		        </xsl:call-template>
				<xsl:comment>Using relcolwidth: <xsl:value-of select="parent::*/@relcolwidth"/></xsl:comment>
			</xsl:if>
			<xsl:apply-templates mode='sthead'/>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/strow ")]'>
		<xsl:variable name="parent-position" select="count(../preceding-sibling::*) + 1"/>
		<tr>
			<xsl:apply-templates mode='strow'/>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/stentry ")]' mode='sthead'>
    <xsl:variable name="localkeycol">
      <xsl:choose>
        <xsl:when test="ancestor::*[contains(@class,' topic/simpletable ')]/@keycol">
          <xsl:value-of select="ancestor::*[contains(@class,' topic/simpletable ')]/@keycol"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
		<xsl:variable name="parent-position" select="count(../preceding-sibling::*) + 1"/>
		<th class="simpleTableEntry" data-keycol="{$localkeycol}">
			<xsl:if test="$parent-position = 1">
				<xsl:attribute name="style">width:attr(data-col<xsl:value-of select="position()"/>);</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test='node()'>
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>&#160;
				</xsl:otherwise>
			</xsl:choose>
		</th>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/stentry ")]' mode='strow'>
		<xsl:variable name="parent-position" select="count(../preceding-sibling::*) + 1"/>
		<td class="simpleTableEntry">
			<xsl:if test="$parent-position = 1">
				<!--xsl:attribute name="style">width:attr(data-col<xsl:value-of select="position()"/>);</xsl:attribute-->
			</xsl:if>
			<xsl:choose>
				<xsl:when test='node()'>
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>&#160;
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>
	
	<!-- Below is a trial of the technique discussed at http://stackoverflow.com/questions/18408488/setting-width-with-css-attr -->
	<!-- The header is properly set up, but as warned above, this usage is not functional. -->
	<!-- Perhaps for now consider generating an embedded style attribute containing the necessary local adjustments. -->
	
	<!-- For relcolwidth sizing: normalize the values into data attributes on the parent element -->
	<!-- data-col1 = multiplier value derived from first n* token, for example -->
	<!-- data-colcount = number of columns (not used) -->
	<!-- data-divs = number of indicated divs summed over all tokens -->
	<!-- data-perdiv = percentage of width to multiply by each group's div value to determine percentage of width to apply -->
	<!-- TO BE DONE: need to enable the first row data to be seen and used by first row cells only. Haven't solved this yet. -->
	<!-- Tokenize logic based on xslt 1.0 example at http://stackoverflow.com/questions/7425071/split-function-in-xslt-1-0 -->
    <xsl:template name="processingTemplate">
        <xsl:param name="datalist"/>
        <xsl:param name="x"/>
        <xsl:param name="y"/>
	    <xsl:variable name="delimiter">
	        <xsl:text>* </xsl:text>
	    </xsl:variable>
        <xsl:choose>
        	<xsl:when test="contains($datalist,$delimiter)">
        		<!-- The data-colx multiplicand actually needs to be the "perdiv" value from peer context. -->
                <xsl:attribute name="data-col{$x}"><xsl:value-of select="substring-before($datalist,$delimiter)"/>px</xsl:attribute>
                <xsl:call-template name="processingTemplate">
                    <xsl:with-param name="datalist" select="substring-after($datalist,$delimiter)"/>
					<xsl:with-param name="x" select="$x + 1"/>
					<xsl:with-param name="y" select="$y + substring-before($datalist,$delimiter)"/>
                </xsl:call-template>
        	</xsl:when>
            <xsl:when test="string-length($datalist)=1">
        		<!-- The data-colx multiplicand actually needs to be the "perdiv" value from peer context. -->
                <xsl:attribute name="data-col{$x}"><xsl:value-of select="$datalist"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
		        <xsl:if test="string-length($datalist)=0">
		        	<xsl:attribute name="data-colcount">
		                <xsl:value-of select="$x - 1"/>
		            </xsl:attribute>
		        	<xsl:attribute name="data-divs">
		                <xsl:value-of select="$y"/>
		            </xsl:attribute>
		        	<xsl:attribute name="data-perdiv">
		                <xsl:value-of select="100 div ($y)"/>
		            </xsl:attribute>
				</xsl:if>  
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	

</xsl:stylesheet>