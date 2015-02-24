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
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>


<!-- patch #3 DRD -->
<xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
<!--xsl:output method="xml"
            indent="yes"
            encoding="utf-8"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
/-->
	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/>
  
  	<!-- URL segments -->
	<xsl:param name="serviceType" select="'index'"/>
	<xsl:param name="queryType" select="'topic'"/>
    
<xsl:param name="byelement" select="'topictitle'"/>

<xsl:param name="headlevel1" select="'1'"/>
<xsl:param name="headclass1" select="''"/>
<xsl:param name="classlevel1" select="''"/>

	<xsl:param name="contentPath" select="''"/>
	<xsl:param name="contentSlug" select="''"/>
	<xsl:param name="groupName" select="''"/>
	<xsl:param name="mapName" select="''"/>
	<xsl:param name="resourceName" select="''"/>
	<xsl:param name="resourceExt" select="''"/>
	<xsl:param name="phpmsg" select="''"/>
	<xsl:param name="queryPath" select="''"/>
	<xsl:param name="headlevel1" select="'1'"/>

  <xsl:variable name="adjustedPath">
 	 <xsl:value-of select="$contentPath"/><!-- might be serviceType for other URL schemes... -->
  </xsl:variable>

<!-- markup conversion: map elements -->

	<!-- =============map=============== -->
	<!-- 
		Pass navtitle content into the HTML editor as if it were element content.
		This makes it plainly editable! The editor has a link dialog already, so don't bother with href. 
	-->
	<xsl:template name='mapa' match='*[contains(@class," map/map ")]' mode="ala">
		<!-- no html or body wrappers because this content is internal to an existing page -->
		<!-- deal with @title and @id as commonly used attributes -->
		<!--div class="widget"-->

		<!-- deal with @title and @id as commonly used attributes -->
		<!--( ( title) (optional) then ( topicmeta) (optional) then... -->
			<xsl:apply-templates select='@title'/>
			<xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
			<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
			<ul class="mapnav"><!-- style="list-style-type: none;"-->
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ul>
			<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
		<!--/div-->
	</xsl:template>

	<xsl:template name='navmap' match='*[contains(@class," map/map ")]'>
		<!-- for "list only" use ($post style) -->
		<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
		<ul class="x1">
			<xsl:apply-templates select='topicref|topichead|topicgroup'/>
		</ul>
		<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
	</xsl:template>


	<xsl:template name='map' match='*[contains(@class," map/map ")]' mode="full">
		<!-- the top-level title inherits whatever is the display default for the current context (post, commonly) -->
		<xsl:element name="h{$headlevel1}" >
			<xsl:attribute name="data-mapname"><xsl:value-of select="$mapName"/></xsl:attribute><!---->

			<xsl:variable name="classlevel1"><xsl:value-of select="$classlevel1"/></xsl:variable>
			<xsl:variable name="nameatt"><xsl:value-of select="local-name(parent::*)"/><xsl:value-of select="local-name(.)"/></xsl:variable>
			<xsl:variable name="clstring">level<xsl:value-of select="$headlevel1"/><xsl:text> </xsl:text><xsl:value-of select="$classlevel1"/><xsl:text> </xsl:text><xsl:value-of select="$nameatt"/></xsl:variable>
			<xsl:attribute name="class"><xsl:value-of select="$clstring"/></xsl:attribute>

	 		<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:if test='@xml:lang'>
				<xsl:attribute name="lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test='@title'>
					<xsl:value-of select='@title' mode='once'/>
				</xsl:when>
				<xsl:when test='title'>
					<xsl:apply-templates select='title' mode='inner'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Untitled List</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
		<ul class="x1">
			<xsl:apply-templates select='topicref|topichead|topicgroup'/>
		</ul>
		<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
	</xsl:template>


	<xsl:template match='navref|anchor|data|data-about'>
		<!-- null these out completely for now; not supported in speckedit -->
	</xsl:template>

	<xsl:template match='reltable'>
		<h5>Relationship table</h5>
		<table border="1">
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match='relheader'>
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match='relcolspec'>
		<th>
			type = "<xsl:value-of select="@type"/>"
		</th>
	</xsl:template>

	<xsl:template match='relrow'>
		<tr>
		<xsl:for-each select="relcell">
			<xsl:apply-templates/>
		</xsl:for-each>
		</tr>
	</xsl:template>

	<xsl:template match='relcell'>
		<td><xsl:value-of select="position()"/>
			<xsl:apply-templates mode="relentry"/>
		</td>
		<td></td>
	</xsl:template>

	<xsl:template match='topicref' mode="relentry">
		<!-- generate a link, normally -->
			<a hef="{@href}"><xsl:call-template name="getTitle"/></a>
	</xsl:template>

	<xsl:template match='topicref' mode="relentrytest">
		<!-- Get the title on the fly. -->
		<span style="border:1px red solid;">
			<span style="color:gray;">[navtitle: <xsl:value-of select="@navtitle"/>] </span>
			<span style="color:darkgreen;">[href: <xsl:value-of select="@href"/>] </span>
			<span style="color:maroon;">[title: <xsl:call-template name="getTitle"/>] </span>
		</span>
	</xsl:template>

	<!-- =============common content=============== -->

	<xsl:template match='*[contains(@class," map/map ")]/@title' mode='once'>
		<h4 class="navmapTitle" id="trace3">
 		<xsl:if test="ancestor::map/@id">
			<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
		</xsl:if>
           <xsl:value-of select="."/>
		</h4>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]' mode='inner'>
			<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]' mode='once'>
		<xsl:element name="h{$headlevel1}">
			<xsl:attribute name="class"><xsl:value-of select="$classlevel1"/><xsl:text> </xsl:text><xsl:value-of select="local-name(parent::*)"/><xsl:value-of select="local-name(.)"/></xsl:attribute>
	 		<xsl:if test="ancestor::*/@id">
				<xsl:attribute name="id"><xsl:value-of select="ancestor::*/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:if test='ancestor::*/@xml:lang'>
				<xsl:attribute name="lang"><xsl:value-of select="ancestor::*/@xml:lang"/></xsl:attribute>
			</xsl:if>
			<xsl:if test='ancestor::*/@outputclass'>
				<xsl:attribute name="style"><xsl:value-of select="ancestor::*/@outputclass"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

