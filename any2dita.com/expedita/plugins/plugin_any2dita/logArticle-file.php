<?php
// called by controller for widget_jotsomwysiwyg.php (any HTML input for that matter)

// MUST call using hook_action('logArticle',array());

/* Model */
register_action('logArticle','logArticle_html');
function logArticle_html() {
	global $contentDir, $groupName, $config;
	
	// Get data from the form.
	$c_title =  $_POST['title'];
	$c_desc =  $_POST['desc'];
	$c_body = $_POST['body'];


	// Clean up parts for the document itself.
	$slug = prep_slug_ht($c_title);
	//echo 'SLUG: '.htmlentities($slug).'<br/>';
	$title = prep_title_ht($c_title);
	//echo 'TITLE: '.htmlentities($title).'<br/>';
	$desc = prep_desc_ht($c_desc); 
	//echo 'DESC: '.htmlentities($desc).'<br/>';
	$body = prep_body_ht($c_body);
	//echo 'BODY: '.htmlentities($body).'<br/>';
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
	//file_put_contents($file, $output);
	echo '<hr/>DITA:<pre>'.htmlentities($output).'</pre>';
	exit;
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

// Replace some obvious HTML entities with meta tags (valid and parseable).
// Use context-aware XSLT to revert or remove only as needed; pre should have LF restored, for example.
// Really need a DOM node removal tool for things like:
// 	Removing not valid XHTML elements
//  Removing @style and others.
//	Grouping nodes (scoping extent of h1, h2, h3 for example)
//	Renaming nodes
//	Repositioning nodes (reversing their nesting for example)
function unsoup_ht($c) {
	$c = str_replace(chr(9),'<span>TAB</span>',$c);
	$c = str_replace(chr(10),'<span>LF</span>',$c);
	$c = str_replace(chr(13),'<span>CR</span>',$c);
	$c = str_replace('&#39;','<span>APOS</span>',$c);
	$c = str_replace('&nbsp;','<span>NBSP</span>',$c);
	return $c;
}


// Prepare a slug for use as an ID or as a URL slug (filename).
function prep_slug_ht($c) {
	$c = str_replace('&#39;','',strip_tags($c));
	$c = str_replace(array('.',',',':','?','!',';','\'','"',"'"), '', $c);
	$c = str_replace(' ','_', $c);
	$c = strtolower($c);
	return $c;
}


function prep_title_ht($c) {
	if ($c != '') {
		$c = '<title>'.$c.'</title>';
		$c = delouse_ht($c);
		// transform wraps with 'title'
	}
	return $c;
}


function prep_desc_ht($c) {
	if ($c != '') {
		$c = '<center>'.$c.'</center>';
		$c = delouse_ht($c);
		// transform wraps with 'shortdesc'
	}
	return $c;
}

function prep_body_ht($c) {
		echo '<hr/>Raw HTML:<pre>'.htmlentities($c).'</pre>';
	$c = '<div>'.$c.'</div>';
	$c = delouse($c);
		echo '<hr/>Cleaned XHTML<pre>'.htmlentities($c).'</pre>';
		//exit;
	// transform wraps with 'body'
	return $c;
}


function delouse_ht($c) {
	// First make sure it has one top level wrapper.
	$c = unsoup_ht($c);
	// Load bounded string into the DOM for initial de-souping.
	$x = new DOMDocument;
	$x->loadHTML($c);
	// Turn it into (cough) XHTML. At least it will parse as well-formed.
	$x = $x->saveXML();
	// Transform it into valid DITA body content
	$x = munge_ht($x);
	// Do some closing character repairs.
	//$x = str_replace('&#13;',"\n",$x);
	return $x;
}


function munge_ht($xml_string) {
	$xslDoc = new DOMDocument();
	$xslDoc->load(appPath().'xsl/h2proto.xsl'); // FIX: need to get this from the dita-docs plugin
	$xmlDoc = new DOMDocument();
	$xmlDoc->loadXML($xml_string);
	$xslt = new XSLTProcessor();
	$xslt->importStylesheet($xslDoc);
	return $xslt->transformToXml($xmlDoc);
}
