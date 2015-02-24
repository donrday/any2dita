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

<!-- Common utilities that can be used by DITA transforms -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- from Mike Brown recommendation, http://www.biglist.com/lists/xsl-list/archives/200008/msg01318.html -->
<!--
	given the info needed to produce a set of candidates ($str),
	pick the best of the bunch:
	1. $str[lang($Lang)][1]
	2. $str[lang($PrimaryLang)][1]
	3. $str[1]
	4. if not($str) then issue warning to STDERR
-->
<xsl:template name="getString">
  <xsl:param name="stringName"/>
  <xsl:variable name="str" select="$StringFile/strings/str[@name=$stringName]"/>
  <xsl:choose>
    <xsl:when test="$str[lang($Lang)]">
      <xsl:value-of select="$str[lang($Lang)][1]"/>
    </xsl:when>
    <xsl:when test="$str[lang($PrimaryLang)]">
      <xsl:value-of select="$str[lang($PrimaryLang)][1]"/>
    </xsl:when>
    <xsl:when test="$str">
      <xsl:value-of select="$str[1]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="no">
        <xsl:text>Warning: no string named '</xsl:text>
        <xsl:value-of select="$stringName"/>
        <xsl:text>' found.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

 <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


<!-- Process standard attributes that may appear anywhere. Previously this was "setclass" -->
<xsl:template name="commonattributes">
  <xsl:apply-templates select="@xml:lang"/>
  <xsl:apply-templates select="@dir"/>
  <!--
  <xsl:param name="default-output-class"/>
  <xsl:apply-templates select="." mode="set-output-class">
    <xsl:with-param name="default" select="$default-output-class"/>
  </xsl:apply-templates>
  -->
</xsl:template>

<xsl:template name="add-user-link-attributes">
  <!-- stub for user values -->
</xsl:template>


<xsl:template name='check-atts'>
	<!-- The id process is nulled out for now; we are handling id usage case by case for better HTML5 compliance. -->
	<xsl:if test="@xid"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
	<xsl:if test="@outputclass">
		<xsl:attribute name="class"><xsl:value-of select="@outputclass"/><xsl:text> </xsl:text><xsl:value-of select="name(.)"/></xsl:attribute>
		<!-- DITA OT defers this so as to collect all operations that might create additional value for @class. Study. -->
		<xsl:variable name="outputclass">
			<xsl:value-of select="@outputclass"/>
			<xsl:if test='1 = 1'><!-- add a parameter switch to enable writing element name to the class value -->
				<xsl:text> </xsl:text><xsl:value-of select="name(.)"/>
			</xsl:if>
		</xsl:variable>
	</xsl:if>
	<xsl:if test="@base">
		<!-- test this from elsewhere to check for values to copy into the HTML's metadata (ie, UX control values) -->
	</xsl:if>
	<xsl:if test="@props">
		<!-- as a specialization base, not clear if we'll ever encounter it in this plain form -->
	</xsl:if>
	<xsl:if test="@otherprops">
		<!-- parse the string to add multiples into selection scope -->
	</xsl:if>
	<!-- generate HTML5 versions of selectatts; need to use a switch to handle XHTML differently. -->
	<xsl:if test="@product">
		<xsl:attribute name="data-product"><xsl:value-of select="@product"/></xsl:attribute>
	</xsl:if>
	<xsl:if test="@platform">
		<xsl:attribute name="data-platform"><xsl:value-of select="@platform"/></xsl:attribute>
	</xsl:if>
	<xsl:if test="@audience">
		<xsl:attribute name="data-audience"><xsl:value-of select="@audience"/></xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template name='check-rev'>
	<!-- Apply all flagging logic here. Filtering would be done in "pre-process" stage.) -->
	<!-- Parse $conditionalRules by ';' to extract and apply multiples of dv_att, dv_val and dv_action  -->
	<!-- Got the variable attribute syntax from: http://stackoverflow.com/questions/6050044/how-do-i-pass-a-xml-attribute-to-xslt-parameter?rq=1 -->
	<xsl:variable name="propnames"><xsl:apply-templates select="@*" mode="qualifyprops"/></xsl:variable>

	<!-- Generate embedded cues for processing. -->
	<xsl:if test="not($propnames = '')"><!-- If there were candidate properties ... -->
		<xsl:if test="not($conditionalRules = '')"><!-- and there is a possibly applicable conditionalRules set ... -->
			<!--then call split-prop to test for a match. -->
			<!--
			<xsl:attribute name="data-propnames"><xsl:value-of select="$propnames"/></xsl:attribute>
			<xsl:attribute name="data-condrules"><xsl:value-of select="$conditionalRules"/></xsl:attribute>
			-->
			<xsl:call-template name="split-prop">
				<xsl:with-param name="input" select="$conditionalRules" />
				<xsl:with-param name="marker" select="';'" />
			</xsl:call-template>
		</xsl:if>
	</xsl:if>

	<!-- This data-props attribute is only for testing; comment it out for production use.
		Generates eg data-props="audience outputclass " to verify what actionable properties are in the element.-->
	<!--
	<xsl:if test="not($propnames = '')">
		<xsl:attribute name="data-props"><xsl:value-of select='$propnames'/></xsl:attribute>
	</xsl:if>
	-->

	<!-- Now we need to enable choices for foreground vs background color, underlines, bold, text, image, etc. -->
