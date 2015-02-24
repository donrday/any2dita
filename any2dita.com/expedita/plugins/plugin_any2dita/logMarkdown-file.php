<?php
// called by controller for widget_jotsomwysiwyg.php

// MUST call using hook_action('logArticle',array());

/* Model */
register_action('logArticle','logArticle_md');
function logArticle_md() {
	global $contentDir, $groupName, $config;

	//http://stackoverflow.com/questions/19486280/how-can-i-use-michel-fortins-php-markdown-without-autoloading
	require_once vendorPath().'PHP Markdown Lib 1.4.1/Michelf/MarkdownInterface.php';
	require_once vendorPath().'PHP Markdown Lib 1.4.1/Michelf/Markdown.php';
	require_once vendorPath().'PHP Markdown Lib 1.4.1/Michelf/MarkdownExtra.php';
	
	// Get data from the form.
	$c_title =  $_POST['title'];
	$c_desc =  $_POST['desc'];
	$c_body = $_POST['body'];


	// Clean up parts for the document itself.
	$slug = prep_slug_md($c_title);
	echo 'SLUG: '.htmlentities($slug).'<br/>';
	
	$title = prep_title_md($c_title);
	echo 'TITLE: '.htmlentities($title).'<br/>';
	
	$desc = prep_desc_md($c_desc); 
	echo 'DESC: '.htmlentities($desc).'<br/>';

	$body = prep_body_md($c_body);
	echo 'BODY: '.htmlentities($body).'<br/>';
	
	//exit;
	// define author, category, etc. here as well

	$URL = "{$groupName}/topic/{$slug}";
	$file = contentPath()."{$slug}.dita";

	$author = 'Don Day';
	$date_created = ' date="2014-07-12"'; // @date is required; pass it in all cases.
	$date_golive = '';//' golive="2014-07-12"';
	$category = 'documentation'; // start offering a pulldown select for this.
	$featureImage = 'generic.png';
	$status = 'draft';

	ob_start();
?>
<!DOCTYPE topic PUBLIC "-//OASIS//DTD DITA Topic//EN" "../dtd/topic.dtd">
<topic id="topic_<?php echo $slug;?>">
	<?php echo $title;?>
	<?php echo $desc;?>
    <prolog>
        <author type="creator"><?php echo $author;?></author>
        <critdates>
            <created <?php echo $date_created;?><?php echo $date_golive;?>/>
        </critdates>
        <metadata>
            <category><?php echo $category;?></category>
            <othermeta name="featureImage" content="<?php echo $featureImage;?>"/>
            <othermeta name="status" content="<?php echo $status;?>"/>
        </metadata>
    </prolog>
	<?php echo $body;?>
</topic>
<?php
	$output = '<?xml version="1.0" encoding="utf-8"?>'."\n".ob_get_contents();
	ob_end_clean();
	file_put_contents($file, $output);
	//echo '<hr/>DITA:<pre>'.htmlentities($output).'</pre>';
	//exit;
/*
	echo "Saving to: $file<br/>";
	echo "template base: ".basePath().'<br/>';
	echo "The header location is being directed to: $URL<hr/>";
	echo "The config data comes from page serviceType {$config['page']['source']}<br/>";
	echo "base: http://" . $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'].'<br/>'; // e.g. 'http://localhost/ditaperday/topic/admin'
	echo "current working folder location: ". dirname($_SERVER["REQUEST_URI"]).'<br/>'; // e.g. '/ditaperday/topic'
	$base_url="http://".$_SERVER['SERVER_NAME'].dirname($_SERVER["REQUEST_URI"].'?').'/';
	echo "Base URL: $base_url<br/>";
	echo "BASE:URL: ".BASE_URL."<br/>";
	//echo '<pre>'.htmlentities($output).'</pre>';
//*/
	//  Now let's go look at it.
	header('Location: '.basePath().$URL);
	exit();
	//*/

	// Note: @ suppresses harmless but alarming message for first creation of new contact file.
	//@$current = file_get_contents($file);
	// Since we are using CSV format, do we need to scrub name or email data for commas as accidental separators?
	//$submitted = "$newMemberName, $newMemberEmail";
	// Note: use fopen and by-line compare to use less memory than this full-file load.
    //if( strpos($current,$submitted) === false ) {
	//	file_put_contents($file, $current .= "$submitted\n");
    //}
}


