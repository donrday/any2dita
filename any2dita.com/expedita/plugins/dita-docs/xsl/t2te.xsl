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
<xsl:output method="html" encoding="utf-8" indent="no" omit-xml-declaration="yes"/>
<!--xsl:output method="xml"
            indent="yes"
            encoding="utf-8"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
/-->
	
	<!--xsl:strip-space elements="body map"/-->
	<xsl:preserve-space elements="pre,screen,lines"/>
  
  
<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>
  
<!-- utilities for the php interaction -->

<!-- markup conversion: topic elements -->

<!-- (stoplist of container elements that interrupt a "by-paragraph" based edit workflow -->
<xsl:template match='prolog|metadata|othermeta|dita|topic|body|concept|conbody|task|taskbody|reference|refbody'>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="/">
	<div style="text-align:left; color:darkred">Form-based DITA editor for type "<xsl:value-of select="name(*[1])"/>"</div>
	<form method='post' action='editform'>
		<table border="0" width="600">
		<!-- Note that in expeDITA, the UI items commented out here normally are inserted as part of the call for this editor.
			<tr>
				<td class="d2component"><xsl:comment> this is the application's header area </xsl:comment><i>header:</i></td>
				<td class="d2header">
					<input value="Save" type="button" onclick="saveContent('DictateTask')"/><xsl:text> - </xsl:text>;
					<input style="color:gray;" value="Load" type="button" onclick="loadContent('EditTask')"/><xsl:text> - </xsl:text>;
					<input value="Help" type="button" onclick="showPage('Editor Help')"/><xsl:text> - </xsl:text>
					<input value="About" type="button" onclick="showPage('About')"/>
					<hr/>
				</td>
			</tr>
			-->
			<xsl:apply-templates/>
			<!--
			<tr>
				<td class="d2component"><xsl:comment> this is the application's footer area </xsl:comment><i>footer:</i></td>
				<td class="d2footer"><hr/>Concept by Learning by Wrote</td>
			</tr>
			-->
		</table>
	</form>
</xsl:template>

<!-- general handing for any element not specifically mapped for here -->
<xsl:template match="*">
	<tr type="unknown">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Unknown')" value="{name()}"/><br/>
				<span onClick="insaf('null')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><span style="color:darkred;">(<xsl:value-of select="name()"/>)</span><xsl:text>  </xsl:text><xsl:apply-templates/></td>
	</tr>
</xsl:template>


<xsl:template match='*[contains(@class," topic/title ")]'>
	<tr type="title">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onClick="if(confirm('Delete this component?'))
alert('Consider this component zapped.');
else myEdit('title')" value="title"/><br/>
				<span onClick="insaf('para_shortdesc')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><h1><xsl:value-of select='.'/></h1>
		</td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/p ")]'>
	<tr type="p">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('p ul ol lq')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Paragraph')" value="p"/><br/>
				<span onClick="insaf('p ul ol lq')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><p><xsl:apply-templates/></p> </td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/note ")]'>
	<tr type="note">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('p ul ol lq note')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Note')" value="note"/><br/>
				<span onClick="insaf('p ul ol lq note')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content">
			<hr/><p><b>Type:</b>
				<select>
					<option><xsl:value-of select="@type"/></option>
					<option>Note</option>
					<option>Tip</option>
					<option>Remember</option>
					<option>Fastpath</option>
					<option>Restriction</option>
					<option>Other</option>
				</select>
				<br/>
				<xsl:apply-templates/>
			</p> 
		</td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]'>
	<tr type="title">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onClick="if(confirm('Delete this component?'))
alert('Consider this component zapped.');
else myEdit('title')" value="title"/><br/>
				<span onClick="insaf('para_shortdesc')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content">
			<xsl:element name="h3">
				<xsl:value-of select='.'/>
			</xsl:element>
		</td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/shortdesc ")]'>
	<tr type="shortdesc">
		<td class="d2component" type="shortdesc">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Shortdesc')" value="shortdesc"/><br/>
				<span onClick="insaf('null')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content" style="background-color:#F9F9F9;"><xsl:apply-templates/></td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," topic/pre ")]'>
	<tr type="prre">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('p ul ol lq pre')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Pre')" value="pre"/><br/>
				<span onClick="insaf('p ul ol lq pre')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content">
			<br/><b>Active editing region, textarea submode:</b><br/>
			<textarea class="d2data" rows="4" cols="60" name="get_data" style="font-family:monospace;"><xsl:value-of select="."/></textarea><br/>
		</td>
	</tr>
