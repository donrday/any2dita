<?php
// Control for looking at entire application's debug hook messages. 
// This can be set 'no' here, but 'yes' in any module that needs local value tracing.
// This is a candidate for a hook to define a scoped debug to turn on from here, rather than by editing at the module.
$debug = 'no';
// Dev default for authorization for existing auth-enabled code. Remove once login is restored.
$auth = TRUE; $_SESSION['auth'] = true; $_SESSION['authgroup'] = '*';
// Theme-specific control for turning on demo mode UI bits.
$showUI = 'yes'; // 'yes' = turn on demo toolbar on top; 'no' = standard view for a fixed application.
// General interface flags
$showCustom = ''; // Intended to conditionally support non-DITA XML content in admin view.
// get/post defaults
$defaultXtype = 'post';
$defaultGroupName = 'any2DITA';

$appType = 'any2dita';

$siteURL = BASE_URL; // imagine needing to look back to home. Redundant.
$siteURL2 = strtok($_SERVER['REQUEST_URI'], '?'); // used only when parameter queries need to be stripped off


//Application info: Used to point unambiguously to the single location of group profile, backup folders, content folder/db, etc..
function appPath() {
	global $appOffset, $appDir;
	return "{$appOffset}$appDir/";
}

// Declare this early to be available for dependencies
function vendorPath() {
	global $vendorOffset, $vendorDir;
	return "{$vendorOffset}$vendorDir/";
}

// This value is needed for the plugin system
function contentPath() {
	global $contentOffset, $contentDir, $groupName;
	return "{$contentOffset}$contentDir/$groupName/";
}

/* Functions for adjusted path names */
function basePath() {
	return BASE_URL;
}


// Some defaults used to fulfil required vars downstream from here:
//$defaultGroup = 'Jotsom'; // effectively also the name of the installed application
//$defaultGroup = 'ditaperday'; // effectively also the name of the installed application


/* Predeclare/document some vars passed via XSLT proc */
// Path constants/delims inserted into URLs, etc.
$up['baseurl'] = '..';
$mediapath = $up['baseurl'] . '/';

// User prefs (DITA OT run time rendering choices; add more as supported)
$showConrefMarkup = '';
$GENERATEOUTLINENUMBERING = '';
$SHOWTOPIC = '';

// Context properties (dynamic states passed into transforms)
$prefix = '';
$context = 'widget';

// Theme-specific properties (will be reset by theme properties)
$htmltype =  'HTML5';
$widgetlevel1 =  '3';
$widgetclass1 =  '3';
$headlevel1 = '1';
$classlevel1 = '1';
// END of XSLT proc vars

// Set up the router:

// TEST: this data will go into the prefs
// for http://domain.com/([app]/)([serviceType]/)[groupName]/[queryType]/[resourceName]/parameters...
// $config[$groupName]['segparts'] = array('app','groupName','queryType','resourceName');
$segparts = array('app','groupName','queryType','resourceName');


/* start of moved appconfig setup */


/* ======================== functions defined for core logic ===================== */

// A one-time setup command (primarily for installer module):
//usage: mkdir_if_needed($contentDir);

// from http://stackoverflow.com/questions/2904566/how-to-find-the-directory-already-is-there-or-not-in-php
function mkdir_if_needed($path) {
  if (!is_dir($path)) {
  	//echo 'no dir';
    // Watch out for potential race conditions here
    mkdir($path);
  } else {
  	//echo 'is dir';
  }
}

// what should be a user-preferred function for encrypting passwords...
function hashme($pw) {
	global $salt;
	//if ($salt == '') exit("Need to assign a non-null value for security salt in the site config file.");
	//$zpw = md5($pw.$salt);
	$zpw = md5($pw);
	return $zpw;
}

// support for file-based DB query sorting callbacks
function sortBy(&$items, $key){
  if (is_array($items)){
    return usort($items, function($a, $b) use ($key){
      return strCmp($a[$key], $b[$key]);
    });
  }
  return false;
}

/* Sort callbacks; use lowercase to force single collation sequence. */
function sort_ascending($a,$b) {
	return strtolower($a['title']) > strtolower($b['title']);
}

function sort_descending($a,$b) {
	return strtolower($a['title']) < strtolower($b['title']);
}
/* end of appconfig setup */




// Initialize session vars (changes are handled in frontlogic.php)
if (!isset($_SESSION['serviceType'])) {
	$serviceType = 'about';
	$_SESSION['serviceType'] = $serviceType;// initialize session
} else {
	$serviceType = $_SESSION['serviceType'];
}

// was itemdefs


function keyfrom($slug) {
	$page['about'] = 15;
	$page['admin'] = 28;

	$key = $page[$slug];
	//echo "SLUG-slug: $slug / $key<br/>";
	return $key;
}

/* some test data, still valid addresses in test DB
	$page['home'] = 8;
	$page['news'] = 21;
	$page['contact'] = 17;
	$page['services'] = 18;
	$page['login'] = 19;

	$page['projects'] = 26;
	$page['tour'] = 27;
*/


?>