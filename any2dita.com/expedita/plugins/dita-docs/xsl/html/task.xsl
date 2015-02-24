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
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

	<!-- ideally,  preset a site default for it and also get this from the topic -->
	<xsl:param name="Lang" select="'en-us'"/>
	<!-- layout related -->
	<!-- (ie, set defaults for internal switches -->

	<!-- generated string values (translatable) -->
	<xsl:param name="label-prereq">Before you begin</xsl:param>
	<xsl:param name="label-context">About this task</xsl:param>
	<xsl:param name="label-steps">
		<xsl:call-template name="getString">
			<xsl:with-param name="stringName" select="'Steps'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="label-result">Results</xsl:param>
	<xsl:param name="label-example">Example</xsl:param>
	<xsl:param name="label-section"></xsl:param>
	<xsl:param name="label-postreq">What to do next</xsl:param>
	<xsl:param name="label-refsyn">Syntax</xsl:param>
	<xsl:param name="label-properties">Properties</xsl:param>

	<!-- =============task=============== -->
	<xsl:template name='task' match='*[contains(@class," topic/topic task/task ")]'>
        <xsl:apply-templates select='*[contains(@class," topic/prolog ")]'/>
        <xsl:apply-templates select='*[contains(@class," topic/title ")]' mode='topiccontent'/>
        <xsl:apply-templates select='*[contains(@class," topic/titlealts ")]'/>
        <xsl:apply-templates select='*[contains(@class," topic/shortdesc ")]'/>
        <xsl:apply-templates select='*[contains(@class," topic/body task/taskbody ")]'/>
		<xsl:apply-templates select='*[contains(@class," topic/related-links ")]'/>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/body task/taskbody ")]'>
		<div class='taskbody'>
			<xsl:apply-templates select='*[contains(@class," task/prereq ")]'/>
			<xsl:apply-templates select='*[contains(@class," task/context ")]'/>
			<xsl:apply-templates select='*[contains(@class," task/steps ")]|*[contains(@class," task/steps-unordered ")]'/>
			<xsl:apply-templates select='*[contains(@class," task/result ")]'/>
			<xsl:apply-templates select='*[contains(@class," topic/example ")]'/>
			<xsl:apply-templates select='*[contains(@class," task/postreq ")]'/>
	    </div>
	    <xsl:comment>/taskbody</xsl:comment>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/section task/prereq ")]'>
		<div class='prereq'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		    <xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TASK-LABELS = "yes"'>
		      <xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-prereq"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/section task/context ")]'>
		<div class='context'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		    <xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TASK-LABELS = "yes"'>
		      <xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-context"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ol task/steps ")]'>
		<div class='steps'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		    <xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TASK-LABELS = "yes"'>
		      <xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-steps"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'>
				<ol class="steps">
					<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
					<xsl:apply-templates select="node()[name()!='title']"/>
				</ol>
			</div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ol task/steps-unordered ")]'>
		<div class='steps-unordered'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		    <xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TASK-LABELS = "yes"'>
		      <xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-steps"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'>
				<ul class="steps-unordered">
					<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
					<xsl:apply-templates select="node()[name()!='title']"/>
				</ul>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/section task/result ")]'>
		<div class='result'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		    <xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TASK-LABELS = "yes"'>
		      <xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-result"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>
	
	<!-- a task-specific version of example -->
	<xsl:template match='*[contains(@class," task/taskbody ")]/*[contains(@class," topic/example ")]'>
		<div class='sectionDiv example'>
			<xsl:call-template name="check-atts"/>
			<xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TASK-LABELS = "yes"'>
		      <xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-example"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>
    
	<xsl:template match='*[contains(@class," topic/section task/postreq ")]'>
		<div class='postreq'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		    <xsl:if test='$GENERATE-TASK-LABELS = "yes"'>
		      <xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-postreq"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/li task/step ")]'>
		<li class="step">
			<xsl:if test="name(preceding-sibling::*[1]) = 'stepsection'">
				<!-- resume the numbering on this instance value of this current 'task/step' elements -->
				<xsl:attribute name="value"><xsl:number/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<!--
	Some insight on skip numbering. We turn off the numbering here. See 'task/step' for how we resume the count.
	http://stackoverflow.com/questions/12858130/skip-ordered-list-item-numbering
	-->
	<xsl:template match='*[contains(@class," topic/li task/stepsection ")]'>
		<li class="stepsection" style="list-style-type: none">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/ph task/cmd ")]'>
		<ph class="cmd">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</ph><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/itemgroup task/info ")]'>
		<p class="info">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/itemgroup task/stepxmp ")]'>
		<p class="stepxmp">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/itemgroup task/stepresult ")]'>
		<p class="stepresult">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/ol task/substeps ")]'>
		<div class='substeps'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		    <xsl:call-template name="check-rev"/>
				<ol class="substeps">
					<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
					<xsl:apply-templates/>
				</ol>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," topic/li task/substep ")]'>
		<li class="substep">
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>


</xsl:stylesheet>