</xsl:template>


<!-- inlines -->

	<xsl:template match='*[contains(@class," hi-d/ii ")]'>
		<i><xsl:apply-templates/></i>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/image ")][@placement = "inline"]'>
		<img src="@href"><xsl:apply-templates/></img>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/image ")][@placement = "break"]'>
		<div><img src="@href"><xsl:apply-templates/></img></div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ph ")]'>
		<span class="ph" style="color:purple;"><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/q ")]'>
		<span class="q" style="color:darkgreen;">"<xsl:apply-templates/>"</span>
	</xsl:template>


<!-- =======================task specific========================== -->

<xsl:template match="task/shortdesc">
	<tr type="shortdesc">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onClick="if(confirm('Delete this component?'))
alert('Consider this component zapped.');
else myEdit('shortdesc')" value="shortdesc"/><br/>
				<span onClick="insaf('context step')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><xsl:apply-templates/></td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," task/prereq ")]'>
	<tr type="prereq">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onClick="if(confirm('Delete this component?'))
alert('Consider this component zapped.');
else myEdit('prereq')" value="prereq"/><br/>
				<span onClick="insaf('context')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><xsl:apply-templates/></td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," task/context ")]'>
	<tr type="context">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onClick="if(confirm('Delete this component?'))
alert('Consider this component zapped.');
else myEdit('context')" value="context"/><br/>
				<span onClick="insaf('step')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><xsl:apply-templates/></td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," task/step ")]'>
	<tr type="step">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('prereq')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Step')" value="step"/><br/>
				<span onClick="insaf('step result')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><li><xsl:apply-templates/></li> </td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," task/step ")][1]'>
	<tr type="step">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('prereq')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Step')" value="step"/><br/>
				<span onClick="insaf('step result')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content">
			<br/><b>Active editing region, rich text submode:</b><br/>
			<li><div id="edit1" class="d2data" contentEditable="True"><xsl:apply-templates mode="richtext"/></div></li>
		</td>
	</tr>
</xsl:template>

<xsl:template match='*[contains(@class," task/cmd ")]' mode="richtext">
	<b class="cmd"><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match='*[contains(@class," sw-d/userinput ")]' mode="richtext">
	<tt class="userinput"><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match='*[contains(@class," task/tutorialinfo ")]' mode="richtext">
	<p class="tutorialinfo"><span style="background-color:silver; font-size:smaller; font-weight:bold;">[tutorial info]</span> <xsl:apply-templates/></p>
</xsl:template>

<xsl:template match='*[contains(@class," task/stepxmp ")]'>
	<tr type="stepxmp">
		<td class="d2component" type="result">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Stepxmp')" value="stepxmp"/><br/>
				<span onClick="insaf('step')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><xsl:apply-templates/></td>
	</tr>
</xsl:template>


<xsl:template match='*[contains(@class," task/result ")]'>
	<tr type="result">
		<td class="d2component" type="result">
			<div class="d2control">
				<span onClick="insbf('step')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onclick="myEdit('Result')" value="result"/><br/>
				<span onClick="insaf('null')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><xsl:apply-templates/></td>
	</tr>
</xsl:template>


<xsl:template match='*[contains(@class," task/postreq ")]'>
	<tr type="postreq">
		<td class="d2component">
			<div class="d2control">
				<span onClick="insbf('null')"><xsl:text>+ </xsl:text>before</span><br/>
				<input type="button" onClick="if(confirm('Delete this component?'))
alert('Consider this component zapped.');
else myEdit('postreq')" value="postreq"/><br/>
				<span onClick="insaf('null')"><xsl:text>+ </xsl:text>after</span>
			</div>
		</td>
		<td class="d2content"><xsl:apply-templates/></td>
	</tr>
</xsl:template>

<!-- ================================================= -->



</xsl:stylesheet>