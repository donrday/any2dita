<?php


// XML-specific setup: nable as needed (TBD: Need to put these into a hook_action('init) to pick up only as needed)

register_action('init', 'xml_setup');
function xml_setup() {
	//echo 'XML_CATALOG_FILES: '. XML_CATALOG_FILES . '<br/>';
	// (on Linux, the any2dita plugin requires this if the dita plugin has not also been installed and activated)
	//$xmlcatalogFile = "../../etc/xml/catalog";
	//putenv('XML_CATALOG_FILES='.$xmlcatalogFile);
	// Make sure that PHP 5.4+ defaults for XSLT security are properly set (new, undocumented function in newest PHP).
	//echo 'PHP_VERSION: '. PHP_VERSION . '<br/>';
	//define ('XSL_SECPREFS_NONE', 0); // already defined in xml plugin. should it be universal, or as fully self-sufficient plugin? Conflicts?
}

// Primary XSLT-based transform point for any2DITA. Paramters passed are not the same as for regular expeDITA processing.
function transformXML($sXml, $sXsl, $parseopts=LIBXML_NOCDATA) { 
	global $prefix, $a2dxsl, $outproc, $targPath, $fullpath, $queryPath, $outputpath, $patchpath;

	// Turn on error tracking method in libxml:
	libxml_use_internal_errors(true);
	// Load the source doc
	$XML = new DOMDocument(); 
	$XML->loadXML( $sXml , $parseopts);
	// Start the transform
	$proc = new XSLTProcessor(); 
		// Check for write extensions in PHP compile:
		if (!$proc->hasExsltSupport()) {
		    die('EXSLT support not available');
		}

		// Ever since PHP 5.4, permissions are required to write from within the XSLT:
		// http://forums.phpfreaks.com/topic/256913-xslt-problem-with-exslt-document-tag/
		// http://superuser.com/questions/384300/fix-for-php-5-3-9-libxsl-security-bug-fix/488921#488921
		if (version_compare(PHP_VERSION,'5.4',"<")) {
			$oldval = ini_set("xsl.security_prefs",0);
		} else {
			$oldval = $proc->setSecurityPrefs(0); // NOT setSecurityPreferences!
		}
	// Load the transform rules
	$XSL = new DOMDocument(); 
	$XSL->load( $sXsl, LIBXML_NOCDATA | LIBXML_ERR_WARNING );
	$proc->importStylesheet( $XSL ); 
	$proc->setParameter('', 'targPath', $targPath);
	$proc->setParameter('', 'queryPath', $patchpath);
	$proc->setParameter('', 'fullpath', $fullpath);
	$proc->setParameter('', 'outputpath', $outputpath);
	$proc->setParameter('', 'patchpath', $patchpath);
	$proc->setParameter('', 'outproc', 'topic');// $outproc
	$proc->setParameter('', 'prefix', $prefix);
	$out = $proc->transformToXML( $XML ); 
		//go back to the old setting. Better safe than sorry
		if (version_compare(PHP_VERSION,'5.4',"<")) {
		    ini_set("xsl.security_prefs",$oldval);
		} else {
		    $proc->setSecurityPrefs($oldval);
		    //or just do '$xslt = null;' to get rid of this object
		}
	    $errors = libxml_get_errors();
	    foreach ($errors as $error) {
	        echo display_xml_error($error, $sXml).'<br/>';
	    }
	    libxml_clear_errors();
	return $out;
} 


// from PHP manual on libxml-get-errors
function display_xml_error($error, $xml)
{
    $return  = $xml[$error->line - 1] . "\n";
    $return .= str_repeat('-', $error->column) . "^\n";

    switch ($error->level) {
        case LIBXML_ERR_WARNING:
            $return .= "Warning $error->code: ";
            break;
         case LIBXML_ERR_ERROR:
            $return .= "Error $error->code: ";
            break;
        case LIBXML_ERR_FATAL:
            $return .= "Fatal Error $error->code: ";
            break;
    }

    $return .= trim($error->message) .
               "\n  Line: $error->line" .
               "\n  Column: $error->column";

    if ($error->file) {
        $return .= "\n  File: $error->file";
    }

    return "$return\n\n--------------------------------------------\n\n";
}


// These zip "CRUD" routines could be used, but are not for now; the current logic works. Leave for possible use later.

function save_to_zip($zip_name) {
	global $targPath;
	// copy migration result files into this temporary folder
	//copyToDir('./TEMP/*.*', $targPath);
	
	// Assign array of filenames in the folder.
	$files = glob($targPath.'/*.*');// use braces to limit filetypes
	var_dump($files);

	// Wrap up: notify the user and provide a link to the file.
	//$zipstatus = zip_files($files, $zip_name);
	
	if (zip_files($files, $zip_name)) {
		//echo "Your file is ready <a href='$targPath'>here</a>. Return code '$result'<br/>";
		header('Content-Type: application/octet-stream');
		header('Content-Disposition: attachment; filename='.urlencode($zip_name));
		header('Content-Transfer-Encoding: binary');
		readfile($zip_name);
	    zip_delete($targPath);
		ignore_user_abort(true);
		if (connection_aborted()) {
			unlink($zip_name);
		} 
		header('Location: '.$_SERVER['PHP_SELF']);
		exit;
	} else {
		echo 'No files created.<br/>';
	}
	// End of logic; do not echo any more output here.
}

function zip_files($files, $zip_name) {
	// Now initialize the zip method and run that process.
	$zip = new ZipArchive();
	
	if($zip->open($zip_name, ZIPARCHIVE::CREATE)!==TRUE){
	    $error .= "* Sorry ZIP creation failed at this time";
	}
	
	// We trust that the input list is valid, since it was built by query.
	foreach($files as $file){
		$fstuff = pathinfo($file);
		$filename = $fstuff['filename'].'.'.$fstuff['extension'];
	    //$zip->addFile($file);
		$zip->addFile($file, $filename);
	}
	
	$zip->close();
	return file_exists($zip_name);
}


// Perform garbage collection...
// http://stackoverflow.com/questions/1334398/how-to-delete-a-folder-with-contents-using-php
function zip_delete($path) {
    if (is_dir($path) === true) {
        $files = array_diff(scandir($path), array('.', '..'));
        foreach ($files as $file)
        { zip_delete(realpath($path) . '/' . $file); }
        return rmdir($path);
    } else if (is_file($path) === true) {
	    return unlink($path);
	}
	return false;
}


/* temp support mimicking the actual conversion results */
// http://stackoverflow.com/questions/2050859/copy-entire-contents-of-a-directory-to-another-using-php
function copyToDir($pattern, $dir)
{
    foreach (glob($pattern) as $file) {
        if(!is_dir($file) && is_readable($file)) {
           // $dest = realpath($dir . DIRECTORY_SEPARATOR) . basename($file);
           $dest = realpath($dir ) . DIRECTORY_SEPARATOR . basename($file);
            copy($file, $dest);
        }
    }    
}

?>