<!-- although DITA 1.2 constructs are not available in the processing DOM for the standard expeDIT implementation, we'll see if this will catch -->
	<xsl:template match='mapref'>
		<li>
			<xsl:text>mapref </xsl:text>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref ")][normalize-space(@format) = "html"]'>
		<li><xsl:text>HTML file </xsl:text>
		<xsl:choose>
			<xsl:when test='@navtitle'>
				<xsl:value-of select="@navtitle"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Untitled resource</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> at </xsl:text><xsl:value-of select="@href"/></li>
	</xsl:template>

	<xsl:template name='topicref' match='*[contains(@class," map/topicref ")]'>
		<li>
			<xsl:variable name="topicref_nesting">
				<xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref ")])'/>
			</xsl:variable>
			<!-- process topicref/href to generate a/href -->
			<xsl:call-template name="topicref-as-link"/><!-- DRD/kilroy Referenced file is not loading. -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul class="x2">
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template name='unused_span_for_nested_link'>
			<xsl:element name="span">
				<xsl:if test='$topicref_nesting = 1'><!-- primary mechanism for topicheads -->
					<xsl:attribute name="class">nest1link</xsl:attribute>
					<!--xsl:attribute name="style">font-weight:bold; font-size:1.1em;</xsl:attribute-->
				</xsl:if>
				<xsl:call-template name="topicref-as-link"/>
			</xsl:element><!--<br/>-->
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topicgroup ")]'>
		<li class='topicgroup'>
			<!-- no href processing for this specialized element -->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul class="x3">
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/topicref mapgroup-d/topichead ")]'>
		<li class='topichead'>
			<xsl:variable name="topicref_nesting">
				<xsl:value-of select='count(ancestor-or-self::*[contains(@class," map/topicref ")])'/>
			</xsl:variable>
			<xsl:element name="span">
				<xsl:if test='$topicref_nesting = 1'><!-- primary mechanism for topicheads -->
					<xsl:attribute name="class">nest1link</xsl:attribute>
					<!--xsl:attribute name="style">font-weight:bold; font-size:1.1em;</xsl:attribute-->
				</xsl:if>
				<xsl:call-template name="getTitle"/>
			</xsl:element><!--<br/>-->
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul class="x4">
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
		<!-- Normally, meta content is used by reference, not data-driven. Should this code ever place content? -->
	</xsl:template>



