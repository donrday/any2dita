<?xml version="1.0" encoding="UTF-8"?>
<!--
 | LICENSE: This file is part of the DITA Open Toolkit project hosted on
 |          Sourceforge.net. See the accompanying license.txt file for
 |          applicable licenses.
 *-->
<!--
 | (C) Copyright IBM Corporation 2006. All Rights Reserved.
 *-->
<!-- DO NOT TRANSLATE -->
<!-- This stylesheet transforms DITA Message specialization files to XHTML -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>


<!-- This is the template to call to get generated text from the string files -->
<xsl:template name="msgrefGetString">
   <xsl:param name="stringName"/>
   <xsl:call-template name="getString">
      <xsl:with-param name="stringName" select="$stringName"/>
      <xsl:with-param name="stringFileList">../msgRef/msgrefstrings.xml</xsl:with-param>
   </xsl:call-template>
</xsl:template>

<xsl:template name="standardMsgitemTitle">
  <xsl:param name="stringName"/>
  <xsl:choose>
    <!-- If there is a user title, do not use the default -->
    <xsl:when test="*[contains(@class,' topic/title ')]"/>
    <xsl:otherwise>
      <h4>
        <xsl:call-template name="msgrefGetString">
          <xsl:with-param name="stringName" select="$stringName"/>
        </xsl:call-template>
      </h4>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgBody ')]/*/*[contains(@class,' topic/title ')]">
  <h4>
    <xsl:call-template name="commonattributes"/>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgExplanation ')]">
 	<xsl:variable name="thisTitleName"><xsl:value-of select='name(*[contains(@class," topic/title ")])'/></xsl:variable>
	<div class='sectionDiv'>
		<xsl:call-template name="check-rev"/>
		<xsl:if test="@id"><a name="{/*/@id}__{@id}">&#160;</a></xsl:if>
		<xsl:call-template name="get-section-title">
			<xsl:with-param name="label-type"><xsl:value-of select="'msgExplanation'"/></xsl:with-param>
		</xsl:call-template>
		<div class='sectionBody'>
			<xsl:apply-templates select="node()[name()!='$thisTitleName']"/>
		</div>
	</div>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgSystemAction ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgSystemAction'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgCodeList ')]"  mode="dl-fmt">
  <xsl:variable name="flagrules">
    <xsl:call-template name="getrules"/>
  </xsl:variable>
  <xsl:variable name="conflictexist">
    <xsl:call-template name="conflict-check">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="start-flagit">
    <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>     
  </xsl:call-template>
  <xsl:call-template name="start-revflag">
    <xsl:with-param name="flagrules" select="$flagrules"/>
  </xsl:call-template>
  <xsl:call-template name="setaname"/>
  <dl>
    <!-- handle DL compacting - default=yes -->
    <xsl:if test="@compact='no'"><xsl:attribute name="class">dlexpand</xsl:attribute></xsl:if>
    <xsl:call-template name="commonattributes"/>
    <xsl:apply-templates select="@compact"/>
    <xsl:call-template name="setid"/>
    <xsl:call-template name="gen-style">
      <xsl:with-param name="conflictexist" select="$conflictexist"></xsl:with-param> 
      <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>
    </xsl:call-template>
    <xsl:if test="not(*[contains(@class,' msg/msgCodeHead ')])">
      <xsl:call-template name="generateMsgCodeLabelHead"/>
      <xsl:call-template name="generateMsgCodeDefinitionHead"/>
    </xsl:if>
    <xsl:apply-templates/>
  </dl>
  <xsl:call-template name="end-revflag">
    <xsl:with-param name="flagrules" select="$flagrules"/>
  </xsl:call-template>
  <xsl:call-template name="end-flagit">
    <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param> 
  </xsl:call-template>
  <xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgCodeHead ')]">
  <xsl:if test="not(*[contains(@class,' msg/msgCodeLabelHead ')])">
    <xsl:call-template name="generateMsgCodeLabelHead"/>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="not(*[contains(@class,' msg/msgCodeDefinitionHead ')])">
    <xsl:call-template name="generateMsgCodeDefinitionHead"/>
  </xsl:if>
</xsl:template>

<xsl:template name="generateMsgCodeLabelHead">
  <dt>
    <strong>
      <xsl:call-template name="msgrefGetString">
        <xsl:with-param name="stringName" select="'msgCodeLabelHead'"/>
      </xsl:call-template>
    </strong>
  </dt>
  <xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template name="generateMsgCodeDefinitionHead">
  <dd>
    <strong>
      <xsl:call-template name="msgrefGetString">
        <xsl:with-param name="stringName" select="'msgCodeDefinitionHead'"/>
      </xsl:call-template>
    </strong>
  </dd>
  <xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgResponse ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgResponse'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgOperatorResponse ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgOperatorResponse'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgSystemProgrammerResponse ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgSystemProgrammerResponse'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgUserResponse ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgUserResponse'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgAdministratorResponse ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgAdministratorResponse'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgProgrammerResponse ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgProgrammerResponse'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgProblemDetermination ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgProblemDetermination'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgSource ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgSource'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgModule ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgModule'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgRoutingCode ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgRoutingCode'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgDescriptorCode ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgDescriptorCode'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<xsl:template match="*[contains(@class,' msg/msgAutomation ')]">
   <xsl:call-template name="standardMsgitemTitle">
       <xsl:with-param name="stringName" select="'msgAutomation'"/>
   </xsl:call-template>
   <xsl:call-template name="topic.section"/>
</xsl:template>

<!--This defines the noAction element processing; there already is a DIV for the text to be put into -->
<xsl:template match="*[contains(@class,' msg/noAction ')]">
    <xsl:call-template name="msgrefGetString">
      <xsl:with-param name="stringName" select="'noaction'"/>
    </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
