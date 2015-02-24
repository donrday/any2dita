<?php
?><!doctype html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

		<!-- expeDITA specific contribution -->
		<meta name="generator" content="expeDITA 0.2" />
		<title><?php echo pageTitle();?></title>
		<meta name="title" content="<?php echo metaTitle();?>" />
		<meta name="description" content="<?php echo metaDesc(); ?>" /> 
		<meta name="keywords" content="<?php echo metaKeywords(); ?>" /> 
		<base href='<?php echo BASE_URL;?>'/>
	
		<!-- SEO -->
		<meta name="robots" content="noindex, nofollow" /> 
		<link rel="canonical" href="<?php echo metaCanonical(); ?>">
		<!-- html manifest, for caching strategy -->
	
		<!-- Theme specific resources -->
		<meta name="theme" content="simplyplain" />
		<meta name="source" content=""/>

		<link href="<?php echo themePath();?>style.css" rel="stylesheet" type="text/css" />
		<?php hook_action('xpd_css');?>
    	<!-- note that the DITA-specific fixer file is still required to normalize things like sl and lines -->

		<?php hook_action('scripts_at_head');?>
	</head>

	<body<?php hook_action('scripts_body_event');?>>
		<header>
			<h1><a href="<?php echo groupPath();?>"><?php echo siteName();?></a></h1>
			<p><?php echo siteSlogan();?></p>
		</header>
		<nav>
			<?php navigation();?>
		</nav>
		<main>
			<?php primary();?>
		</main>
		<aside>
			<?php secondary();?>
		</aside>
		<footer>
			<?php footer('. ');?>
		</footer>
	</body>
</html>
<?php
