<?php

// Page-filling functions for /any2dita version of code
// Note that this file is a minimal implementation for serving the any2dita test application.

function primary() {
	global $status, $tabType, $serviceType, $pagenum;
	show_resource($pagenum,'sidebaritem');
	if ($tabType == 'admin') {
		hook_action('a2d_form');
		echo hook_filter('any2dita',array());
		//hook_action('stagedlist');
	}
}

function secondary2($itemlist='search') {
	global $collectionType;
global $itemdefs;
	$ct = explode(':',$collectionType)[0];
	show_resource(24,'sidebaritem');
?><?php view_secondary_page($itemdefs['new']);?><?php
}

function secondary($inlist='null') {
global $config,$itemdefs,$serviceType,$groupName;
if ($inlist == 'null') {
	if (!isset($config[$serviceType]['sidebarItems'])) $serviceType = 'about';
	$inlist = $config[$serviceType]['sidebarItems'];
}
$items = explode(',',$inlist);
// Now switch into the widget definitions for instancing...
// open ul
?>
<?php foreach($items as $item):?>
	<?php view_secondary_items($itemdefs[$item],'widget');?>
<?php endforeach;?>
<?php 
// closing ul
//hook_action('get_categories');?>
<?php
}

function view_secondary_items($args,$viewType) {
$c = 'view_secondary_'.$viewType;
$c($args);
}

/* secondary page contexts */

function view_secondary_listitem($args) {
	global $widgetlevel1;
	list($title,$func,$funcargs) = $args;
	?>
	<li>
		<h<?php echo $headlevel1;?>>
			<?php echo $title;?>
		</h<?php echo $widgetlevel1;?>>
		<?php call_user_func_array($func,array($funcargs));?>
	</li>
	<?php
}

function view_secondary_page($args) {
	list($title,$func,$funcargs) = $args;
	global $headlevel1;
	?>
	<div class="post">
		<h<?php echo $headlevel1;?>>
			<?php echo $title;?>
		</h<?php echo $headlevel1;?>>
		<div>
			<?php call_user_func_array($func,array($funcargs));?>
		</div>
	</div>
	<?php
}

function view_secondary_widget($args) {
	list($title,$func,$funcargs) = $args;
	global $widgetlevel1;
	?>
	<div>
		<h<?php echo $widgetlevel1;?>>
			<?php echo $title;?>
		</h<?php echo $widgetlevel1;?>>
		<div>
			<?php call_user_func_array($func,array($funcargs));?>
		</div>
	</div>
	<?php
}

function footer($sep='') {
global $siteOwner;
?>Copyright &copy; <?php echo $siteOwner;
echo $sep;
}

/* navigation views */

function navigation() {
	global $wrap, $tweaks, $serviceTypes,$config,$serviceType,$themeName;
	$serviceType = $_SESSION['serviceType'];
	$tabs = $serviceTypes;//explode(',',$serviceTypes);
	$last = sizeof($tabs); $position = 0;
	if ($wrap['outer'] != '') {echo '<'.$wrap['outer'].'>';}
	foreach($tabs as $tab) {
		$position++;
		$url = $config[$tab]['url'];
		$lbl = $config[$tab]['label'];

		$repeatclass = ($serviceType == $tab) ? $tweaks[$themeName]['activeprop'] : '';
		$anchorclass = (isset($tweaks[$themeName]['anchorclass'])) ? ' class="'.$tweaks[$themeName]['anchorclass'].'"' : '';
		$activeprop = ''; // for now

		$start_repeat = ($wrap['repeat'] != '') ? "<{$wrap['repeat']}{$repeatclass}>" : '';
		$end_repeat   = ($wrap['repeat'] != '') ? "</{$wrap['repeat']}>" : '';

		echo $start_repeat; // null or value
			echo "<a id=\"$tab\" title=\"$serviceType and $tab\" href=\"{$url}\" title=\"{$lbl}{$anchorclass}\">{$lbl}</a>";
		echo $end_repeat; // null or value
		if ($position != $last) {echo $wrap['sep'];}
	}
	if ($wrap['outer'] != '') {echo '</'.explode(' ',$wrap['outer'])[0].'>';}
}



// View data
function show_querylist() {
	global $pagenum, $mode, $collectionType, $xType, $targPath;
	$ct = explode(':',$collectionType)[0];
	if ($mode == 'read') {
		if ($ct == 'resource') {
		$stuff = db_readone($pagenum);
		} else {
		$stuff = db_readmany($pagenum);
		}
		foreach($stuff as $row) {
			//echo $ct.'<br/>';
			if ($ct == 'resource') {
				switch($xType) {
					case 'post':
						view_post($row);
					break;
					case 'page':
						view_page($row);
					break;
					default:
						view_rendition($row,$xType);
				}
			} elseif ($ct == 'collection') {
				view_postsummary($row);
			} else {
				view_page($row);
			}
		}
		if ($ct == 'collection') {view_create();}
	} else
	/*
	if ($mode == 'xform'){
		// new mode, but not tested and may not be left here.
		//$targPath = 'STAGE/zip8852/';
		//$folderPath = 'STAGE/zip8852/';
		echo 'Something easy to search for in case this ever gets executed: unilateral<br/>';
		$resultXML = file_get_contents($targPath.$pagenum);
		$parseopts = LIBXML_DTDLOAD | LIBXML_DTDVALID | LIBXML_ERR_WARNING | LIBXML_DTDATTR;
		$result = transformXML($resultXML, dirname(__FILE__).'/xsl/preview.xsl', $parseopts); 
		echo $result;
	} else */{
		$stuff = db_readone($pagenum);
		view_edit($stuff);
	}
}