</xsl:template>

<!-- Check each attname against whitelist of allowed property attribute names; add it if qualified -->
<!-- I am testing the common assertion that ANY of the select atts are fair game for conditional use. -->
<!-- use ' ' delimiters to keep from matching 'class' in 'outputclass' for example. -->
<xsl:template match="@*" mode="qualifyprops">
	<xsl:if test="contains(' outputclass props base platform product audience otherprops importance rev status ',concat(' ',name(),' '))">
		<xsl:value-of select="name()"/><xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>


<!-- recursive template to emulate php explode(';', $string) function -->
<!-- Here is where the actual match of an element's attributes to a supplied condition is made. -->
<xsl:template name="split-prop">
	<xsl:param name="input" />
	<xsl:param name="marker" />
	<xsl:param name="propslist"/>
	<xsl:if test="string-length($input)">
		<!-- For each property in the incoming set of conditions... -->
			<xsl:variable name="prop"><xsl:value-of select="substring-before(concat($input,$marker),$marker)"/></xsl:variable>
			<xsl:variable name="dv_att"><xsl:value-of select='substring-before($prop,":")'/></xsl:variable>
			<xsl:variable name="dv_val"><xsl:value-of select="substring-before(substring-after($prop, ':'), ':')"/></xsl:variable>
			<xsl:variable name="dv_action">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$prop" />
					<xsl:with-param name="marker" select="':'" />
				</xsl:call-template>
			</xsl:variable>
				<!-- inject the data for use downstream -->
		        <!--xsl:attribute name="data1">elname:<xsl:value-of select="name()"/></xsl:attribute-->
		        <!--
		        <xsl:attribute name="data2">att:<xsl:value-of select="$dv_att"/></xsl:attribute>
		        <xsl:attribute name="data3">val:<xsl:value-of select="$dv_val"/></xsl:attribute>
		        <xsl:attribute name="data4">action:<xsl:value-of select="$dv_action"/></xsl:attribute>
		        -->
			<!-- If $dv_val is found in the attribute whose name is equal to $dv_att  then... (we have a valid conditional match) -->
			<xsl:if test="contains(@*[name()=$dv_att], $dv_val)">
		        <!-- then set the style attribute based on provided actions (usually included style properties). -->
				<!-- These are pre-defined actions for now; need to read these from the ditaval. -->
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test='$dv_action = "include"'>
							<xsl:text>background-color:seashell;</xsl:text>
						</xsl:when>
						<xsl:when test='$dv_action = "exclude"'><!--display:none;-->
							<xsl:text>display:none;border:thin red solid;text-decoration: line-through;</xsl:text>
						</xsl:when>
						<xsl:when test='$dv_action = "flag"'>
							<xsl:choose>
								<xsl:when test='$dv_val = "247"'>
									<xsl:text>color:thistle;</xsl:text>
								</xsl:when>
								<xsl:when test='$dv_val = "nop"'>
									<xsl:text>color:#cc99ff;</xsl:text>
								</xsl:when>
								<xsl:when test='$dv_val = "mdp"'>
									<xsl:text>color:#ff6600;</xsl:text>
								</xsl:when>
								<xsl:when test='$dv_val = "mp"'>
									<xsl:text>color:#339966;</xsl:text>
								</xsl:when>
								
								<xsl:when test='$dv_val = "xml"'>
									<xsl:text>color:thistle;</xsl:text>
								</xsl:when>
								<xsl:when test='$dv_val = "dita"'>
									<xsl:text>color:lightsteelblue;</xsl:text>
								</xsl:when>
								<xsl:when test='$dv_val = "cms"'>
									<xsl:text>color:pink;</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>color:lightgrey;</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>background-color:goldenrod;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<!-- Well, although that seems easy now, it was dang hard to come up with the right syntax to pass the att's name into the test! -->
		<!-- -->
		<xsl:call-template name="split-prop">
			<xsl:with-param name="input" select="substring-after($input,$marker)"/>
			<xsl:with-param name="marker" select="';'" />
		</xsl:call-template>
	</xsl:if>
