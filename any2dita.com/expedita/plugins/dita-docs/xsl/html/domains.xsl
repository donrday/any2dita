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
 
 Some semantic HTML:
<i>	italicized for semantics not otherwise represented in HTML
<b> bold for semantics not otherwise represented in HTML
<em>	Renders as emphasized text
<strong>	Defines important text
<dfn>	Defines a definition term
<code>	Defines a piece of computer code
<samp>	Defines sample output from a computer program
<kbd>	Defines keyboard input
<var>	Defines a variable
 '-->
<xsl:stylesheet
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:php="http://php.net/xsl"
    xsl:extension-element-prefixes="php"
	exclude-result-prefixes="php" 
>


<xsl:strip-space elements="menucascade uicontrol shortcut"/>


<!-- hi domain -->

	<xsl:template match='*[contains(@class," topic/ph hi-d/b ")]'>
		<strong>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</strong>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ph hi-d/i ")]'>
		<em>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</em>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/ph hi-d/sup ")]'>
		<sup>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ph hi-d/sub ")]'>
		<sub>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ph hi-d/tt ")]'>
		<tt>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</tt>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ph hi-d/u ")]'>
		<u>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</u>
	</xsl:template>

<!-- /hi domain -->

<!-- pr domain ()
apiname
codeblock
coderef
codeph
option
parmname
parml (plentry) (one or more)
plentry
pt
pd
synph ( text data or codeph or delim or kwd or oper or option or parmname or sep or synph or text or var) (any number)
syntaxdiagram ( (title) (optional) then (fragment or fragref or groupchoice or groupcomp or groupseq or synblk or synnote or synnoteref) (any number) )
groupseq
groupchoice
groupcomp
fragment
fragref
synblk
synnote
synnoteref
kwd
var
oper
delim
sep
repsep
 -->
	<xsl:template match='*[contains(@class," topic/keyword pr-d/apiname ")]'>
		<span class='apiname'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/pre pr-d/codeblock ")]'>
		<!--  class='codeblock' xml:space="preserve" DRD: need to see why the intended class is not displaying properly -->
		<pre class="codeblock">
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
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<!-- php/libxslt equivalent of DITA 1.2 coderef element derived from xref -->
	<xsl:template match='*[contains(@class," topic/xref ")][@outputclass = "coderef"]'>
<xsl:call-template name="check-rev"/>
<!--atts that may apply: href, type, format, scope -->
<xsl:value-of select="php:function('text2xml',string(@href))"/>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ph pr-d/codeph ")]'>
		<code>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</code>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/keyword pr-d/option ")]'>
		<span class="option">
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/keyword pr-d/parmname ")]'>
		<span class='parmname'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dl pr-d/parml ")]'>
		<dl class="parml">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</dl>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dlentry pr-d/plentry ")]'>
		<div class="plentry">
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dt pr-d/pt ")]'>
		<dt class='pt'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/dd pr-d/pd ")]'>
		<dd class='pd'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

<!-- syntaxdiagram -->
	<xsl:template match='*[contains(@class," topic/fig pr-d/syntaxdiagram ")]'>	
		<div style="border:thin black solid;padding;10px;">
			<xsl:apply-templates select="title"/>
			&gt;&gt;-<xsl:apply-templates select="node()[name() != 'title']"/>-&gt;&lt;
		</div>
	</xsl:template>
	
<!-- groupseq -->
	<xsl:template match='*[contains(@class," topic/figgroup pr-d/groupseq ")]'>	
		<div style="display:inline;border:thin black solid;padding;10px;">
			<xsl:text>  </xsl:text><xsl:apply-templates/><xsl:text>  </xsl:text>
		</div>
	</xsl:template>
	
<!-- groupchoice -->
	<xsl:template match='*[contains(@class," topic/figgroup pr-d/groupchoice ")]'>	
		<div style="display:inline-block;border:thin black solid;padding;10px;">
			<xsl:text>'-</xsl:text><xsl:apply-templates/><xsl:text>-'</xsl:text>
		</div>
	</xsl:template>
	
<!-- groupcomp -->
<!-- fragment -->
<!-- fragref -->
<!-- synblk -->
<!-- synnote -->
<!-- synnoteref -->
	
