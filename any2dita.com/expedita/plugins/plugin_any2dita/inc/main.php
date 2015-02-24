<?php


// Null $msg to use as a changed flag after the logic has been executed.
$msg = ''; 

$bits = array_filter($_REQUEST);
if (!empty($bits)) {

	// Set up individualized folders for result files, anticipating heavy traffic:
	//$job_id = session_id();  // alternative key for session artifacts?
	$job_name = 'zip'.rand(1000, 9999); // primary key for session artifacts
	$outmapname = 'map'.rand(1000, 9999); // temporary name for result maps

	// variables used for outputs
	// GOOD REFERENCE: http://stackoverflow.com/questions/4645082/get-absolute-path-of-current-script
	$targPath = 'STAGE/'.$job_name;
	$outputpath = getcwd().'/'.$targPath; 
	$patchpath = '?tab=admin&xform='; // Not directly used for now; add to generated topicref links to enable rendering.
	
	// Defaults for form values (both get and post):
	$in_text = ''; // preset so we can expose the value in pre-submission value (normally is set by main.php)
	$prefix = 'temp';
	$zip_name = $job_name.'.zip';
	$mapName = $outmapname.'ditamap';
	$previewType = 'preview';

	// Select a controller for the current POST condition, if any.
	if (isset($_POST['htsub'])) {
		$page 		= ($_POST['pagename'] 	!= '')	? $_POST['pagename']	: 'temp';
		$prefix 	= ($_POST['prefix'] 	!= '') 	? $_POST['prefix'] 	: 'ht'.rand(10, 99);
		$outproc 	= ($_POST['topictype'] 	!= '') 	? $_POST['topictype']	: 'topic';
		
		$in_text = $_POST['htmlin'];
		$msg = 'Pasted HTML resource';
	} 

	elseif (isset($_POST['rtsub'])) {
		$page 		= ($_POST['pagename'] 	!= '')	? $_POST['pagename']	: 'temp';
		$prefix 	= ($_POST['prefix'] 	!= '') 	? $_POST['prefix'] 	: 'rt'.rand(10, 99);
		$outproc 	= ($_POST['topictype'] 	!= '') 	? $_POST['topictype']	: 'topic';
		
		$in_text = $_POST['rtfin'];
		$in_text = '<html><head><title>Temp title</title></head><body>'.$in_text.'</body></html>';
		$msg = 'Pasted Rich Text resource';
	} 
	
	elseif (isset($_POST['mdsub'])) {
		$page 		= ($_POST['pagename'] 	!= '')	? $_POST['pagename']	: 'temp';
		$prefix 	= ($_POST['prefix'] 	!= '') 	? $_POST['prefix'] 	: 'md'.rand(10, 99);
		$outproc 	= ($_POST['topictype'] 	!= '') 	? $_POST['topictype']	: 'topic';
		$url 		= ($_POST['url'] 		!= '')	? $_POST['url']			: '';
		$content 	= ($_POST['mdin'] 		!= '')	? $_POST['mdin']		: '';
		$fullpath = ''; // default for pasted-in content;
		if ($url != '') {
			// Should we specifically add the .text extension here? Won't work for index pages, for example, which lack a name segment.
			// Therefore we might still need to get the page name separately so that we can find "non pages" (default index).
			$content =  file_get_contents($url);
			$parts = parse_url($url);
			$fullpath = $parts['scheme'].'://'.$parts['host'];
		} 

		//http://stackoverflow.com/questions/19486280/how-can-i-use-michel-fortins-php-markdown-without-autoloading
		require_once vendorPath().'PHP Markdown Lib 1.4.1/Michelf/MarkdownInterface.php';
		require_once vendorPath().'PHP Markdown Lib 1.4.1/Michelf/Markdown.php';
		require_once vendorPath().'PHP Markdown Lib 1.4.1/Michelf/MarkdownExtra.php';
		$in_text = \Michelf\Markdown::defaultTransform($content);
		$in_text = '<html><head><title>Temp title</title></head><body>'.$in_text.'</body></html>';
		$msg = 'URL markdown resource';
	} 
		
	elseif (isset($_POST['wksub'])) {
		$page 		= ($_POST['pagename'] 	!= '')	? $_POST['pagename']	: 'temp';
		$prefix 	= ($_POST['prefix'] 	!= '') 	? $_POST['prefix'] 	: 'wk'.rand(10, 99);
		$outproc 	= ($_POST['topictype'] 	!= '') 	? $_POST['topictype']	: 'topic';
		$url 		= ($_POST['endpoint'] 	!= '')	? $_POST['endpoint']	: '';
		$url_endpoint = rtrim($url, '/');// we strip any trailing / here, and add it back with the PQs next
		if (($url_endpoint == '') && ($page == 'temp')) {
			// unusable input; set the "do nothing" flag
			$msg = '';
		} else {
			// query page content from the wiki (mediawiki conventions here):
			$opts = array('http' =>
			  array(
			    'user_agent' => 'MW2DITAbot/1.0 (http://www.donrday.com/)'
			  )
			);
			$context = stream_context_create($opts);
	
			$url = "{$url_endpoint}/index.php?action=render&title={$page}";// NOTE: this version adds the / to the endpoint.
			$in_text = '<h1>'.$page.'</h1>' . file_get_contents($url, FALSE, $context); // stream the resource from the endpoint
			$in_text = '<html><head><title>Temp title</title></head><body>'.$in_text.'</body></html>';
			$msg = 'Wiki input for '.$url;
		}
	} 

	elseif (isset($_GET['filein'])) { // PRIMARY INTERFACE FOR MIGRATION WORK
		$page 		= ($_POST['pagename'] 	!= '')	? $_POST['pagename']	: 'temp';
		$prefix 	= ($_POST['prefix'] 	!= '') 	? $_POST['prefix'] 	: 'fl'.rand(10, 99);
		$outproc 	= ($_POST['topictype'] 	!= '') 	? $_POST['topictype']	: 'topic';

		$infile = $_GET['infile'];
		$in_text = file_get_contents($infile);
		//include 'clean_md.php';
		//$sXml = transformMD($in_text, $prefix);
		$msg = 'URL-based markdown resource';
	} 

	elseif (isset($_GET['page'])) { // URL GET interface for api-accessible page content
		$page 		= ($_POST['page'] 		!= '')	? $_POST['page']		: 'page'.rand(10000, 99999);
		$prefix 	= ($_POST['prefix'] 	!= '') 	? $_POST['prefix'] 		: 'md'.rand(10, 99);
		$outproc 	= ($_POST['topictype'] 	!= '') 	? $_POST['topictype']	: 'topic';

		// query page content from the wiki (mediawiki conventions here):
		$opts = array('http' =>
		  array(
		    'user_agent' => 'MW2DITAbot/1.0 (http://www.contelligencegroup.com/)'
		  )
		);
		$context = stream_context_create($opts);
		$url_endpoint = 'http://wiki.zenoss.org/';// This is Zenoss specific
		//$url_endpoint = 'http://www.mediawiki.org/wiki/';
		$url = "{$url_endpoint}index.php?action=render&title={$page}";
		$in_text = '<h1>'.$page.'</h1>' . file_get_contents($url, FALSE, $context);
		$in_text = '<html><head><title>Temp title</title></head><body>'.$in_text.'</body></html>';
		$msg = 'Wiki input for '.$url;
	} else {
		// SPECIFICALLY DO NOTHING
		$msg = '';
	}
// The value of $msg can be used now for diagnostics/conditionality.

}