</xsl:template>
 
<xsl:template name="output-tokens">
    <xsl:param name="list" /> 
    <xsl:variable name="newlist" select="concat(normalize-space($list), ' ')" /> 
    <xsl:variable name="first" select="substring-before($newlist, ' ')" /> 
    <xsl:variable name="remaining" select="substring-after($newlist, ' ')" /> 
    <id>
        <xsl:value-of select="$first" /> 
    </id>
    <xsl:if test="$remaining">
        <xsl:call-template name="output-tokens">
                <xsl:with-param name="list" select="$remaining" /> 
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- recursive template to retrieve the substring after the last occurrence of specified pattern -->
<xsl:template name="substring-after-last">
	<xsl:param name="input" />
	<xsl:param name="marker" />
	<xsl:choose>
		<xsl:when test="contains($input,$marker)">
			<xsl:call-template name="substring-after-last">
				<xsl:with-param name="input" select="substring-after($input,$marker)" />
				<xsl:with-param name="marker" select="$marker" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$input" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- primitive support for @rev = 'v1' -->
<xsl:template name='check-rev1'>
 <!-- Image action -->
 <!-- Text action -->
 <!-- Color action -->
<!--
Called for each element.
Build list of properties (associative tables: p:@audience:administrator)
for each attribute:
  for each token in the attribute:
    if (an element's name/value prop intersects with a ditaval's name/value prop) {
	//	Filter action:
	//		if all values in an attribute evaluate to 'exclude' then the attribute evaluates to 'exclude'
	//		if any single attribute evaluates to 'exclude' then the element is excluded
	//	Flag action:
	//		for any value that matches a rule, apply the indicated flag.
	//		for each matching rule, apply the indicated flag (additive behaviors)
	//	Filtering trumps flagging; if an element evaluates as 'exclude' there is no point to filtering.
    }
-->
	<xsl:if test="@platform = 'all'"> <!-- color action -->
		<xsl:attribute name="style">background-color:bluegreen;</xsl:attribute>
	</xsl:if>
	<xsl:if test="@platform = 'dita'"> <!-- color action -->
		<xsl:attribute name="style">background-color:red;</xsl:attribute>
	</xsl:if>
	<xsl:if test="@platform = 'cms'"> <!-- color action -->
		<xsl:attribute name="style">background-color:purple;</xsl:attribute>
	</xsl:if>
	<xsl:if test="@audience = 'technical'"> <!-- flag action -->
		<xsl:attribute name="style">background-color:pink;</xsl:attribute>
	</xsl:if>
	<xsl:if test="@audience = 'all'"> <!-- flag action -->
		<xsl:attribute name="style">background-color:lightblue;</xsl:attribute>
	</xsl:if>
	<xsl:if test="@audience = 'business'"> <!-- flag action -->
		<xsl:attribute name="style">background-color:lightsteelblue;</xsl:attribute>
	</xsl:if>
	
	<xsl:if test="@product = 'extendedprod'"> <!-- exclude action -->
		<xsl:attribute name="style"></xsl:attribute>
	</xsl:if>
