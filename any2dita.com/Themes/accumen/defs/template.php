<?php

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--
Design by TEMPLATED
http://templated.co
Released for free under the Creative Commons Attribution License

Name       : Accumen
Description: A two-column, fixed-width design with dark color scheme.
Version    : 1.0
Released   : 20120712
-->
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />

		<!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.2" />
		<title><?php pageTitle();?></title>

		<?php hook_action('xpd_meta');?>

		<!-- Theme specific resources -->
		<meta name="theme" content="common" />
		<meta name="source" content=""/>
		<link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet" type="text/css" />
		<link href="http://fonts.googleapis.com/css?family=Kreon" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="<?php echo themePath();?>style.css" />

		<?php hook_action('xpd_cssjs');?>
		<?php hook_action('user_cssjs');?>
		<?php hook_action('scripts_at_head');?>
	</head>
		<body<?php hook_action('scripts_body_event');?>>
		<div id="wrapper">
			<div id="header">
				<div id="logo">
					<h1><a href="<?php siteURL();?>"><?php siteName();?></a></h1>
				</div>
				<div id="menu">
					<?php navigation();?>
					<br class="clearfix" />
				</div>
			</div>
			<div id="page">
				<div id="sidebar">
					<?php secondary();?>
				</div>
				<div id="content">
					<?php primary();?>
					<br class="clearfix" />
				</div>
				<br class="clearfix" />
			</div>
			<?php //page_bottom();?>
		</div>
		<div id="footer">
			<?php footer(' | ');?>Design by <a href="http://templated.co" rel="nofollow">TEMPLATED</a> | Images by <a href="http://fotogrph.com/">Fotogrph</a>
		</div>
		<?php hook_action('scripts_at_end');?>
	</body>
</html>
<?php hook_action('template_exit');?>
