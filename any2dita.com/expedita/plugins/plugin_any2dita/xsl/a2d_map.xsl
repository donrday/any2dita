<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	>
  
<!-- utilities for the php interaction -->

<xsl:param name="outmode">nav</xsl:param>

	<!-- drop the processing into the first document element  and pass in the mode -->
	<xsl:template match='/' >
		<xsl:apply-templates/>
	</xsl:template>
	


<!-- markup conversion: map elements -->

	<!-- =============map=============== -->
	<!-- 
		Pass navtitle content into the HTML editor as if it were element content.
		This makes it plainly editable! The editor has a link dialog already, so don't bother with href. 
	-->
	<xsl:template name='map' match='*[contains(@class," map/map ")]'>
		<!-- the top-level title inherits whatever is the display default for the current context (post, commonly) -->
		<xsl:element name="h{$headlevel1}">
			<xsl:attribute name="data-class"><xsl:value-of select="local-name(parent::*)"/><xsl:value-of select="local-name(.)"/></xsl:attribute>
			<xsl:if test='not($headclass1 = "")'>
				<xsl:attribute name="class">
					<xsl:value-of select=" $headclass1"/>
				</xsl:attribute>
			</xsl:if>
	 		<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:if test='@xml:lang'>
				<xsl:attribute name="lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test='@title'>
					<xsl:value-of select='@title'/>
				</xsl:when>
				<xsl:when test='title'>
					<xsl:apply-templates select='title' mode='once'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Default map title</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:apply-templates select='*[contains(@class," map/topicmeta ")]'/>
		<ul>
			<xsl:apply-templates select='topicref|topichead|topicgroup'/>
		</ul>
		<xsl:apply-templates select='navref|anchor|reltable|data|data-about'/>
	</xsl:template>

	<xsl:template match='*[contains(@class," map/map ")]/*[contains(@class," topic/title ")]' mode='once'>
		<xsl:apply-templates/>
	</xsl:template>


	<xsl:template match='navref|anchor|data|data-about|reltable'>
		<!-- How would these behave in a live scenario? they seem out of scope for expedita ATM. -->
	</xsl:template>

	<!-- =============common map content=============== -->

	<xsl:template match='*[contains(@class," map/topicref ")]'>
		<li class='topicref'>
			<xsl:call-template name="rpclink"/>
		</li>
	</xsl:template>

	<xsl:template name="altlink">
		<a>
			<xsl:attribute name='href'>
				<xsl:value-of select='$queryPath'/><xsl:value-of select='@href'/>
			</xsl:attribute>
			<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:choose>
				<xsl:when test="@navtitle">
					<xsl:value-of select="@navtitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- force a value so that the element is not left empty. -->
					<!--{navigation title for: <xsl:value-of select="@href"/>}-->
					<!-- For low oops function, just silently fill this for now. -->
					<xsl:value-of select="document(@href)/*/title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="rpclink">
		<a target="_blank"><!-- @scope is irrelevant in this previewer; for this render case, we want a new window.-->
			<xsl:attribute name='href'>?tab=admin&amp;xform=<xsl:value-of select='$targPath'/>/<xsl:value-of select='@href'/>
			</xsl:attribute>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:choose>
				<xsl:when test="@navtitle">
					<xsl:value-of select="@navtitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- force a value so that the element is not left empty. -->
					<!--{navigation title for: <xsl:value-of select="@href"/>}-->
					<!-- For low oops function, just silently fill this for now. -->
					<xsl:value-of select="document(concat('..../../',$targPath,@href),.)/*/title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</a>
	</xsl:template>

	<xsl:template match='*[contains(@class," mapgroup-d/topicgroup ")]'>
		<li class='topicgroup'>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," mapgroup-d/topichead ")]'>
		<li class='topichead'>
			<xsl:value-of select="@navtitle"/>
			<xsl:if test='*[contains(@class," map/topicref ")]'>
				<ul>
					<xsl:apply-templates select='*[contains(@class," map/topicref ")]'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," map/topicmeta ")]'>
		<xsl:if test='@navtitle'>
			<div class='topicmeta'>
				<b><xsl:value-of select="@navtitle"/></b><br/>
			</div>
		</xsl:if>
	</xsl:template>
	

	<!-- Related Links -->

	<xsl:template match='*[contains(@class," topic/related-links ")]'>
		<xsl:choose>
			<xsl:when test="1 = 0"><!-- skip for now -->
				<div>
					<!--h4>Related Insights</h4-->
					<xsl:apply-templates select='*[contains(@class," topic/title ")]' mode="label"/>
					<ul>
						<xsl:apply-templates/>
					</ul>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<!-- related links should be configurable, not compulsive -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='topicref' match='*[contains(@class," topic/link ")]'>
		<li class='topicref nav'>
			<xsl:call-template name="newlink"/>
			<xsl:apply-templates select='*[contains(@class," topic/desc ")]'/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/llink ")]'>
		<li>
			<a href='{@href}'>
				<xsl:choose>
					<xsl:when test='@scope = "external"'>
						<xsl:attribute name='target'>_new</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test='linktext'>
						<xsl:apply-templates select='linktext'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select='@href'/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
			<xsl:apply-templates select='*[contains(@class," topic/desc ")]'/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/linklist ")]' mode="null">
		<li>
			<xsl:apply-templates select='*[contains(@class," topic/title ")]' mode="label"/>
			<xsl:apply-templates select='*[contains(@class," topic/desc ")]'/>
			<xsl:if test='link|linklist'>
				<ol>
					<xsl:apply-templates select='*[contains(@class," topic/link ")]|*[contains(@class," topic/linklist ")]'/>
				</ol>
			</xsl:if>
			<xsl:apply-templates select='*[contains(@class," topic/linkinfo ")]'/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/linkinfo ")]'>
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/linktext ")]'>
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- This is a replacement for the PHP-based transform in doSidebar.php, built by passing a subset to transform in t2h from extract_keywords.php -->
	<xsl:template match='*[contains(@class," topic/linklist ")]'>
		<h4><xsl:apply-templates select='*[contains(@class," topic/title ")]' mode="label"/></h4>
		<ul class="ui">
			<xsl:for-each select='*[contains(@class," topic/link ")]'>
				<xsl:variable name="format"><xsl:value-of select="@format"/></xsl:variable>
				<xsl:variable name="href"><xsl:value-of select="substring-before(@href,'.')"/></xsl:variable>
				<!-- $href = strip_ext($href); -->
				<xsl:variable name="resource-fn">
					<xsl:value-of select="substring-before($href,'.')"/>
				</xsl:variable>
			<li style='margin-bottom:0;'>
				<a style='text-decoration:none;' href='{$serviceType}/topic/{$href}'><xsl:value-of select="linktext/text()"/></a>
			</li>
			</xsl:for-each>
		</ul>
		<xsl:apply-templates select='*[contains(@class," topic/linkinfo ")]'/>
	</xsl:template>

