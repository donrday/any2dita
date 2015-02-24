<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
<xsl:output method="text"/>

<!--xsl:strip-space elements="body map"/-->
<xsl:preserve-space elements="pre,screen,lines"/>
    
<xsl:param name="groupName" select="'Home'"/>
<xsl:param name="contentDir" select="'content'"/>
<xsl:param name="contentFile" select="'Overview.dita'"/>
<xsl:param name="userDir" select="'.'"/>
<xsl:param name="SHOW-CONREFMARKUP" select="'no'"/>

<!-- This transform generates a PHP file that describes the structure as executable objects that
   build an OOXML result document. The PHP file must first be executed, which produces an OOXML file,
   hardwired here as 'helloWorld.docx'.
   Note that the PHPWord package was a new work in slow progress at the time this implementation
   was coded; check to see if there are updates either for the syntax or for new function.
-->

<xsl:template match="/">
&lt;?php
// Include the PHPWord.php, all other classes were loaded by an autoloader
require_once 'PHPWord.php';

// Create a new PHPWord Object
$PHPWord = new PHPWord();

// Declare some common font styles
$PHPWord->addFontStyle('b-Style', array('bold'=>true));
$PHPWord->addLinkStyle('u-Style', array('underline'=>PHPWord_Style_Font::UNDERLINE_SINGLE));
$PHPWord->addFontStyle('i-Style', array('italic'=>true));
$PHPWord->addFontStyle('tt-Style', array('monospace'=>true));
$PHPWord->addFontStyle('sup-Style', array('superscript'=>true));
$PHPWord->addFontStyle('sub-Style', array('subscript'=>true));
$PHPWord->addFontStyle('ph-Style', array('color'=>'00FF00'));
$PHPWord->addFontStyle('cite-Style', array('italic'=>true));
$PHPWord->addFontStyle('q-Style', array('italic'=>true, 'color'=>'FF0000'));
$PHPWord->addLinkStyle('NLink', array('color'=>'0000FF', 'underline'=>PHPWord_Style_Font::UNDERLINE_SINGLE));
$PHPWord->addFontStyle('dt-Style', array('bold'=>true));

// Catch unmapped elements:
$PHPWord->addFontStyle('error-Style', array('color'=>'FFFF00')); // yellow

// Common block styles (, 'color'=>'663366')
$PHPWord->addParagraphStyle('p-Style', array('marginLeft'=>900, 'align'=>'left', 'spaceAfter'=>100));
$PHPWord->addParagraphStyle('dd-Style', array('indLeft' => 720));

// Add title styles
$PHPWord->addTitleStyle(1, array('size'=>20, 'color'=>'333333', 'bold'=>true));
$PHPWord->addTitleStyle(2, array('size'=>16, 'color'=>'666666'));

//$olistStyle = array('listType'=>PHPWord_Style_ListItem::TYPE_NUMBER);
$olistStyle = array('listType'=>PHPWord_Style_ListItem::TYPE_NUMBER_NESTED);

// Start the content gathering...
$section = $PHPWord->createSection();

// Add text elements
$section->addTitle('Table of contents', 1);
//$section->addTextBreak(2);

// Define the TOC font style
$fontStyle = array('spaceAfter'=>60, 'size'=>12);

// Add TOC
$section->addTOC($fontStyle);

<xsl:apply-templates/>

// At least write the document to webspace:
$objWriter = PHPWord_IOFactory::createWriter($PHPWord, 'Word2007');
$objWriter->save('helloWorld.docx');

// conditional send the document to the browser
if (1 == 2) {
	header('Content-type: application/vnd.openxmlformats-officedocument.wordprocessingml.document');
	header('Content-Disposition: attachment; filename="helloWorld.docx"');
	readfile('helloWorld.docx');
}
?&gt;
</xsl:template>


<!-- =============topic=============== -->
<xsl:template name='ooxmltopic' match='*[contains(@class," topic/topic ")]'>
    <xsl:apply-templates select='*[contains(@class," topic/prolog ")]'/>
    <xsl:apply-templates select='*[contains(@class," topic/title ")]' mode="topiccontent"/>
    <xsl:apply-templates select='*[contains(@class," topic/titlealts ")]'/>
    <xsl:apply-templates select='*[contains(@class," topic/shortdesc ")]'/>
    <xsl:apply-templates select='*[contains(@class," topic/body ")]'/>
	<xsl:apply-templates select='*[contains(@class," topic/related-links ")]'/>
	<!--
	<div class="nestedtopic">
		<xsl:apply-templates select='*[contains(@class," topic/topic ")]' mode="nested"/>
	</div>
	-->
</xsl:template>


<xsl:template match='*[contains(@class," topic/title ")]' mode='topiccontent'>
<xsl:variable name="nestedtopicdepth"><xsl:value-of select='count(ancestor::*[contains(@class," topic/topic ")])'/></xsl:variable>
$section->addTitle('<xsl:apply-templates/>', 1);
</xsl:template>


<xsl:template match='*[contains(@class," topic/prolog ")]'>
</xsl:template>

<xsl:template match='*[contains(@class," topic/titlealts ")]'>
</xsl:template>