// Prepare a slug for use as an ID or as a URL slug (filename).
function prep_slug_md($c) {
	$c = str_replace('&#39;','',strip_tags($c));
	$c = str_replace(array('.',',',':','?','!',';','\'','"',"'"), '', $c);
	$c = str_replace(' ','_', $c);
	$c = strtolower($c);
	return $c;
}


function prep_title_md($c) {
	if ($c != '') {
		// Normalize some control characters etc.
		$c = unsoup($c);
		// One top level wrapper.
		$c = '<title>'.$c.'</title>';
		$c = delouse_md($c);
		// result will be wrapped with 'title'
		// Do some closing character repairs.
		//$x = str_replace('&#13;',"\n",$x);
	}
	return $c;
}


function prep_desc_md($c) {
	if ($c != '') {
		$c = \Michelf\Markdown::defaultTransform($c);
		// Normalize some control characters etc.
		//$c = unsoup($c);
		// This is a throwaway, top level wrapper. But it must be valid in XHTML.
		$c = '<center>'.$c.'</center>';
		$c = delouse_md($c);
		// result will be wrapped with 'shortdesc'
		// Do some closing character repairs.
		//$x = str_replace('&#13;',"\n",$x);
	}
	return $c;
}

function prep_body_md($c) {
	if ($c != '') {
		echo '<hr/>Body: Raw Markdown:<pre>'.$c.'</pre>';
		$c = \Michelf\Markdown::defaultTransform($c);
		echo '<hr/>Body: Generated HTML:<pre>'.htmlentities($c).'</pre>';
		// Normalize some control characters etc.
		//$c = unsoup($interim_html);
		// One top level wrapper. This means this element can't appear in the XHTML body.
		$c = '<div>'.$c.'</div>';
		$c = delouse_md($c);
		echo '<hr/>Body: Cleaned XHTML<pre>'.htmlentities($c).'</pre>';
		//exit;
		// result will be wrapped with 'body'
		// Do some closing character repairs.
		//$x = str_replace('&#13;',"\n",$x);
	}
	return $c;
}


// Replace some obvious HTML entities with meta tags (valid and parseable).
// Use context-aware XSLT to revert or remove only as needed; pre should have LF restored, for example.
//E2C2 98BA
function unsoup_md($c) {
	$c = str_replace(chr(9),'<span>TAB</span>',$c);
	$c = str_replace(chr(10),'<span>LF</span>',$c);
	$c = str_replace(chr(13),'<span>CR</span>',$c);
	$c = str_replace('&#39;','<span>APOS</span>',$c);
	$c = str_replace('&nbsp;','<span>NBSP</span>',$c);
	return $c;
}


function delouse_md($c) {
	// Load bounded string into the DOM for initial de-souping.
	$x = new DOMDocument;
	$x->loadHTML($c);
	// Turn it into (cough) XHTML. At least it will parse as well-formed.
	$x = $x->saveXML();
	// Transform it into valid DITA body content
	$x = munge_md($x);
	return $x;
}


function munge_md($xml_string) {
	$xslDoc = new DOMDocument();
	$xslDoc->load(appPath().'xsl/h2proto.xsl'); // FIX: need to get this from the dita-docs plugin
	$xmlDoc = new DOMDocument();
	$xmlDoc->loadXML($xml_string);
	$xslt = new XSLTProcessor();
	$xslt->importStylesheet($xslDoc);
	return $xslt->transformToXml($xmlDoc);
}