<!-- version 1 -->
<xsl:template name="topicref-as-link">
	<xsl:variable name="fixedhref">
		<xsl:choose>
			<xsl:when test="contains(@href,'http://')">
				<!-- The href value is already presumeably a standard URL that was authored compliantly. -->
				<xsl:value-of select="@href"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- The standard file-based href source conventions need to be normalized per the API syntax. -->
				<!-- strip the extension off the href attribute -->
				<xsl:variable name="resource-fn">
					<xsl:value-of select="substring-before(@href,'.')"/>
				</xsl:variable>
				<!-- recover the extension to use as the "queryType" -->
				<xsl:variable name="resource-ext">
					<xsl:value-of select="substring-after(@href,'.')"/>
				</xsl:variable>
				<!-- Use the extension value to hack or sub a query type -->
				<xsl:variable name="queryType">
					<xsl:choose>
						<xsl:when test='$resource-ext = "dita"'>topic</xsl:when>
						<xsl:when test='$resource-ext = "ditamap"'>map</xsl:when>
						<xsl:when test='$resource-ext = "ditaval"'>val</xsl:when>
						<xsl:otherwise><xsl:value-of select='$queryType'/><xsl:value-of select="$resourceName"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- normalize any nested path by converting path separator / into a period . -->
				<!-- 16 Dec 2011 DRD: reverted the dotted-href logic so that we can try traversing folders normally -->
				<xsl:variable name="dotted-href">
				<!--
					<xsl:value-of select='$resource-fn'/>
				-->
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text" select="$resource-fn" />
						<xsl:with-param name="replace" select="'/'" />
						<xsl:with-param name="by" select="'~'" />
					</xsl:call-template>
				</xsl:variable>
				<!-- The groupName and mapName/resourceName values were passed in by the calling context (known context) -->
				<!-- DRD: Changed the middle context value from resourceName to mapName; not ideal, need to pass context from application. -->
				<!--<xsl:value-of select="$groupName"/>/<xsl:value-of select="$mapName"/>/--><xsl:value-of select="$dotted-href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
	<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
    <a href="{$groupName}/topic/{$fixedhref}">
    	<!--{$targparms}">this is the active link-->
		<!-- collectionType had been used here -->
		<xsl:attribute name='data-mapname'><xsl:value-of select='$mapName'/>:<xsl:value-of select="$queryType"/></xsl:attribute>
		<xsl:call-template name="getTitle"/>
	</a>
	<!-- TBD: Need to authenticate the editor role before outputting this editing flag. -->
	<xsl:if test="1 = 0">
		<xsl:text> </xsl:text><a href='{$fixedhref}?edit'>*</a>
	</xsl:if>
</xsl:template>

