<?php
/*
| meta
*/ 
//include('App/sdb.php');
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Language" content="English" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

		<!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.2" />
		<title><?php echo pageTitle();?></title>

		<?php hook_action('xpd_meta');?>

		<!-- Theme specific resources -->
		<meta name="theme" content="WhiteClean" />
		<meta name="source" content="http://www.free-css-templates.com/preview/WhiteClean/"/>
		<link rel="stylesheet" type="text/css" href="<?php echo themePath(); ?>style.css" media="screen" />

		<?php hook_action('xpd_cssjs');?>
		<?php hook_action('user_cssjs');?>
		<?php hook_action('scripts_at_head');?>
	</head>

	<body<?php hook_action('scripts_body_event');?>>
		
		<div id="wrap">
		
			<div id="header">
				<h1><a href="<?php echo groupPath(); ?>"><?php echo siteName();?></a></h1>
				<h2><?php echo siteSlogan();?></h2>
			</div>
			
			<div id="menu">
				<?php echo navigation();?>
			</div>
			
			<div id="content">
				<div class="right"> 
					<?php echo primary();?>
				</div>
				
				<div class="left"> 
					<?php secondary();?>
					<?php //echo hook_action('mytopiclist',array());?>
				</div>
				
				<div style="clear: both;"> </div>
			</div>
			
			<div id="footer">
				<?php echo footer(' | ');?>
				Designed by <a href="http://www.free-css-templates.com/">Free CSS Templates</a>
			</div>
		</div>

		<?php hook_action('scripts_at_end');?>
	</body>
</html>
<?php hook_action('template_exit');?>
