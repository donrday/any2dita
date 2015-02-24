  <xsl:template name="tutorialBody2">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <body>
      <xsl:call-template name="setidaname"/>
      <xsl:value-of select="$newline"/>
      <xsl:call-template name="start-flagit">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>     
      </xsl:call-template>
      <xsl:call-template name="start-revflag">
        <xsl:with-param name="flagrules" select="$flagrules"/>  
      </xsl:call-template>

      <!-- TutSpec :: breadcrumb -->
      <xsl:choose>
        <xsl:when test="boolean(//*[contains(@class,' topic/link ')][@role='tutbreadcrumb'])">
          <div class="breadcrumb">
            <xsl:call-template name="tutbreadcrumb" />
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="breadcrumb"><xsl:comment>&#xA0;</xsl:comment></div>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="gen-user-header"/>  <!-- include user's XSL running header here -->
      <xsl:call-template name="processHDR"/>
      <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
      <xsl:call-template name="gen-user-sidetoc"/>

      <!-- Insert previous-next links at the top of each topic. -->
      <xsl:call-template name="tutprevnext" />

      <xsl:apply-templates/> <!-- this will include all things within topic; therefore, -->
       <!-- title content will appear here by fall-through -->
       <!-- followed by prolog (but no fall-through is permitted for it) -->
       <!-- followed by body content, again by fall-through in document order -->
       <!-- followed by related links -->
       <!-- followed by child topics by fall-through -->

      <!-- Insert previous-home-next links at the bottom of each topic. -->
      <xsl:call-template name="tutprevnext" />

      <xsl:call-template name="gen-endnotes"/>    <!-- include footnote-endnotes -->
      <xsl:call-template name="gen-user-footer"/> <!-- include user's XSL running footer here -->
      <xsl:call-template name="processFTR"/>      <!-- Include XHTML footer, if specified -->

      <xsl:call-template name="end-revflag">
        <xsl:with-param name="flagrules" select="$flagrules"/>  
      </xsl:call-template>
      <xsl:call-template name="end-flagit">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>     
      </xsl:call-template>

    </body>
    <xsl:value-of select="$newline"/>

  </xsl:template>
