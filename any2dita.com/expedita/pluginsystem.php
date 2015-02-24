<?php
/* plugins system include file.
This file includes the complete plugins system definition and its internal diagnostics.
*/
/*
Registers hooks in:
pluginsPath
//vendorPath
contentPath
themesPath
*/

//Plugins info
// CONFIG #PLUGIN: set these values to the relative offset of plugins folder outside of pkg
//$pluginsOffset = SYSTEM_FOLDER.'';// normally this can live directly in the system folder (ie, 'expedita/');
//$pluginsDir = 'plugins';

function pluginsPath() {
	global $pluginsOffset, $pluginsDir;
	return SYSTEM_FOLDER."$pluginsDir/";
}

/* Set some key module global vars */

// Collect data for later replay
$eventlog = '';

//Arrays to store user-registered events and functions.
$action_events = array();
$filter_events = array();

/* Hook diagnostics */

if ($debug == 'yes') {
	register_action('exit','hookreport');
}
register_action('api_hookreport','hookreport'); // declare for independent query: hook_action('hookreport');

function hookreport() {
	global $eventlog;
	echo "Hook calls:<pre>";
	var_dump($eventlog);
	echo '</pre>';
}

// Turn on trace of hook loading.
if ($debug == 'yes') {
	register_filter ('trace', 'hooktrace');
}
register_action('api_hooktrace','hooktrace'); // declare for independent qeury: hook_action('hooktrace');

function hooktrace($tmsg) {
	echo $tmsg;
	return $tmsg;
}


/* Load hooks from various installed locations: core, content, themes */

$_SESSION['currentMap'] = ''; // Session vars in plugins must be declared here before the plugins are read.

// Load Core Plugins (mostly actions)
plugin_load_application(pluginsPath());
//plugin_load_application(vendorPath());

// Load Content Plugins (deal with the I/O and renditions)
plugin_load_content(contentPath());

// Note that the theme-context loader is in groupconfig.php AFTER the prefs have been called (and after processing get[themeName]!)
// This ensures that only the applicable theme has been loaded.
// This call (in groupconfig) is currently the only plugin-specific call relocated outside of this file.
 
hook_action('initialize');
//$args = array(&$somedata);
//hook_action('onChange', $args);

// Generate a readout of available hooks
if ($debug == 'yes') {
	report_hooks('filter_events,action_events');
}

/* ------------------------ library ---------------------------- */

// Load plugins from various locations:

function plugin_load_application($lookup) {
	// get single-file plugins at the root of the folder
	$pattern = $lookup."*.php";
	$plugins = glob($pattern);
	hook_filter('trace',  'get plugins: '.$pattern.'</br/>');
	// Note that until core.php is read, this hook is inoperative. Core defines the trace hook.
	sort($plugins,SORT_STRING); // rsort for descending
	foreach($plugins  as $plugin) {
		hook_filter('trace', "-- ".$plugin.'</br/>');
		//if (($plugin == 'plugins/core.php') || ($plugin == 'plugins/customize.php')) {
			require_once $plugin;
		//}
	}  
	// get plugins grouped by wildcard folder
	$pattern = $lookup."*/*.php";
	$plugins = glob($pattern);
	sort($plugins,SORT_STRING); // rsort for descending
	hook_filter('trace',  'get plugins: '.$pattern.'</br/>');
	foreach($plugins as $plugin){
		hook_filter('trace', "-- ".$plugin.'</br/>');
		require_once $plugin;
	}
}

function plugin_load_content($lookup) {
	$pattern = $lookup."plugins/*.php";
	$plugins = glob($pattern);
	sort($plugins,SORT_STRING); // rsort for descending
	hook_filter('trace',  'get plugins: '.$pattern.'</br/>');
	foreach($plugins as $plugin) {
		hook_filter('trace', "-- ".$plugin.'</br/>');
		//if (($plugin == 'plugins/core.php') || ($plugin == 'plugins/customize.php')) {
			require_once $plugin;
		//}
	}  
}

function plugin_load_theme($lookup) {
	global $themesOffset, $themesDir;
	// find any general hook routines for themes
	$pattern = $themesOffset.'/'.$themesDir."/*.php"; 
	$plugins = glob($pattern);
	sort($plugins,SORT_STRING); // rsort for descending
	//hook_filter('trace',  'get plugins: '.$pattern.'</br/>');
	foreach($plugins as $plugin) {
		//hook_filter('trace', "-- ".$plugin.'</br/>');
		require_once $plugin;
	}  

	// find hook routines that are specific to current theme
	$pattern = $lookup."defs/plugins/*.php";
	$plugins = glob($pattern);
	sort($plugins,SORT_STRING); // rsort for descending
	hook_filter('trace',  'get plugins: '.$pattern.'</br/>');
	foreach($plugins as $plugin) {
		hook_filter('trace', "-- ".$plugin.'</br/>');
		//if (($plugin == 'plugins/core.php') || ($plugin == 'plugins/customize.php')) {
			require_once $plugin;
		//}
	}  
}

// Administer the plugins

function report_hooks($intypes) {
	global $filter_events, $action_events;
	$types = explode(',',$intypes);
	echo '<h2>Registered hooks</h2>';
	foreach ($types as $type) {
		echo '<b>'.$type.'</b><br/>';
		if ($type == 'filter_events') my_dump($filter_events);
		if ($type == 'action_events') my_dump($action_events);
		echo '<br/>';
	}
}
function my_dump($events) {
	foreach ($events as $key => $event) {
		echo 'hookname: '.$key.' <br/>';
		//var_dump($event);
		foreach ($event as $hookkey => $hookname) {
			echo '&nbsp;&nbsp;&nbsp; hook function: '.$hookkey.': '.$hookname.'<br/>';
		}
	}
}

