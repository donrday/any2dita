<?php

// Data for presumed groupName 'any2dita'
// group lookup (as if read from _prefs)
$siteName ='Any2DITA';
$siteSlogan = 'New lamps for old';
$siteOwner = 'Don Day';
$defaultThemeName = 'vasile';

$serviceTypes  = array('about','admin');

$config['about']['sidebarItems'] = 'pages';
	$config['about']['label'] = 'About any2DITA';
	$config['about']['url'] = '?tab=about';

$config['admin']['sidebarItems'] = 'categories2,stagedlist';//,themesel,cats,xtypesel,sites';
	$config['admin']['label'] = 'Migrate';
	$config['admin']['url'] = '?tab=admin'; // no leading slash! these must inherit the page context.



/* "Group definitions" (these depend on the $groupName as a valid location) */

function groupPath() {
	global $groupName;
	// Normally groupname is bound here. Not needed for any2dita, a single application.
	return BASE_URL;
}

// Used to house common theme support code (sliders and shortcodes, especially)
function commonPath() {
	global $themesOffset, $themesDir, $themeName;
	return "{$themesOffset}$themesDir/$themeName/";
}

function themePath() {
	global $themesOffset, $themesDir, $themeName;
	return "{$themesOffset}$themesDir/$themeName/";
}

function pagePath($id) {
	global $siteURL;
	$pagepath = SITE_URL.'?page='.$id;
	return $pagepath;
}


?>