<xsl:template match='dita'>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," topic/body ")]'>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," topic/section ")]'>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," topic/section ")]/*[contains(@class," topic/title ")]'>
$section->addTitle('<xsl:apply-templates/>', 2);
</xsl:template>


<xsl:template match='*[contains(@class," topic/shortdesc ")]'>
$textrun = $section->createTextRun('i-Style', 'p-Style');
<xsl:apply-templates/>
</xsl:template>

<!-- DRD: see if this translate makes a safe character conversion for ' that pollutes PHP syntax -->
<!-- translate(.,'&quot;&quot;','&#201C;&#201D;') -->
<xsl:template match='*[contains(@class," topic/shortdesc ")]/text()'>
<!--$textrun->addText('<xsl:value-of select="translate(.,'&#201C;&#201D;&quot;','')"/>');-->
$textrun->addText('<xsl:value-of select="."/>');
</xsl:template>

<xsl:template match='*[contains(@class," topic/p ")]'>
$textrun = $section->createTextRun('p-Style');
<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," topic/p ")]/text()'>
<!--$textrun->addText('<xsl:value-of select="translate(.,'&#201C;&#201D;&quot;','')"/>');-->
$textrun->addText('<xsl:value-of select="."/>');
</xsl:template>



<xsl:template match='*[contains(@class," hi-d/b ")]' priority='2'>
$textrun->addText('<xsl:apply-templates/>', 'b-Style');
</xsl:template>

<xsl:template match='*[contains(@class," hi-d/u ")]' priority='2'>
$textrun->addText('<xsl:apply-templates/>', 'u-Style');
</xsl:template>

<xsl:template match='*[contains(@class," hi-d/i ")]' priority='2'>
$textrun->addText('<xsl:apply-templates/>', 'i-Style');
</xsl:template>

<xsl:template match='*[contains(@class," hi-d/tt ")]' priority='2'>
$textrun->addText('<xsl:apply-templates/>', 'tt-Style');
</xsl:template>

<xsl:template match='*[contains(@class," hi-d/sup ")]' priority='2'>
$textrun->addText('<xsl:apply-templates/>', 'ph-Style');
</xsl:template>

<xsl:template match='*[contains(@class," hi-d/sub ")]' priority='2'>
$textrun->addText('<xsl:apply-templates/>', 'ph-Style');
</xsl:template>

<xsl:template match='*[contains(@class," topic/ph ")]'>
$textrun->addText('<xsl:apply-templates/>', 'ph-Style');
</xsl:template>

<xsl:template match='*[contains(@class," topic/cite ")]'>
$textrun->addText('<xsl:apply-templates/>', 'cite-Style');
</xsl:template>

<xsl:template match='*[contains(@class," topic/q ")]'>
<!-- 
  possible php solution: http://pastebin.com/CEK0NN43 but get the actual characters from the "gumbo" 
  reply here: http://stackoverflow.com/questions/1262038/how-to-replace-microsoft-encoded-quotes-in-php  
-->
$textrun->addText('"<xsl:apply-templates/>"', 'q-Style');
</xsl:template>

<xsl:template match='*[contains(@class," topic/xref ")]'>
$textrun->addLink('<xsl:apply-templates/>', null, 'NLink');
</xsl:template>

<xsl:template match='*[contains(@class," topic/related-links ")]'>
</xsl:template>

<!-- UL specific -->
<xsl:template match='*[contains(@class," topic/ul ")]'>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," topic/ul ")]/*[contains(@class," topic/li ")]'>
$section->addListItem('<xsl:apply-templates/>', 0);
</xsl:template>

<xsl:template match='*[contains(@class," topic/li ")]/*/*[contains(@class," topic/ul ")]/*[contains(@class," topic/li ")]'>
$section->addListItem('<xsl:apply-templates/>', 1);
</xsl:template>

<!-- OL specific -->
<xsl:template match='*[contains(@class," topic/ol ")]'>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," topic/ol ")]/*[contains(@class," topic/li ")]'>
$section->addListItem('<xsl:apply-templates/>', 0, null, $olistStyle);
</xsl:template>

<xsl:template match='*[contains(@class," topic/li ")]/*/*[contains(@class," topic/ol ")]/*[contains(@class," topic/li ")]'>
$section->addListItem('<xsl:apply-templates/>', 1, null, $olistStyle);
</xsl:template>


<!-- DL specific -->
<xsl:template match='*[contains(@class," topic/dl ")]'>
<xsl:apply-templates/>
</xsl:template>


<xsl:template match='*[contains(@class," hi-d/dt ")]' priority='2'>
$textrun->addText('<xsl:apply-templates/>', 'b-Style');
</xsl:template>

<xsl:template match='*[contains(@class," topic/dd ")]'>
$textrun = $section->createTextRun('p-Style');
<xsl:apply-templates/>
</xsl:template>

<xsl:template match='*[contains(@class," topic/dd ")]/text()'>
<!--$textrun->addText('<xsl:value-of select="translate(.,'&#201C;&#201D;&quot;','')"/>');-->
$textrun->addText('<xsl:value-of select="."/>');
</xsl:template>


<!-- Catch all other unmapped elements and output with the class name -->
<xsl:template match='*'>
$textrun->addText('[*<xsl:value-of select="@class"/><xsl:value-of select="name()"/>:<xsl:apply-templates/>]', 'error-Style');
</xsl:template>


<!-- utilities -->

<!-- Michael Kay string replace template -->

  <xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>




</xsl:stylesheet>