// Register the plugins
//if($event == 'select_theme') {echo $func;var_dump($action_events);exit;}

function register_action($event, $func)
{
	//return register_filter($event, $func);
    global $action_events,$eventlog;
    $action_events[$event][] = $func;
    $eventlog['registered action'][] = $event.'/'.$func;
}
 
function register_filter($event, $func)
{
    global $filter_events,$eventlog;
    $filter_events[$event][] = $func;
    $eventlog['registered filter'][] = $event.'/'.$func;
}

function unregister_action($event, $func)
{
    global $action_events,$eventlog;
    $i = 0;
    foreach($action_events[$event] as $item) {
    	//echo $item.':'.$i.'<br/>';
    	if($item == $func) {
	    	unset( $action_events[$event][$i]);
	    	break;
	    }
    $i++;
    }
    $eventlog['unlink action'][] = $event.'/'.$func;
}

function unregister_filter($event, $func)
{
    global $filter_events,$eventlog;
    $i = 0;
    foreach($filter_events[$event] as $item) {
    	if($item == $func) {
	    	unset( $filter_events[$event][$i]);
	    	break;
	    }
    $i++;
    }
    $eventlog['unlink filter'][] = $event.'/'.$func;
}

// Actuate the plugins

function hook_action($event, array $args = array()) {
    global $action_events,$eventlog, $debug;
//if($event == 'select_theme') {var_dump($action_events);exit;}
	if ($debug == 'yes') {echo "<b style='color:maroon;'>IN HOOK_ACTION $event</b><br/>";}
    if(isset($action_events[$event])) {
        foreach($action_events[$event] as $func) {
    		$eventlog['invoked action'][] = "action: $event - $func";
 			if ($debug == 'yes') {echo "<b style='color:maroon;'>...action: $event - $func</b><br/>";}
           if(!function_exists($func)) {
                die('Unknown function: '.$func);
            }
			call_user_func_array($func, $args);
			//call_user_func_array($func, array('parameter one', 'parameter two'));
		}
    }
 	// no return on actions
}
 
function hook_filter($event,$content) {
    global $filter_events, $eventlog, $debug;
	if ($debug == 'yes') {echo "<b style='color:darkgreen;'>IN HOOK_FILTER $event</b><br/>";}
    if(isset($filter_events[$event])) {
        foreach($filter_events[$event] as $func) {
			$eventlog['invoked filter'][] = "filter: $event - $func";
			if ($debug == 'yes') { echo "<b style='color:darkgreen;'>...filter: $event - $func</b><br/>";}
			if(!function_exists($func)) {
                die('Unknown function: '.$func);
            }
			$content = call_user_func($func,$content);
        }
    }
    return $content;
}
 
function hook_filter_orig($event,$content,$arg='') {
    global $filter_events, $eventlog;
    if(isset($filter_events[$event])) {
        foreach($filter_events[$event] as $func) {
			$eventlog['invoked filter'][] = "filter: $event - $func";
			if(!function_exists($func)) {
                die('Unknown function: '.$func);
            }
			$content = call_user_func($func,$content,$arg);
        }
    }
    return $content;
}



/*
// http://stackoverflow.com/questions/5127424/how-does-plugin-system-work-wordpress-mybb
// http://stackoverflow.com/questions/8336308/how-to-do-a-php-hook-system
// http://stackoverflow.com/questions/3356275/observer-pattern-logic-without-oop
// http://programmers.stackexchange.com/questions/184664/mvc-pattern-on-procedural-php
// http://www.failover.co/blog/writing-pluggable-php-application-part-1 (informative) , 2, 3

Hook locations to develop:
System:
	router logic
	init
	exit
	msg
	include
	filter JS/CSS on load to replace [shortcode] placeholders
Content Database (CRUD):
	new (topic, map, etc.)
	get (topic, map, query/search results, etc.)
	save/update
	delete
	revert
	table/field operations
	result filters: whitelists, blacklists, sorts, "notching", joins, etc.
Comments Database:
	same considerations
Users Database:
	same considerations
Renderers:
	(manage rendition settings)
	JSON
	XML
	Markdown & variants
	text
	YAML, etc.
Content:
	Conditionality
	analysis
	markers 
	link normalization
	alternate XSL
	xpd features
	DITA templates
	update metadata across group
	define group policies
Media:
	upload/delete/munge
	caption position (former OT style hints for xforms)
	size defaults
	resize directives
Commenting:
	approve/delete
Logging:
	logmsg (queue a message for later rendering/logging in a file)
Group:
	set/update _prefs info
	set up site information (names, theme, site type, header, banner, etc.)
Theme:
	Template (page type logic, etc.)
	Widget (wrap, counters, aggregators, sorts)
	Model/View/Controller interfaces
	Admin 
	Other
Member:
	register
	remove
	validate
	reset data
	query by name, wildcard, role, activity, etc.
XML:
	catalog paths or alt names
	run-time LIBXSL options (validate, etc.)
	debug options
	integrate new DTD libraries
	XSL run-time parameters (stylesheet, other proc passing)
Editor:


Security: 
	role assignments
	(some auth is already indicated as a Member hook; does security stand alone or integrate?)

*/

?>