<!-- version 2 -->
<xsl:template name="newlink-map">
	<!-- strip off OS-specific local path prefix -->
	<xsl:variable name='prepath'>
		<xsl:choose>
			<xsl:when test='substring(@href, 1, 2) = "./"'>
				<xsl:value-of select='substring-after(@href,"./")'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Strip off the partial identifier (resulting path may include the http:// part) -->
	<xsl:variable name='cleanedpath'>
		<xsl:choose>
			<xsl:when test='contains($prepath,"#") and (substring-before($prepath,"#")="")'><!-- internal pointer only -->
				<xsl:value-of select='substring-before($prepatth,"#")'/>
			</xsl:when>
			<xsl:when test='contains($prepath,"#")'><!-- external xref with internal pointer -->
				<xsl:value-of select='substring-before($prepath,"#")'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select='$prepath'/><!-- clean xref; fall through -->
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:variable>
	
	<!-- Strip off and save the fragment identifier; it may be useful sometime. -->
	<xsl:variable name='fragid'>
		<xsl:choose>
			<xsl:when test='contains($prepath,"#") and (substring-before($prepath,"#")="")'>
				<xsl:value-of select='substring-after($prepath,"#")'/>
			</xsl:when>
			<xsl:when test='contains($prepath,"#")'>
				<xsl:value-of select='substring-after($prepath,"#")'/>
			</xsl:when>
			<xsl:otherwise>
				<!-- null! -->
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:variable>

	<!-- Get the link text part of the new URL -->
	<xsl:variable name="newlinktext">
		<xsl:choose>
			<xsl:when test="contains($cleanedpath,'http://')">
				<!-- Can't query this source, so use the URL directly as the text. -->
				<xsl:value-of select="$cleanedpath"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- make an external query -->
				<xsl:call-template name="getTitle"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Reassemble source access info into a result link in the HTML location syntax -->
	<xsl:variable name="newlinkpath">
		<xsl:choose>
			<xsl:when test="contains($cleanedpath,'http://')">
				<!-- The href value is already presumeably a standard URL that was authored compliantly. -->
				<xsl:value-of select="$cleanedpath"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="getResolvedLink"/>
				<!-- The standard file-based href source conventions need to be normalized per the API syntax. -->
				<!-- 1. strip the extension off the href attribute -->
				<!-- 2. normalize any nested path by converting path separator / into a period . -->
				<!-- Separate path, if any, from filename -->
				<xsl:variable name='pathonly'><!-- retains trailing / -->
				    <xsl:call-template name="getURL">
				        <xsl:with-param name="path" select="$cleanedpath"/>
				    </xsl:call-template>
				</xsl:variable>
				<xsl:variable name='filename'><!-- whatever follows last / (will a filename only come through okay?) -->
					<xsl:call-template name="substring-after-last">
						<xsl:with-param name="string" select="$cleanedpath"/>
						<xsl:with-param name="char" select="'/'"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- Parse filename into its parts -->
				<xsl:variable name="nfn"><!-- normalize the filename for the subsequent parse -->
					<xsl:value-of select="$filename"/>
					<xsl:if test="not(contains($filename,'.'))">.</xsl:if>
				</xsl:variable>
				<xsl:variable name="resource-fn">
					<xsl:value-of select="substring-before($nfn,'.')"/><!-- parse off resource name -->
				</xsl:variable>
				<xsl:variable name="resource-ext">
					<xsl:value-of select="substring-after($nfn,'.')"/><!-- parse off extension -->
				</xsl:variable>
				<!-- 16 Dec 2011 DRD: reverted the dotted-href logic so that we can try traversing folders normally -->
				<xsl:variable name="dotted-href">
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text" select="$pathonly" />
						<xsl:with-param name="replace" select="'/'" />
						<xsl:with-param name="by" select="'~'" />
					</xsl:call-template>
					<xsl:value-of select="$resource-fn"/>
				</xsl:variable>
				<!-- Use the extension value to hack or sub a query type -->
				<xsl:variable name="queryparm">
					<xsl:choose>
						<xsl:when test='$resource-ext = "dita"'>topic</xsl:when>
						<xsl:when test='$resource-ext = "ditamap"'>map</xsl:when>
						<xsl:when test='$resource-ext = "ditaval"'>val</xsl:when>
						<xsl:otherwise><xsl:value-of select='$queryType'/><xsl:value-of select="$resourceName"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- The groupName/serviceType and mapName values were passed in by the calling context (known context). -->
				<!-- The type is based on the extension; if we don't know that properly, we'll have to inquire it (expensive). -->
				<!-- Available data for use by any possible output build template (a in this case):
					$cleanedpath (original href with #fragid stripped off)
					$pathonly
					$filename
					$resource-fn
					$resource-ext
					$dotted-href (any folder path normalized into the filename space)
				-->
				<xsl:value-of select="adjustedPath"/><xsl:value-of select='$queryparm'/><xsl:value-of select="$dotted-href"/>
			</xsl:otherwise>
		</xsl:choose>
		<!-- At this point, we have a rebuilt link value for external addressing, and in this scope we can do 
			content queries into the referenced file itself -->
	</xsl:variable>
	<!-- We have the data; now build our "view" (link in this case) using additional DITA properties as needed: -->
	<a class="a {$context}" href='{$newlinkpath}'>
		<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<!-- content of link -->
		<span class="navtitle"><xsl:value-of select="$newlinktext"/></span>
	</a>
</xsl:template>


<!-- utility templates for all topicrefs as links -->

<xsl:template name="getTitle">
	<!-- generate the referenced title for this link. -->
	<xsl:choose>
		<xsl:when test="@navtitle">
			<xsl:value-of select="@navtitle"/>
		</xsl:when>
		<xsl:when test="topicmeta/navtitle">
			<xsl:value-of select="topicmeta/navtitle"/>
		</xsl:when>
		<xsl:when test="@somethingelse">
			<xsl:value-of select="@href"/>
		</xsl:when>
		<xsl:otherwise>
			<!-- parse the href into a qualified local path (not a link) for a document fetch -->
			<xsl:variable name='prepath'>
				<xsl:choose>
					<xsl:when test='substring(@href, 1, 2) = "./"'>
						<xsl:value-of select='substring-after(@href,"./")'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@href"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name='cleanedpath'>
				<xsl:choose>
					<xsl:when test='contains($prepath,"#") and (substring-before($prepath,"#")="")'>
						<xsl:value-of select='substring-before($prepath,"#")'/>
					</xsl:when>
					<xsl:when test='contains($prepath,"#")'>
						<xsl:value-of select='substring-before($prepath,"#")'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select='$prepath'/>
					</xsl:otherwise>
				</xsl:choose>		
			</xsl:variable>
			<xsl:variable name='fragid'>
				<xsl:choose>
					<xsl:when test='contains($prepath,"#") and (substring-before($prepath,"#")="")'>
						<xsl:value-of select='substring-after($prepath,"#")'/>
					</xsl:when>
					<xsl:when test='contains($prepath,"#")'>
						<xsl:value-of select='substring-after($prepath,"#")'/>
					</xsl:when>
					<xsl:otherwise>
						<!-- null! -->
					</xsl:otherwise>
				</xsl:choose>		
			</xsl:variable>
			
			<xsl:variable name='filename'><!-- whatever follows last / (will a filename only come through okay?) -->
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="string" select="$cleanedpath"/>
					<xsl:with-param name="char" select="'/'"/>
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:variable name='docpath'><!-- Fix for "kilroy" issue; path was incomplete for referencing. -->
				<xsl:value-of select="$contentPath"/><xsl:value-of select="$cleanedpath"/>
			</xsl:variable>
			<!-- Note that cleanedpath is better for nested paths; filename works ok in a flat addressing space. -->

			<!-- This is a proper "if file_exists()" test for XSLT 1.0 in PHP's libxslt module. It generates an error
			     message, but the logic still falls through gracefully. Turn on PHP errors for dev; off for production. -->
			<!--xsl:message>CLEANPATH: <xsl:value-of select="$docpath"/></xsl:message-->
			<xsl:choose>
				<!-- query the title from the resource -->
	            <xsl:when test="document($docpath,.)">
					<!-- load the referenced topic into processor for potentially multiple queries -->
					<xsl:variable name='thisdoc' select='document($docpath,.)'/>
					<xsl:value-of select='$thisdoc/*/*[contains(@class," topic/title ")]'/>
	            </xsl:when>
	            <!-- generate a developer message as the title text -->
	            <xsl:otherwise>
	                <xsl:value-of select="$filename"/>
	                <xsl:comment>DEV: missing file for link target</xsl:comment>
	            </xsl:otherwise>
	        </xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="getResolvedLink">
	<!-- generate the referenced link for this topicref. -->
</xsl:template>

	<!-- http://stackoverflow.com/questions/3890605/xsl-removing-the-filename-from-the-path-string -->
    <xsl:template name="getURL">
        <xsl:param name="path" />
        <xsl:choose>
            <xsl:when test="contains($path,'/')">
                <xsl:value-of select="substring-before($path,'/')" />
                <xsl:text>/</xsl:text>
                <xsl:call-template name="getURL">
                    <xsl:with-param name="path" select="substring-after($path,'/')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
    </xsl:template>

	<!-- http://stackoverflow.com/questions/15248057/xsl-just-the-filename-without-the-path?rq=1 -->
	<xsl:template name="substring-after-last">
		<xsl:param name="string"/>
		<xsl:param name="char"/>
		<xsl:choose>
			<xsl:when test="contains($string, $char)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="string" select="substring-after($string, $char)"/>
					<xsl:with-param name="char" select="$char"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<xsl:template name='linkunused'>
	<xsl:variable name="sourceref">
		<xsl:value-of select="$contentPath"/>/<xsl:value-of select="$resource-fn"/>.<xsl:value-of select="$resource-ext"/>
	</xsl:variable>
	<!--(<xsl:value-of select="$resourceExt"/>)-->
	<!-- 	<a class="a nav" href='{$contentPath}/{$resource-fn}/{$fixedhref}'> -->
</xsl:template>





<!-- Bookmap rendering (DITA 1.1 only) -->

<xsl:template match='*[contains(@class," map/map bookmap/bookmap ")]'>
	<div class="xwidget">
		<xsl:apply-templates select='*[contains(@class," bookmap/booktitle ")]'/>
		<xsl:apply-templates select='*[contains(@class," bookmap/bookmeta ")]'/>
		<!-- front, body, backmatter -->
		<ul id="mapnav-ul"><!-- style="list-style-type: none;"-->
			<xsl:apply-templates select='*[contains(@class," map/topicref ")]' mode="sideBookNav"/>
		</ul>
	</div>
</xsl:template>

<xsl:template match='*[contains(@class," map/map bookmap/bookmap ")]/*[contains(@class," topic/title bookmap/booktitle ")]'>
<div style="border:thin black solid;padding-bottom:3em;">
	<h4 style="text-align:center;font-style:italic;"><xsl:value-of select="//booklibrary"/></h4>
	<h3 class="navmapTitle"  style="font-size:1.5em">
		<xsl:if test="ancestor::map/@id">
			<xsl:attribute name="id"><xsl:value-of select="ancestor::map/@id"/></xsl:attribute>
		</xsl:if>
		<xsl:value-of select='//*[contains(@class," topic/ph bookmap/mainbooktitle ")]'/>
	</h3>
	<!--<div><br/><b>Table of Contents</b></div>-->
	<xsl:if test='//*[contains(@class," topic/ph bookmap/booktitlealt ")]'>
		<div style="margin-bottom:.7em;">
			<b style="font-size:.9em"><xsl:value-of select='//*[contains(@class," topic/ph bookmap/booktitlealt ")]'/></b>
		</div>
	</xsl:if>
</div>
</xsl:template>

<xsl:template name="do_bookmap" match='*[contains(@class," map/topicmeta bookmap/bookmeta ")]'>
	<div class="widget">
		<!-- bookmeta stuff -->
		<xsl:if test='//*[contains(@class,"  topic/author xnal-d/authorinformation ")]'>
			<div style="margin-top:1.4em;font-size:.8em">Authors:
				<xsl:for-each select='//*[contains(@class," topic/data xnal-d/personname ")]'>
					<div style="margin-left:1em"><xsl:value-of select="."/></div>
				</xsl:for-each>
			</div>
		</xsl:if>
		<hr/>
	</div>
</xsl:template>



<xsl:template match='*[contains(@class," map/topicref bookmap/booklists ")]' mode="sideBookNav">
  <!-- this is automated function -->
</xsl:template>


<xsl:template match='*[contains(@class," bookmap/chapter ")]' mode="sideBookNav">
	<li style='padding:2px 0px 2px 0px'>		
		<b>Chapter <xsl:number/>. </b>
		<xsl:call-template name="newlink"/>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ul>
		</xsl:if>
		<!-- after the link, echo some attribute info about the element -->
		<!--xsl:call-template name="ref-adorn"/-->
	</li>
</xsl:template>

<xsl:template match='*[contains(@class," map/topicref bookmap/preface ")]' mode="sideBookNav">
	<li style='padding:2px 0px 2px 0px'>		
		<b>Preface: </b>
		<xsl:call-template name="newlink"/>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ul>
		</xsl:if>
		<!-- after the link, echo some attribute info about the element -->
		<!--xsl:call-template name="ref-adorn"/-->
	</li>
</xsl:template>

<xsl:template match='*[contains(@class," map/topicref bookmap/bookabstract ")]' mode="sideBookNav">
	<li style='padding:2px 0px 2px 0px'>
		<b>Abstract: </b>
		<xsl:call-template name="newlink"/>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ul>
		</xsl:if>
		<!-- after the link, echo some attribute info about the element -->
		<!--xsl:call-template name="ref-adorn"/-->
	</li>
</xsl:template>

<!--
			<b>Abstract: </b>
			<b>Notices: </b>
-->


<xsl:template match='*[contains(@class," mapgroup-d/topichead ")]' mode='sideBookNav'>
	<li class='topichead nav'>
		<b><xsl:value-of select="@navtitle"/></b>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul>
				<xsl:apply-templates mode="sideBookNav"/>
			</ul>
		</xsl:if>
	</li>
</xsl:template>


<xsl:template match='*[contains(@class," mapgroup-d/topicgroup ")]' mode='sideBookNav'> <!-- mapgroup-d/topicgroup this handles frontmatter, backmatter and booklist groups -->
	<li class='topicgroup nav'>
		<b><xsl:value-of select="@outputclass"/></b>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul>
				<xsl:apply-templates mode="sideBookNav"/>
			</ul>
		</xsl:if>
	</li>
</xsl:template>


<xsl:template match='*[contains(@class," map/topicref bookmap/appendix ")]' mode="sideBookNav">
	<li style='padding:2px 0px 2px 0px'>		
		<b>Appendix <xsl:number/>. </b>
		<xsl:call-template name="newlink"/>
		<xsl:if test='*[contains(@class," map/topicref ")]'>
			<ul>
				<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
			</ul>
		</xsl:if>
		<!-- after the link, echo some attribute info about the element -->
		<!--xsl:call-template name="ref-adorn"/-->
	</li>
</xsl:template>


</xsl:stylesheet>