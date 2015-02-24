<?php


//register_filter('_the_title', 'strrev');
	//$data = strrev($data);

register_action('_the_content','core');
function core() {
global $post;
	echo $post->content;
}

register_action('_the_heading','hdcore');
function hdcore() {
global $post;
	echo $post->title;
}

// inner style for post title
register_filter('_the_heading','default_post_title');
function default_post_title($data,$lvl=1) {
    return "<h{$lvl}>{$data}</h{$lvl}>";
}

register_filter('_the_content','default_post_body');
function default_post_body($data) {
	return "<div class=\"post\">$data</div>";
}



register_action('exit','diagnostics');
function diagnostics() {
	global $time_start;
	$time_end = microtime(true); 	//dividing with 60 will give the execution time in minutes other wise seconds
	$execution_time = ($time_end - $time_start); 	//execution time of the script
	echo '<b>Total Execution Time:</b> '.$execution_time.' Secs';
}


register_action('init','diagsetup');
function diagsetup() {
	global $time_start;
	$time_start = microtime(true); 
	// Installation setup
	// This variable, if used, value MUST be obtained by the index.php.
	$hereami = (basename(__DIR__) == '') ? '' : basename(__DIR__).'/';
}

register_action('init','undo_tests');
function undo_tests() {
	// Remove originally mapped hook and bind it to a new hook location.
	unregister_action( '__after_header' , 'add_promotional_text' );
	//register_action( '_footer_bar' , 'add_promotional_text' );
}

/* Some DITA specific support */

register_action('xpd_cssjs','expedita_cssjs');
// Include expeDITA-specific CSS and JS modules as needed.
function expedita_cssjs() {
?><link rel="stylesheet" href="<?php echo appPath(); ?>css/common.css" type="text/css" media="screen" />
<?php
}

register_action('scripts_at_head','head_scripts');
// Include application-specific JS modules as needed. Currently null.
function head_scripts() {
?><?php
}

register_action('xpd_meta','expedita_meta');
function expedita_meta() {
?><!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.3" />
		<meta name="title" content="<?php echo metaTitle();?>" />
		<meta name="description" content="<?php echo metaDesc(); ?>" /> 
		<meta name="keywords" content="<?php echo metaKeywords(); ?>" /> 
	
		<!-- SEO -->
		<meta name="robots" content="noindex, nofollow" /> 
		<base href='<?php echo BASE_URL;?>'/>
		<link rel="canonical" href="<?php echo metaCanonical(); ?>">
		<!-- html manifest, for caching strategy -->
<?php
}


?>