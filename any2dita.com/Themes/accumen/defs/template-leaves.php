<?php

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

		<!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.2" />
		<title><?php pageTitle();?></title>

		<?php hook_action('xpd_meta');?>

		<!-- Theme specific resources -->
		<meta name="theme" content="common" />
		<meta name="source" content=""/>
		<link href="<?php echo themePath();?>style.css" rel="stylesheet" type="text/css" />

		<?php hook_action('xpd_cssjs');?>
		<?php hook_action('user_cssjs');?>
		<?php hook_action('scripts_at_head');?>
	</head>
		<body<?php hook_action('scripts_body_event');?>>
		<div id="container">
		<div id="header">
			<h1><a href="<?php siteURL();?>"><?php siteName();?></a></h1>
			<p><?php siteSlogan();?></p>
			<?php form_search();?>
		</div>

		<div id="navigation"> 
			<?php navigation();?>
		</div>

		<div id="sidebar">
			<?php secondary();?>
		</div>
		
		<div id="content">
			<?php primary();?>
		</div>
		
		<div id="footer">
			<p><?php footer(' | ');?>Design by <a href="http://smallpark.org">SmallPark</a></p>
		</div>
		</div>
		<?php hook_action('scripts_at_end');?>
	</body>
</html>
<?php hook_action('template_exit');?>
