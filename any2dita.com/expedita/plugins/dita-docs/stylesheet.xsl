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
<!DOCTYPE xsl:stylesheet [
<!-- entities to substitute during editing to prevent literal instantiation -->
  <!ENTITY gt            "&amp;gt;"> 
  <!ENTITY lt            "["> 
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	>

<!-- import the master template definitions... -->
<xsl:import href="../../plugins/dita-docs/xsl/dita2html.xsl"/>
<xsl:param name="mediapath" select="''"/>



<!-- and then apply overrides (these have higher priority) -->


<!-- Theme specific manipulations can be added here, as well. This takes care of the "local style" problem in a sense. -->

<xsl:template match='*[contains(@class," topic/shortdesc ")]/*[contains(@class," topic/image ")]'>
	<div class="entry-content">
		<p>
		<a href="{$mediapath}plugin/Content/blog/images/Don-Day-Portrait-DSC02054-f-150x150.jpg">
		<img width="150" height="150" src="{$mediapath}plugin/Content/blog/images/Don-Day-Portrait-DSC02054-f-150x150.jpg" class="attachment-post-thumbnail wp-post-image" alt="Water adapting to various &quot;devices&quot;"/>
		<br />
		</a>
		</p>
	</div>
</xsl:template>

</xsl:stylesheet>