<!-- common utility for all topicref links -->

<xsl:template name="newlink">
	<xsl:variable name="fixedhref">
		<xsl:choose>
			<xsl:when test="contains(@href,'http://')">
				<!-- The href value is already presumeably a standard URL that was authored compliantly. -->
				<xsl:value-of select="@href"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- The standard file-based href source conventions need to be normalized per the API syntax. -->
				<!-- strip the extension off the href attribute -->
				<!-- parse the href so that we can peek here and there -->
				<xsl:variable name='path'>
					<xsl:choose>
						<xsl:when test='contains(@href,"#") and (substring-before(@href,"#")="")'>
							<xsl:value-of select='substring-before(@href,"#")'/>
						</xsl:when>
						<xsl:when test='contains(@href,"#")'>
							<xsl:value-of select='substring-before(@href,"#")'/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select='@href'/>
						</xsl:otherwise>
					</xsl:choose>		
				</xsl:variable>
				<xsl:variable name="resource-fn">
					<xsl:value-of select="substring-before($path,'.')"/>
				</xsl:variable>
				<!-- normalize any nested path by converting path separator / into a period . -->
				<!-- 16 Dec 2011 DRD: reverted the dotted-href logic so that we can try traversing folders normally -->
				<xsl:variable name="dotted-href">
					<xsl:value-of select='$resource-fn'/>
				<!--
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text" select="$resource-fn" />
						<xsl:with-param name="replace" select="'/'" />
						<xsl:with-param name="by" select="'.'" />
					</xsl:call-template>
				-->
				</xsl:variable>
				<!-- The groupName and mapName values were passed in by the calling context (known context) -->
				<xsl:text>resource</xsl:text>/<xsl:value-of select="$groupName"/>/<xsl:value-of select="$mapName"/>/<xsl:value-of select="$dotted-href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<a class="a nav" href='{$fixedhref}'>
		<xsl:if test='@scope'><xsl:attribute name='target'><xsl:value-of select='@scope'/></xsl:attribute></xsl:if>
		<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<span class="navtitle">
			<xsl:choose>
				<xsl:when test="@navtitle">
					<xsl:value-of select="@navtitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- force a value so that the element is not left empty. -->
					<span style="color:red;">(no navtitle) <xsl:value-of select="@href"/></span>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</a>
</xsl:template>




</xsl:stylesheet>