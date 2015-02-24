<!-- http://tech.dir.groups.yahoo.com/group/dita-users/message/24405 -->

<xsl:stylesheet>

<xsl:key name="glossindex" match="//*[@type='glossentry']" use="@navtitle"/>

<xsl:template match="/*[contains(@class, ' map/map ')]">
<xsl:param name="pathFromMaplist"/><!-- this param has no effect on DOT
processing -->
<xsl:if test=".//*[contains(@class, ' map/topicref ')][not(@toc='no')]">
<h1>
<xsl:text>Glossary</xsl:text>
</h1>
<xsl:value-of select="$newline"/>
<ul>
<xsl:value-of select="$newline"/>
<xsl:for-each
select="//topicref[generate-id(.)=generate-id(key('glossindex',
@navtitle))]">
<xsl:sort select="@navtitle"/>
<xsl:for-each select="key('glossindex', @navtitle)">
<li>
<a>
<xsl:attribute name="href">
<xsl:value-of select="substring-before(@href, $DITAEXT)"/>
<xsl:value-of select="$OUTEXT"/>
</xsl:attribute>
<xsl:value-of select="@navtitle"/>
</a>
</li>
</xsl:for-each>
</xsl:for-each>
</ul>
<xsl:value-of select="$newline"/>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
