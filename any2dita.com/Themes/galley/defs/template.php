<?php
/*
| meta
*/ 

?><!doctype html>
<html lang='en'>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.2" />
		<title><?php pageTitle();?></title>

		<?php hook_action('xpd_meta');?>
	
		<!-- Theme specific resources -->
		<meta name="theme" content="galley" />
		<meta name="source" content="Based on Google forms style"/>
		<link href="<?php echo themePath(); ?>style2.css" type="text/css" rel="stylesheet">

		<?php hook_action('xpd_cssjs');?>
		<?php hook_action('user_cssjs');?>
		<?php hook_action('scripts_at_head');?>
	</head>

	<body class="ss-base-body" <?php hook_action('scripts_body_event');?>>
		<div class="container">
			<header>
				<!--img src="img/logo.png"/-->
				<h1>
					<a href="<?php echo groupPath(); ?>"><?php echo siteName();?></a>
				</h1>
				<p>
					<?php echo siteSlogan();?>
				</p>
				<nav>
					<?php echo navigation();?>
				</nav>
			</header>
		
			<main>
					<?php primary(); ?>
			</main>
		
			<!-- In this theme, aside content should flow below the main content, galley-like. -->
			<aside>
				<?php secondary();?>
			</aside>
			
			<footer>
				<p class="legal"><?php footer(' &nbsp; ');?></p>
				<p><span class="powered-by">Powered by expeDITA</span></p>
			</footer>
		</div>
		<?php hook_action('scripts_at_end');?>
	</body>
</html>
<?php hook_action('template_exit');?>
