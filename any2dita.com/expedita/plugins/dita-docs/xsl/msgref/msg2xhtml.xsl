<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

	<!-- ideally,  preset a site default for it and also get this from the topic -->
	<xsl:param name="Lang" select="'en-us'"/>
	<!-- layout related -->
	<xsl:param name="GENERATE-MSGREF-LABELS" select="'yes'"/>

	<!-- generated string values (translatable) -->
	<xsl:param name='label-msgExplanation'>Explanation</xsl:param>
	<xsl:param name='label-msgSystemAction'>System Action</xsl:param>
	<xsl:param name='label-msgOperatorResponse'>Operator Response</xsl:param>
	<xsl:param name='label-msgSystemProgrammerResponse'>System Programmer Response</xsl:param>
	<xsl:param name='label-msgUserResponse'>User Response</xsl:param>
	<xsl:param name='label-msgAdministratorResponse'>Administrator Response</xsl:param>
	<xsl:param name='label-msgProgrammerResponse'>Programmer Response</xsl:param>
	<xsl:param name='label-msgProblemDetermination'>Problem Determination</xsl:param>
	<xsl:param name='label-msgSource'>Source</xsl:param>
	<xsl:param name='label-msgModule'>Module</xsl:param>
	<xsl:param name='label-msgRoutingCode'>Routing Code</xsl:param>
	<xsl:param name='label-msgAutomation'>Automation</xsl:param>



	<xsl:template match='*[contains(@class," msg/msg ")]' mode="content">
		<div class='postContent topic'>
			<xsl:apply-templates select='*[contains(@class," msg/msgId ")]' mode="content"/>
			<xsl:apply-templates select='titlealts'/>
			<xsl:apply-templates select='prolog'/>
			<xsl:apply-templates select='*[contains(@class," msg/msgText ")]' mode="msgcontent"/>
			<xsl:apply-templates select='*[contains(@class," msg/msgBody ")]'  mode="msgcontent"/>
			<xsl:apply-templates select='related-links'/>
			<xsl:if test='*[contains(@class," topic/topic ")]'>
				<div class='childTopics'>
					<xsl:apply-templates select='*[contains(@class," topic/topic ")]' mode="nested"/>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match='msgId' mode="content">
		<div class="postHeader">
			<xsl:element name="h{$headlevel1}">
				<xsl:attribute name="class"><xsl:value-of select="$classlevel1"/><xsl:text> msgId </xsl:text><xsl:value-of select="local-name(parent::*)"/><xsl:value-of select="local-name(.)"/></xsl:attribute>
				<!--h2 class="postTitle topictitlex msgId"-->
				<xsl:apply-templates/>
			</xsl:element>
		</div><!-- /postHeader -->
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgPrefix ")]'>
		<span class='msgPrefix'><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgNumber ")]'>
		<span class='msgNumber'><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgSuffix ")]'>
		<span class='msgSuffix'><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgText ")]' mode="msgcontent">
		<div class='shortdesc msgText'>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgBody ")]' mode="msgcontent">
		<div class='msgBody'>
		    <xsl:if test='parent::*[contains(@class," topic/topic ")]/@id'>
		      <a name='top_{parent::*[contains(@class," topic/topic ")]/@id}'>&#160;</a>
		    </xsl:if>
			<xsl:apply-templates/>
		</div>
		<xsl:comment>/msgBody</xsl:comment>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgExplanation ")]'>	
		<div class='sectionDiv msgExplanation'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgExplanation"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>


	<xsl:template match='*[contains(@class," msg/msgSystemAction ")]'>
		<div class='sectionDiv msgSystemAction'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgSystemAction"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgOperatorResponse ")]'>
		<div class='sectionDiv msgOperatorResponse'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgOperatorResponse"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgSystemProgrammerResponse ")]'>
		<div class='sectionDiv msgSystemProgrammerResponse'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgSystemProgrammerResponse"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgUserResponse ")]'>
		<div class='sectionDiv msgUserResponse'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgUserResponse"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgAdministratorResponse ")]'>
		<div class='sectionDiv msgAdministratorResponse'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgAdministratorResponse"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgProgrammerResponse ")]'>
		<div class='sectionDiv msgProgrammerResponse'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgProgrammerResponse"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgProblemDetermination ")]'>
		<div class='sectionDiv msgProblemDetermination'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgProblemDetermination"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgSource ")]'>
		<div class='sectionDiv msgSource'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgSource"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgModule ")]'>
		<div class='sectionDiv msgModule'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgModule"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgRoutingCode ")]'>
		<div class='sectionDiv msgRoutingCode'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgRoutingCode"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgAutomation ")]'>
		<div class='sectionDiv msgAutomation'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
			<xsl:if test='$GENERATE-MSGREF-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
					<xsl:with-param name="label-type"><xsl:value-of select="$label-msgAutomation"/></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>
	
	
	<!-- code lists are sent through to dl processing as table cellspacing='0' cellpadding='3' -->
	<xsl:template match='*[contains(@class," msg/msgCodeList ")]'>
		<table border='0'>
			<xsl:apply-templates mode="msgTable"/>
		</table>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/dlentry ")]' mode="msgTable">
		<tr>
			<xsl:apply-templates select='*[contains(@class," topic/dt ")]' mode="msgTable"/>
			<xsl:apply-templates select='*[contains(@class," topic/dd ")]' mode="msgTable"/>
		</tr>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/dlhead ")]' mode="msgTable">
		<tr>
			<xsl:apply-templates select='*[contains(@class," topic/dthd ")]' mode="msgTable"/>
			<xsl:apply-templates select='*[contains(@class," topic/ddhd ")]' mode="msgTable"/>
		</tr>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/dthd ")]' mode="msgTable">
		<th valign="top" align="left" bgcolor="silver">
			<xsl:apply-templates/>
		</th>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/ddhd ")]' mode="msgTable">
		<th valign="top" align="left">
			<xsl:apply-templates/>
		</th>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/dt ")]' mode="msgTable">
		<td valign="top" style="padding-top: 3pt;" width="25%">
			<xsl:apply-templates/>
		</td>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," topic/dd ")]' mode="msgTable">
		<td valign="top" style="padding-top: 3pt;" width="75%">
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<xsl:template match='*[contains(@class," msg/msgCodeEntry ")]'>
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>
