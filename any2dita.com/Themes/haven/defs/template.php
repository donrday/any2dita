<?php
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
	<!-- this template was designed by http://www.tristarwebdesign.co.uk - please visit for more templates & information - thank you. -->
	<head>
		<meta http-equiv="Content-Language" content="en-gb" />
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />

		<!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.2" />
		<title><?php pageTitle();?></title>

		<?php hook_action('xpd_meta');?>

		<!-- Theme specific resources -->
		<meta name="theme" content="common" />
		<meta name="source" content=""/>
		<link rel="stylesheet" type="text/css" href="<?php echo themePath();?>css/style.css" />

		<?php hook_action('xpd_cssjs');?>
		<?php hook_action('user_cssjs');?>
		<?php hook_action('scripts_at_head');?>
	</head>
		<body<?php hook_action('scripts_body_event');?>>
		<div id="border">
			<div id="container">
				<div id="menu">
					<?php navigation();?>
				</div>
			
				<div id="header">
					<p><a title="<?php siteName();?>" href="<?php siteURL();?>"><?php siteName();?></a></p>
				</div>
				
				<div id="content">
					<?php primary();?>
					<hr/>
					<?php secondary();?>
				</div>
		
				<div id="footer">
					<p><?php footer(' | ');?><a title="Tristar Website Design" href="http://www.tristarwebdesign.co.uk/">Web Design</a> by Tristar</p>
				</div>
			</div>
		</div>
		<?php hook_action('scripts_at_end');?>
	</body>
</html>
<?php hook_action('template_exit');?>
