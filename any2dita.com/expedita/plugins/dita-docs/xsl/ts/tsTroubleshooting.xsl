<?xml version='1.0' ?>
<xsl:stylesheet
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

	<!-- ideally,  preset a site default for it and also get this from the topic -->
	<xsl:param name="Lang" select="'en-us'"/>
	<!-- layout related -->
	<xsl:param name="GENERATE-TS-LABELS" select="'yes'"/>

	<!-- generated string values (translatable) -->
	<xsl:param name="label-tsSymptoms">Symptoms</xsl:param>
	<xsl:param name="label-tsCauses">Causes</xsl:param>
	<xsl:param name="label-tsEnvironment">Environment</xsl:param>
	<xsl:param name="label-tsDiagnose">Diagnose</xsl:param>
	<xsl:param name="label-tsResolve">Resolve</xsl:param>
	<!--
	<!ATTLIST tsSymptoms            %global-atts; class  CDATA "- topic/section tsTroubleshooting/tsSymptoms ">
	<!ATTLIST tsCauses              %global-atts; class  CDATA "- topic/section tsTroubleshooting/tsCauses ">
	<!ATTLIST tsEnvironment         %global-atts; class  CDATA "- topic/section tsTroubleshooting/tsEnvironment ">
	<!ATTLIST tsDiagnose            %global-atts; class  CDATA "- topic/section tsTroubleshooting/tsDiagnose ">
	<!ATTLIST tsResolve             %global-atts; class  CDATA "- topic/section tsTroubleshooting/tsResolve ">
	-->
	
	
	<!-- troubleshooting: this one gets hit -->
	<xsl:template match='*[contains(@class," tsTroubleshooting/tsTroubleshooting ")]' mode="content">
		<div class='postContent topic'>
			<xsl:apply-templates select='prolog'/>
			<xsl:apply-templates select='title' mode="topiccontent"/>
			<xsl:apply-templates select='titlealts'/>
			<xsl:apply-templates select='*[contains(@class," topic/abstract ")]'/>
			<xsl:apply-templates select='*[contains(@class," tsTroubleshooting/tsBody ")]'/>
			<xsl:apply-templates select='*[contains(@class," topic/related-links ")]'/>
			<xsl:if test='*[contains(@class," topic/topic ")]'>
				<div class='childTopics'>
					<xsl:apply-templates select='*[contains(@class," topic/topic ")]' mode="nested"/>
				</div>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," tsTroubleshooting/tsBody ")]'>
		<div class='tsBody'>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," tsTroubleshooting/tsSymptoms ")]'>
		<div class='sectionDiv'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TS-LABELS = "yes"'>
		      <xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-tsSymptoms"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," tsTroubleshooting/tsCauses ")]'>
		<div class='sectionDiv'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TS-LABELS = "yes"'>
				<xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-tsCauses"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," tsTroubleshooting/tsEnvironment ")]'>
		<div class='sectionDiv'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TS-LABELS = "yes"'>
		    	<xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-tsEnvironment"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," tsTroubleshooting/tsDiagnose ")]'>
		<div class='sectionDiv'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TS-LABELS = "yes"'>
		    	<xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-tsDiagnose"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>
	
	<xsl:template match='*[contains(@class," tsTroubleshooting/tsResolve ")]'>
		<div class='sectionDiv'>
			<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
			<xsl:call-template name="check-rev"/>
		    <xsl:if test='$GENERATE-TS-LABELS = "yes"'>
		    	<xsl:call-template name="get-label-title">
		        <xsl:with-param name="label-type"><xsl:value-of select="$label-tsResolve"/></xsl:with-param>
		      </xsl:call-template>
		    </xsl:if>
			<div class='sectionBody'><xsl:apply-templates select="node()[name()!='title']"/></div>
		</div>
	</xsl:template>

</xsl:stylesheet>