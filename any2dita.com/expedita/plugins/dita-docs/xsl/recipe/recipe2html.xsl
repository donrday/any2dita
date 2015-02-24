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
>


	<xsl:template match='*[contains(@class," recipe/recipe ")]'><!-- presume mode of embedded in map context where it is section-like -->
		<article>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
		    <xsl:apply-templates select='*[contains(@class," topic/title ")]'/>
		    <xsl:apply-templates select='*[contains(@class," recipe/recipeinfo ")]' mode="rendermeta"/><!-- pull in as content -->
			<xsl:apply-templates select='*[contains(@class," recipe/recipebody ")]'/>
		</article>
	</xsl:template>

	<!-- use mode to qualify this call; makes explicit that we want this polog content to render -->
	<xsl:template match='*[contains(@class," recipe/recipeinfo ")]' mode="rendermeta">
		<ul>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/author ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<b>Author: </b>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/recipesource ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<b>Source: </b>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/genre ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<b>Genre: </b>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/blurb ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<b>Blurb: </b>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/yield ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<b>Yield: </b>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/preptime ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<b>Preparation Time: </b>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/effort ")]'>
		<li>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<b>Effort: </b>
			<xsl:apply-templates/>
		</li>
	</xsl:template>


	<xsl:template match='*[contains(@class," recipe/ingredientlist ")]'>
			<h2>Ingredient List: </h2>
		<table>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/ingredient ")]'>
		<tr>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/quantity ")]|*[contains(@class," recipe/unit ")]|*[contains(@class," recipe/fooditem ")]'>
		<td>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/preparation ")]'>
		<section>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<h2>Preparation: </h2>
			<xsl:apply-templates/>
		</section>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/step ")]'>
		<p>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<b><xsl:number/></b><xsl:text>. </xsl:text>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/serving ")]'>
		<section>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<h2>Serving: </h2>
			<xsl:apply-templates/>
		</section>
	</xsl:template>

	<xsl:template match='*[contains(@class," recipe/notes ")]'>
		<section>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
			<h2>Notes: </h2>
			<xsl:apply-templates/>
		</section>
	</xsl:template>


</xsl:stylesheet>