<!-- insert images only after attribute adornments -->
	<xsl:if test="@audience = 'administrator'"> <!-- flag action -->
		<img src="{concat($contentPath,'/','important.gif')}" title="ADMIN"/>
	</xsl:if>

	<xsl:if test="@rev = 'v1'">
		<xsl:attribute name="style">background-color:palegreen;</xsl:attribute>
	</xsl:if>
</xsl:template>

<!-- Test UX controls -->

<!-- this item should be in a unique-for-prolog xsl file -->
<xsl:template match='*[contains(@class," topic/metadata ")]' mode='viewprolog'>
<pre>
&lt;script type="text/javascript">
	var JSONObject= {
		<xsl:for-each select="//keyword"> <!-- whitespace before this for-each is significant; do not remove -->
		<xsl:choose> <!-- which of these are common to all pages, which are unique? which are potential last values that don't need a comma? -->
			<xsl:when test="contains(@id, 'pageType')">	type: "<xsl:value-of select="."/>",</xsl:when>
			<xsl:when test="contains(., 'titleON')">title: true,</xsl:when>
			<xsl:when test="contains(., 'titleOFF')">title: false,</xsl:when>
			<xsl:when test="contains(@id, 'pageLayout')">layout: "<xsl:value-of select="."/>"<xsl:if test="exists(following::keywords/keyword/@id)">,</xsl:if></xsl:when>
			<xsl:when test="contains(@id, 'videoType')">video: {type: "<xsl:value-of select="."/>",</xsl:when>
			<xsl:when test="contains(@id, 'videoId')">id: <xsl:value-of select="."/>}<xsl:if test="exists(following::keywords/keyword/@id)">,</xsl:if></xsl:when>
			<xsl:when test="contains(@id, 'interactionType')">interaction: {type: "<xsl:value-of select="."/>",</xsl:when>
			<xsl:when test="contains(@id, 'interactionLayout')">layout: "<xsl:value-of select="."/>"}<xsl:if test="exists(following::keywords/keyword/@id)">,</xsl:if></xsl:when>
			<xsl:when test="contains(@id, 'externalUrl')">external_url: "<xsl:value-of select="."/>"<xsl:if test="exists(following::keywords/keyword/@id)">,</xsl:if></xsl:when>
			<xsl:when test="contains(@id, 'audioFile')">audio: {filename: "<xsl:value-of select="."/>"}<xsl:if test="exists(following::keywords/keyword/@id)">,</xsl:if></xsl:when>
<!--		create test parameters	-->
<!--
			<xsl:when test="contains(@id, 'testScored')">scored: <xsl:value-of select="."/>,</xsl:when>
			<xsl:when test="contains(@id, 'randomQuestions')">random: <xsl:value-of select="."/>,</xsl:when>
			<xsl:when test="contains(@id, 'poolOfQuestions')">pool: <xsl:value-of select="."/>,</xsl:when>
			<xsl:when test="contains(@id, 'totalFromPool')">totalFromPool: <xsl:value-of select="."/>,</xsl:when>
			<xsl:when test="contains(@id, 'feedbackEnabled')">feedback: <xsl:value-of select="."/>,</xsl:when>
			<xsl:when test="contains(@id, 'questionAttemptsAllowed')">questionAttempts: <xsl:value-of select="."/>,</xsl:when>
			<xsl:when test="contains(@id, 'testAttemptsAllowed')">testAttempts: <xsl:value-of select="."/></xsl:when>
			-->
		</xsl:choose>
	</xsl:for-each> 
	};
&lt;/script>
</pre>
</xsl:template>



</xsl:stylesheet>