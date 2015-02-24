<?php
/*
| meta
*/ 

?><!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8"/>
		<meta http-equiv="content-language" content="en" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	
		<!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.2" />
		<title><?php echo pageTitle();?></title>
		<meta name="title" content="<?php echo metaTitle();?>" />
		<meta name="description" content="<?php echo metaDesc(); ?>" /> 
		<meta name="keywords" content="<?php echo metaKeywords(); ?>" /> 
		<base href='<?php echo basePath(); ?>'/>
	
		<!-- SEO -->
		<meta name="robots" content="noindex, nofollow" /> 
		<link rel="canonical" href="<?php echo metaCanonical(); ?>">
		<!-- html manifest, for caching strategy -->
		
		<!-- Theme specific resources -->
		<meta name="theme" content="vasile" />
		<meta name="source" content="http://www.1stwebdesigner.com/css/create-a-responsive-website-video-tutorial/"/>
		<link rel="stylesheet" type="text/css" href="<?php echo themePath(); ?>style.css"/>

		<?php hook_action('xpd_cssjs');?>
		<?php hook_action('user_cssjs');?>
		<?php hook_action('scripts_at_head');?>
	</head>

	<body<?php hook_action('scripts_body_event');?> class="body">
		<header class="mainHeader">
			<!--img src="img/logo.png"/-->
			<h1><a href="<?php echo groupPath();?>"><?php echo siteName();?></a></h1>
			<p><?php echo siteSlogan();?></p>
			<nav>
				<?php echo navigation();?>
			</nav>
		</header>
	
		<div class="maincontent">
			<main class="content"><!-- needed for responsive handle -->
				<article class="topcontent">
					<?php primary(); ?>
				</article>
			</main>
		</div>
	
		<aside class="sidebar">
			<?php secondary();?>
		</aside>
		
		<footer class="mainFooter">
			<?php echo footer(' | ');?>
			Design by <a href="http://www.1stwebdesigner.com/css/create-a-responsive-website-video-tutorial/">Christian Vasile</a>
		</footer>
	
		<?php hook_action('scripts_at_end');?>
	</body>
</html>
<?php hook_action('template_exit');?>
