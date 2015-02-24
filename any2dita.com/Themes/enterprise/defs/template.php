<?php

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--
Design by Free CSS Templates
http://www.freecsstemplates.org
Released for free under a Creative Commons Attribution 2.5 License
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
		<link href="<?php echo themePath();?>default.css" rel="stylesheet" type="text/css" />

		<?php hook_action('xpd_cssjs');?>
		<?php hook_action('user_cssjs');?>
		<?php hook_action('scripts_at_head');?>
	</head>
		<body<?php hook_action('scripts_body_event');?>>
		<div id="header">
			<h1><a href="<?php siteURL();?>"><?php siteName();?></a></h1>
			<h2><?php siteSlogan();?></h2>
				<?php navigation();?>
		</div>

		<div id="content">
			<div id="colOne">
				<?php primary();?>
			</div>
			<div id="colTwo">
				<?php secondary();?>
				<?php //view_secondary_items($itemdefs['navi'],'widget');?>
			</div>
			<div style="clear: both;">&nbsp;</div>
		</div>
		<div id="footer">
			<p>Copyright &copy; 2006 Enterprise. Designed by <a href="http://www.freecsstemplates.org/"><strong>Free CSS Templates</strong></a></p>
		</div>
		<div align=center>This template  downloaded form <a href='http://all-free-download.com/free-website-templates/'>free website templates</a></div>
		<?php hook_action('scripts_at_end');?>
	</body>
</html>
<?php hook_action('template_exit');?>