function show_resource($pagenum,$viewType) {
	$stuff = db_readone($pagenum);
	$c = "view_$viewType";
	$c($stuff);
	//call_user_func_array($c, $stuff);
}


/* utilities */

// from http://stackoverflow.com/questions/317336/how-do-you-pull-first-100-characters-of-a-string-in-php
function summary($str, $limit=100, $strip = false) {
    $str = ($strip == true)?strip_tags($str):$str;
    if (strlen ($str) > $limit) {
        $str = substr ($str, 0, $limit - 3);
        return (substr ($str, 0, strrpos ($str, ' ')).'...');
    }
    return trim($str);
}

/* Content renderers */

function render_text($row){
$bit = <<<TEXT
id:{$row['post_id']}
title:{$row['post_title']}
content:{$row['post_content']}
TEXT;
return $bit;
}

function render_topic($row){
$bit = <<<TOPIC
<topic id="{$row['post_id']}">
<title>{$row['post_title']}</title>
<body>
{$row['post_content']}
</body>
</topic>
TOPIC;
return $bit;
}

// For db fetches, 'post' is the usual format. For DITA, this is more like 'dita2html'.
function render_html($row){
$bit = <<<HTML
<html>
<body>
<p>id="{$row['post_id']}"</p>
<h1>{$row['post_title']}</h1>
{$row['post_content']}
</body>
</html>
HTML;
return $bit;
}

function render_xml($row){
$bit = <<<XML
<doc>
<id>{$row['post_id']}</id>
<title>{$row['post_title']}</title>
<content>
{$row['post_content']}
</content>
</doc>
XML;
return $bit;
}
  
function render_json($row){
	$fileContents = render_xml($row);
	$fileContents = str_replace(array("&nbsp;", "\n", "\r", "\t"), '', $fileContents);
	$fileContents = trim(str_replace('"', "'", $fileContents));
	$simpleXml = simplexml_load_string($fileContents);
	$json = json_encode($simpleXml);
	return $json;
}
 
function render_markdown($row){
// For the content field, use https://github.com/nickcernis/html-to-markdown
$bit = <<<MDN
## <a name="{$row['post_id']}"></a>{$row['post_title']}

{$row['post_content']}
MDN;
return $bit;
}

/* dummy forms */

function form_navigation() {
// add subnav logic here using the actual serviceTypes
?>
<ul>
	<li><a href="#">Home</a></li>
	<li><a href="#">About</a></li>
	<li><a href="#">Services</a></li>
	<li><a href="#">Contact</a></li>
</ul>
<?php
}

function form_profile() {
?>
<p>Profile:... [logic needed for function form_profile]</p>
<?php
}

function form_sites() {
?>
<p>Sites:... [logic needed for function form_sites]</p>
<?php
}

function form_personalization() {
?>
<p>Personalization:... [logic needed for function form_personalization]</p>
<?php
}

function jotsommarkdown () {
?>
<p>jotsommarkdown :... [logic needed for function jotsommarkdown ]</p>
<?php
}

function jotsomwysiwyg  () {
?>
<p>jotsomwysiwyg  :... [logic needed for function jotsomwysiwyg  ]</p>
<?php
}

//Model: retrieve specific queries as data arrays (to be played into views)
function get_authors() {
	$data = array(
		array('url'=>'http://ditaperday.com/blog','name'=>'Don Day'),
		array('url'=>'#','name'=>'Michael Boses')
	);
	return $data;
}

function get_categories() {
	$data = array(
		array('url'=>'#','category'=>'Quisque vestibulum','count'=>'23'),
		array('url'=>'#','category'=>'Sed a nisl a lacus','count'=>'78'),
		array('url'=>'#','category'=>'Quisque sagittis','count'=>'11'),
		array('url'=>'#','category'=>'Etiam volutpat','count'=>'34'),
		array('url'=>'#','category'=>'In aliquet hendrerit','count'=>'65'),
		array('url'=>'#','category'=>'Suspendisse iaculis','count'=>'35'),
		array('url'=>'#','category'=>'Nam vel risus at','count'=>'22'),
		array('url'=>'#','category'=>'Praesent sit amet','count'=>'54')
	);
	return $data;
}

/* Define local widgets: key, form name, data-as-array */
$itemdefs = array(
	'navigation'	=>	array('SiteNav','navigation',array('')),
	'profile'		=>	array('Profile','form_profile',array('')),
	'personalization'=>	array('Profile','form_personalization',array('')),
	'jotsommarkdown'=>	array('jotsommarkdown','jotsommarkdown',array('')),
	'jotsomwysiwyg'	=>	array('jotsomwysiwyg','jotsomwysiwyg',array('')),
	'sites'			=>	array('Sites','form_sites',array('')),

	// selector view, requires a GET handler
	'themesel'		=>	array('Select Theme','selectTheme',array('')),
	'xtypesel'		=>	array('Select Rendition','selectXType',array('')),
	'cats'			=>	array('Categories','selectCategory',array()), 
	
	// list view, linked actions
	'stagedlist'	=>	array('Staged Folders','list_staged',array()), 
	'categories2'	=>	array('Categories','showCategories',array()), 
	'categories'	=>	array('Categories','form_categories',get_categories()), 
	'authors'		=>	array('Authors','form_authors',get_authors()),

	'navi'			=>	array('SiteNav','form_navigation',array('')),
	'search'		=>	array('Search','form_search',array('')),
	'archives'		=>	array('Archives','form_archives',array('')),
	'pages'			=>	array('Pages','form_pages',array('')),
	'blogroll'		=>	array('Blogroll','form_blogroll',array('')),
	'new'			=>	array('New Entry','form_create',array('')),
	'placebo'		=>	array('Widget','form_placebo',array(''))
);

?>