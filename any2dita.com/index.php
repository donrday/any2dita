<?php
/*
Prereqs for Apache:
latest Wampserver (64bit PHP5.5)
c:/wamp/bin/apache/apache2.4.9/conf/httpd.conf : undo the # comment marker for 
	LoadModule rewrite_module modules/mod_rewrite.so
Set up DTDs (xml.zip or DITA Open Toolkit in the 1.5.x series (DITA 1.1 level DTDs)
*/
session_start(); 
if(!isset($_SESSION['exists'])){
    // New session actions:
}
$_SESSION['exists'] = true;

// INSTALLERS! Please observe the CONFIG: steps for possibly important configuration setup values.
// For Linux, enable defaultTheme below (might be better to move the GET checking into groupconfig.php)
$defaultThemeName = 'vasile'; // sometimes this does not pick up in first installs; enable as needed.
// MUST define the SERVERNAME constant.
// MAY need to adjust INSTALL_FOLDER (null if in root; path if unzipped in a folder)

// CONFIG #ERRORS: Use TRUE when deploying for production use; use FLLSE to allow dev messages to show.
define('IN_PRODUCTION', FALSE); 

if (IN_PRODUCTION) {
	ini_set("display_startup_errors", "Off");
	ini_set('display_errors', 'Off');
	error_reporting(E_ERROR);
	// Explicitly turn off any global trace or debug activity when system is in production mode.
	$debug = 'no';
} else {
	ini_set("display_startup_errors", "On");
	ini_set('display_errors', 'On');
	error_reporting(E_ALL);
	$debug = 'no';
}


//Package defaults

// CONFIG #HOST: set this to the hostname by which URLs will access this application  (e.g., 'http://jotsom.com')
define('SERVERNAME', 'http://localhost'); // http://any2dita.com

// CONFIG #OFFSET: Set this to the nested folder path up to the system folder.
// Note: avoid using folder names that are protected or same as group names (hack vector: need to vet names against whitelist)
// Use null '' if installed in server root.
define('INSTALL_OFFSET', '');

// Normally not changed; this folder holds the code that defines expedita function.
define('SYSTEM_FOLDER', INSTALL_OFFSET.'expedita/'); 

// CONFIG #FOLDER: Set this to the installed folder path relative to server root
define('INSTALL_FOLDER', '/any2dita.com/'); 

define('BASE_URL',  SERVERNAME.INSTALL_FOLDER);//.domain plus url path we need to pass to all relative addresses


// CONFIG #APP: set these values to the relative names and offset of App folder outside of pkg (fully unused yet? deprecated!)
$appOffset = INSTALL_OFFSET.''; // 'pkg/'
$appDir = '.'; // 'App'

// CONFIG #CONTENT: set these values to the relative names and offset of Content folder outside of pkg
$contentOffset = INSTALL_OFFSET.''; // peer to index folder
$contentDir = 'Content';

// CONFIG #THEMES: set these values to the relative names and offset of Theme folder outside of pkg
$themesOffset = INSTALL_OFFSET.''; // peer to index folder
$themesDir = 'Themes';

// CONFIG #VENDOR: set these values to the relative names and offset of Vendor folder outside of pkg
$vendorOffset = INSTALL_OFFSET.''; // peer to index folder
$vendorDir = 'Vendor';

// CONFIG #PLUGIN: set these values to the relative offset of plugins folder outside of pkg
$pluginsOffset = SYSTEM_FOLDER.'';// normally this can live directly in the system folder (ie, 'expedita/');
$pluginsDir = 'plugins';

// Resource names
$appdbPath = 'groups.db'; // This path is used only for login. Full model should cover members, content, comments... 
$dbname = 'base.db'; // This path is for content.


// Get runtime settings.
require_once SYSTEM_FOLDER.'appconfig.php';

//include files for adding plugin functionality. These depend on vars and functions defined in appconfig for ease of setup.
// CONFIG #PLUGIN: Edit the following file to update its config path, if changing from the default $appOffset path.
require_once SYSTEM_FOLDER.'pluginsystem.php';

hook_action('init');

// Apply parameter queries
require_once SYSTEM_FOLDER.'frontlogic.php';

// Decompose the URL, type the segments, and assign controllers.
require_once SYSTEM_FOLDER.'router.php'; 


// At this point, we know all we'll know about the query and could start some preliminary processing.

// Separate configs for users and resources (router has given us groupName by now)
if ($groupName == 'users') {
	// Get user management settings
	///require_once SYSTEM_FOLDER.'memberconfig.php';
//} elseif () {} ...could add other config categories later.
} else {
	// Get group-specific settings.
	require_once SYSTEM_FOLDER.'groupconfig.php'; 
} 


// Now we get into the application proper, so the path changes from the install folder to the appalication folder $appDir.


// "Model" - load business logic to use on requests
// Hook to load model (data manipulation) functions in advance of their use.
hook_action('load_model');// Not developed yet (need to load or rename "pkg/plugins/action_headless).
///require_once INSTALL_OFFSET.'Model/sqlib.php';
require_once SYSTEM_FOLDER.'Model/filelib.php';

// Hook for headless (non-GUI or non-content) CRUD processing requests against the model.
hook_action('load_actions');// Not developed yet (need to load or rename "pkg/plugins/action_headless).
///require_once INSTALL_OFFSET.'Model/CRUDlogic.php';
require_once SYSTEM_FOLDER.'functions.php';


// "View" - Render data by appType (api, site, blog, wiki, etc.):
// For extended expeDITA apps, the appType may name a more particular controller and its data/views (eg, wikiController).
if ($appType == 'api') {
	// No ops for now
	hook_action('load_nonsite'); // not developed yet
	// Call the controller selected by the router
	// Fetch and render request...
} else {
	hook_action('load_site'); // not developed yet
	require_once SYSTEM_FOLDER.'View/viewconfig.php';  // Defines template insertion points: content(), footer(), endpoint(), etc..
	require_once SYSTEM_FOLDER.'View/UIfunctions.php';

	// Set up theme dependencies and inner styles.
	require_once themePath().'defs/themeconfig.php';
	require_once themePath().'defs/viewconfig.php'; // specific to theme

	// Call the controller selected by the router
	// $controller names a function defined in routes.php.
	hook_action('content_request'); // This hook allows alternate routing patterns to override the default for Jotsom.
	if(is_callable($controller)) {  
	  	$post = $controller();
	} else {
		$post['content'] = $controller.' is not available.'; // This needs 404 logic. Redirect as best course?
	}

	// Result content is instanced into the chosen template's current area types and user controls.
	hook_action('page_load');
	hook_action('template_init');
	require_once themePath().'defs/template.php';
	hook_action('page_exit');
}

// Enable some end-of-page diagnostic/demo widgets, etc.. 

//hook_action('ui_tools');
//hook_action('select_theme');
//hook_action('select_xtype');
//hook_action('show_comments'); //showCategories();
//hook_action('select_author'); showAuthors();
//hook_action('exit');

?>