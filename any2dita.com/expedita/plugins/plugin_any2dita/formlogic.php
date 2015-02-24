<?php
// Resources for markdown:
// http://mrcoles.com/demo/markdown-css/
// http://fvsch.com/code/remarkdown/
// http://web.archive.org/web/20110828143453/http://getspace.org/typographic-contras-minimalist-web-design/
// HTML sample: http://txti.es/aea-2014-wroblewski
// Markdown sample: http://daringfireball.net/projects/markdown/index.text
// Resources for mediawiki api:
// Resources for rich text (contentEditable) 


register_filter('preview','form_preview'); // echo hook_filter('preview',array());

function form_preview() {
	global 	$folderPath, $queryPath, $previewType;
	die("In form_preview");
	$queryPath = '?resource=';
	if (isset($_GET['resource'])) {
		$resource = $_GET['resource'];
		$resultXML = file_get_contents($folderPath.$resource);
		$parseopts = LIBXML_DTDLOAD | LIBXML_DTDVALID | LIBXML_ERR_WARNING | LIBXML_DTDATTR;
		$result = transformXML($resultXML, dirname(__FILE__).'/xsl/'.$previewType.'.xsl', $parseopts); 
		//$linkedmap = htmlentities($result);
		return $result;
	} else {
		return '';//$resource = '';
	}
	}


register_filter('any2dita','any2dita_logic'); // or template-init

