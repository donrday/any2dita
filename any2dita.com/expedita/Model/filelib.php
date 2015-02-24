<?php

$db_dir = getcwd();
$dbname = 'comments.txt';
$mytable ="posts";

// Check for filedb support
//if (!file_exists($dbname)) die("File $dbname not extant.");

function xdb_write($title,$author,$timestamp,$content) {
	global $dbname;
	// Get write handle (not needed for read)
	@$fp = fopen($dbname, 'a');
    if (!$fp) {
        //The file could not be opened
        $opstatus = "The comment data file could not be opened.";
    } else {
        //The file was successfully opened, lets write the comment to it.
        $outputstring = "<hr/><h3>" .$title. "</h3><p>Posted:" .$timestamp. " by " .$author. "</p><p>" .$content. "</p>\r\n";
        //Write to the file
        fwrite($fp, $outputstring, strlen($outputstring));
        //We are finished writing, close the file for security / memory management purposes
        fclose($fp);
        //Post the success message
        $opstatus = "Your post was successfully entered.";
    }
    return $opstatus;
}

function db_readmany($id='*') {
	global $dbname, $mytable, $collectionType, $xmlpath;
	//echo "$collectionType($xmlpath)";
	echo hook_action('mytopiclist',array());
}

function db_readone($id='*') {
	global $dbname, $mytable, $collectionType, $xmlpath;
	//echo "$collectionType($xmlpath)";

	if ($id == '*') {
		return;
	} else {
		$querystring = " WHERE (post_id=$id)";
	}

	$queryType = 'topic';
	$dx[15] = 'any2dita.dita';
	$dx[28] = 'migrate.dita';
	$xmlpath = $dx[$id];
	
	//$outstream = hook_action('xform_stream',$srcstream);
	$outstream = hook_filter('trydita2html',array($xmlpath));//tiny implementation now in plugin_ditaxform.php
	$row['post_id'] = $id;
	$row['post_title'] = '';
	$row['post_content'] = $outstream;
	$row['post_author'] = '';
	$row['post_date'] = '';
	$row['guid'] = $id;

	return $row;
}

function xdb_read($id) {
	global $dbname;
	ob_start();
	include $dbname; 
	$output = ob_get_contents();
	ob_end_clean();
	return $output;
}

$ccmd = 'read';
if ($ccmd == 'create') {
}

// Read
if ($ccmd == 'read') {
	//include("comments.txt"); 
}

// Insert
if ($ccmd == 'insert') {
        //The file was successfully opened, lets write the comment to it.
        $outputstring = "<hr/><h3>" .$title. "</h3><p>Posted:" .$timestamp. " by " .$name. "</p><p>" .$message. "</p>\r\n";
        //Write to the file
        fwrite($fp, $outputstring, strlen($outputstring));
        //We are finished writing, close the file for security / memory management purposes
        fclose($fp);
        //Post the success message
        $output = "Your post was successfully entered.";
}

// Delete
if ($ccmd == 'delete') {
}
?>