<!-- synph -->
	<xsl:template match='*[contains(@class," topic/ph pr-d/synph ")]'>
		<span>
			<xsl:attribute name="class">
				<xsl:if test='@outputclass'><xsl:value-of select="concat(@outputclass,' ')"/></xsl:if>
				<xsl:text>synph</xsl:text>
			</xsl:attribute>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<!-- kwd -->
	<xsl:template match='kwd | *[contains(@class," topic/keyword pr-d/kwd ")]'>
		<span>
			<xsl:attribute name="class">
				<xsl:if test='@outputclass'><xsl:value-of select="concat(@outputclass,' ')"/></xsl:if>
				<xsl:text>kwd</xsl:text>
			</xsl:attribute>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<!-- var -->
	<xsl:template match='*[contains(@class," topic/ph pr-d/var ")]'>
		<span>
			<xsl:attribute name="class">
				<xsl:if test='@outputclass'><xsl:value-of select="concat(@outputclass,' ')"/></xsl:if>
				<xsl:text>var</xsl:text>
			</xsl:attribute>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<!-- oper -->
	<xsl:template match='*[contains(@class," topic/ph pr-d/oper ")]'>
		<span>
			<xsl:attribute name="class">
				<xsl:if test='@outputclass'><xsl:value-of select="concat(@outputclass,' ')"/></xsl:if>
				<xsl:text>oper</xsl:text>
			</xsl:attribute>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<!-- delim -->
	<xsl:template match='*[contains(@class," topic/ph pr-d/delim ")]'>
		<span>
			<xsl:attribute name="class">
				<xsl:if test='@outputclass'><xsl:value-of select="concat(@outputclass,' ')"/></xsl:if>
				<xsl:text>delim</xsl:text>
			</xsl:attribute>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<!-- sep -->
	<xsl:template match='*[contains(@class," topic/ph pr-d/sep ")]'>
		<span>
			<xsl:attribute name="class">
				<xsl:if test='@outputclass'><xsl:value-of select="concat(@outputclass,' ')"/></xsl:if>
				<xsl:text>sep</xsl:text>
			</xsl:attribute>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<!-- repsep -->
	<xsl:template match='*[contains(@class," topic/ph pr-d/repsep ")]'>
		<span>
			<xsl:attribute name="class">
				<xsl:if test='@outputclass'><xsl:value-of select="concat(@outputclass,' ')"/></xsl:if>
				<xsl:text>repsep</xsl:text>
			</xsl:attribute>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>



	
<!-- /pr domain -->

<!-- ui domain -->
	<xsl:template match='*[contains(@class," topic/ph ui-d/uicontrol ")]'>	
		<b class="uicontrol" >
    <xsl:apply-templates/>
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/keyword ui-d/wintitle ")]'>	
		<b class="wintitle">
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ph ui-d/menucascade ")]'>	
	  <ph>
	    <xsl:call-template name='check-rev'/>
	    <xsl:for-each select='uicontrol'>
	      <b><xsl:apply-templates/></b>
	      <xsl:if test='position() != last()'> &gt; </xsl:if>
	    </xsl:for-each>
	  </ph>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/keyword ui-d/shortcut ")]'>
		<span class="shortcut" style="text-decoration:underline">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/pre ui-d/screen ")]'>
		<pre class='screen'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

<!-- /ui domain -->

<!-- sw domain (msgph, msgblock, msgnm, cmdname, varname, filepath) -->

	<xsl:template match='*[contains(@class," sw-d/msgph ")]'>
		<span class='msgph'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='*[contains(@class," sw-d/msgblock ")]'>
		<pre class="msgblock">
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<xsl:template match='*[contains(@class," sw-d/msgnum ")]'>
		<span class='msgnum'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='*[contains(@class," sw-d/cmdname ")]'>
		<span class='cmdname'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match='*[contains(@class," sw-d/varname ")]'>
		<var class='varname'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</var>
	</xsl:template>

	<xsl:template match='*[contains(@class," sw-d/filepath ")]'>
		<span class='filepath'>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<xsl:template match='*[contains(@class," sw-d/userinput ")]'>
  <kbd>
    <xsl:call-template name='check-rev'/>
    <xsl:apply-templates/>
  </kbd>
</xsl:template>

<xsl:template match='*[contains(@class," sw-d/systemoutput ")]'>
  <samp>
    <xsl:call-template name='check-rev'/>
    <xsl:apply-templates/>
  </samp>
</xsl:template>
<!-- /sw domain -->

<!-- ut domain -->
	<xsl:template match='*[contains(@class," topic/fig ut-d/imagemap ")]'>
		<map name='{@id}'>
			<xsl:for-each select='*[contains(@class," ut-d/area ")]'>
				<area>
					<xsl:variable name="resolvedURL">
						<xsl:if test='*[contains(@class," topic/xref ")]/@format = "pdf"'><xsl:value-of select='$contentPath'/>/</xsl:if>
						<xsl:value-of select='*[contains(@class," topic/xref ")]/@href'/>
					</xsl:variable>
					<xsl:attribute name='href'>
						<!-- need to support more xref logic for non-DITA and internal links; can we call xref logic? 
						<xsl:value-of select='$contentPath'/>/<xsl:value-of select='$resolvedURL'/>
						-->
						<xsl:value-of select='$resolvedURL'/>
					</xsl:attribute>
					<xsl:attribute name='shape'><xsl:value-of select='*[contains(@class," ut-d/shape ")]'/></xsl:attribute>
					<xsl:attribute name='coords'><xsl:value-of select='*[contains(@class," ut-d/coords ")]'/></xsl:attribute>
				</area>
			</xsl:for-each>
		</map>
		<xsl:apply-templates select='*[contains(@class," topic/image ")]'/>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," ut-d/area ")]/*[contains(@class," topic/xref ")]'/>

	<xsl:template match='*[contains(@class," topic/figgroup ut-d/area ")]'/>
	
	<xsl:template match='*[contains(@class," topic/keyword ut-d/shape ")]'/>
	
	<xsl:template match='*[contains(@class," topic/ph ut-d/coords ")]'/>

<!-- /ut domain -->


</xsl:stylesheet>