function any2dita_logic() {
	global $a2dxsl, $targPath, $fullpath, $imglist, $outputpath, $previewType;

	// Any user's first activity will trigger a general cleanup of any STAGE folders older than 2 hours. 
	if(!isset($_SESSION['cleaned'])){
		// New session actions:
		$path = "STAGE/";
		// Loop over all of the files in the folder
		foreach(glob($path ."*") as $stagename) {
			// Mustn't remove other active files in the staging folder. Remove if older than 2 hours.
			if (time()-filemtime($stagename) > 2 * 3600) {
				// file older than 2 hours
				echo "Deleted: $stagename<br/>";
				foreach(glob($stagename . '/*') as $innerfile) { 
					if(is_dir($innerfile)) delete_files($innerfile); else unlink($innerfile); 
				} 
				rmdir($stagename);
				//unlink($stagename); 
			} else {
			// file younger than 2 hours
				echo "Newer: $stagename<br/>";
			}
		}
	}
	$_SESSION['cleaned'] = true;

	// CONFIG #CONTENT: set these values to the relative names and offset of Content folder outside of pkg
	$contentOffset = ''; // '../'
	$contentDir = '';//'Content';
	$groupName = 'temp';

	$msg = '';
	$imglist = array(); 

	// include('App/views.php'); // 
	include('inc/tools.php'); // functions

	// process GET and POST events
	include('inc/main.php'); // controllers

	// If $msg is empty, the form has not yet been activated.
	if ($msg == '') {
		$rollup_message = 'The any2DITA migration plugin is active.';
	} else {
		// Set up a folder in the staging area for results:
		if (!file_exists($targPath)) { mkdir($targPath, 0777, true); }
		// Initialize the result messages (some or all will be set during the pipeline)
		$intext_message = ''; // for if/else consistency
		$cleanedhtml_message = ''; // for if/else consistency
		$resultxml_message = ''; // for if/else consistency
		$zip_message = ''; // for if/else consistency
		$preview_message = ''; // for if/else consistency
		$linkedmap = '';
		
		// Log the incoming instance in the staging folder
		$ifile = $targPath.'/incoming.txt';
		file_put_contents($ifile, $in_text);
		$intext_message = 'Incoming format: <a href="'.$ifile.'" target="_blank">incoming.txt</a>.<br/>';

		// Convert incoming into intermediate form 
		include 'inc/clean_html.php';
		$cleanedHTML = transformHTML($in_text,   '|div|', dirname(__FILE__).'/xsl/html2mid.xsl', $prefix);
		// Need to check for throws and bail out if going badly

		// Log the intermediate instance in the staging folder
		$cfile = $targPath.'/proto.xml';
		file_put_contents($cfile, $cleanedHTML);
		$cleanedhtml_message = 'Intermediate format: <a href="'.$cfile.'" target="_blank">proto.xml</a>.<br/>';
		
		if ($cleanedhtml_message == '') {
			// Act on bailout condition
		} else {
			// Proceed to final stage: Transform the intermediate into DITA 
			$parseopts = LIBXML_NOCDATA;
			$resultXML = transformXML($cleanedHTML, dirname(__FILE__).'/xsl/mid2dita.xsl', $parseopts); 
			// Need to check for throws and bail out if going badly

			// Log the final map in the staging folder (topics are already there)
			$outputmapname = 'asdf';
			$ffile = $targPath.'/'.$outmapname.'.ditamap';
			file_put_contents($ffile, $resultXML);
			$resultxml_message = 'Collection of migrated topics: <a href="'.$ffile.'" target="_blank">'.$outmapname.'.ditamap</a>.<br/>';

			if ($resultxml_message == '') {
				// Act on bailout condition
			} else {
				// Create zip and copy into result folder
				$ofiles = glob($targPath.'/*.*');// use braces to limit filetypes
				$zipstatus = zip_files($ofiles, $zip_name);
				$zfile = $targPath.'/'.$zip_name;
				rename($zip_name, $zfile);
				$zip_message = 'Download link for zipped results: <a href="'.$zfile.'">here</a>.<br/>';

				switch($previewType) {
					case 'preview':
						$parseopts = LIBXML_DTDLOAD | LIBXML_DTDVALID | LIBXML_ERR_WARNING | LIBXML_DTDATTR;
						$linkedmap = transformXML($resultXML, dirname(__FILE__).'/xsl/preview.xsl', $parseopts); 
						$linkedmap = '<div>'.$linkedmap.'</div>';
					break;
					case 'verbatim':
						$parseopts = LIBXML_NOCDATA;
						$linkedmap = transformXML($resultXML, dirname(__FILE__).'/xsl/verbatim.xsl', $parseopts); 
						$linkedmap = '<pre>'.$linkedmap.'</pre>';
				}
				//$preview_message = 'Sample the results: <a href='.$ffile.'" target="_blank">'.$outmapname.'.ditamap</a><br/>';
				$preview_message = $linkedmap;
			}
		}
		
		// Wrap up: notify the user and provide a link to the file.
		// Reference: http://stackoverflow.com/questions/8328983/php-check-if-an-array-is-empty
		// Reference: http://forums.phpfreaks.com/topic/144592-delete-file-immidiately-after-download/ ("immidiately" is part of the URL; don't fix it!)
		ob_start();
		$rollup_message = 'Results for: '. $msg.'.<br/>'; 
		//echo "JOBID: $job_id<br/>";
		echo $rollup_message;
		echo $intext_message;
		echo $cleanedhtml_message;
		echo $resultxml_message;
		echo $zip_message;
		echo 'Image resources to copy:<ul>';
		foreach($imglist as $pic) {
			echo '<li><a href="'.$pic.'" target="_blank">'.$pic.'</a></li>';
		}
		echo '</ul>';
		echo $preview_message;

		//echo hook_filter('preview',array());
		$output = ob_get_contents();
		ob_end_clean();
		return $output;
	}


	if (isset($_GET['xform'])){
		// new mode, but not tested and may not be left here.
		//$targPath = 'STAGE/zip8852/';
		echo 'Something easy to search for in case this ever gets executed: unilateral<br/>';
		$resultXML = file_get_contents($_GET['xform']);
		$parseopts = LIBXML_DTDLOAD | LIBXML_DTDVALID | LIBXML_ERR_WARNING | LIBXML_DTDATTR;
		$result = transformXML($resultXML, dirname(__FILE__).'/xsl/'.$previewType.'.xsl', $parseopts); 
		echo $result;
	};

}

?>