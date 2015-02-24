<?php

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>

		<!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.2" />
		<title><?php pageTitle();?></title>

		<?php hook_action('xpd_meta');?>

		<!-- Theme specific resources -->
		<meta name="theme" content="common" />
		<meta name="source" content=""/>
		<link rel="stylesheet" type="text/css" href="<?php echo themePath();?>default.css" media="screen"/>

		<?php hook_action('xpd_cssjs');?>
		<?php hook_action('user_cssjs');?>
		<?php hook_action('scripts_at_head');?>
	</head>

		<body<?php hook_action('scripts_body_event');?>>
	
	<div class="container">
	
		<div class="navigation">
	
			<div class="title">
				<h1><a href="<?php siteURL();?>"><?php siteName();?></a></h1>
				<h2><?php siteSlogan();?></h2>
			</div>
	
			<?php navigation();?>
			<div class="clearer"><span></span></div>
	
		</div>
	
		<div class="holder_top"></div>
	
		<div class="holder">
			<?php primary();?>
			<hr/>
			<?php secondary();?>
		</div>
	
		<div class="footer">
			<div class="left"><?php footer(' ');?>
			</div>
			<div class="right">
				<a href="http://templates.arcsin.se/">Website template</a> by <a href="http://arcsin.se/">Arcsin</a>
			</div>
			<div class="clearer">&nbsp;</div>
		</div>
	</div>
	
		<?php hook_action('scripts_at_end');?>
	</body>
</html>
<?php hook_action('template_exit');?>
