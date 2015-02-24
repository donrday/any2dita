<?php

//function contentArea($i) {
//	global $postNavtitle, $postTopic, $serviceType, $groupName, $config, $key, $appDir;
	$commonPath = $themeName;
	$postTitleTxt = 'Test';
	$postShortdesc = '';
	$postContent =  '';
   	$version = 'common';
   	/*?><h1>Testing general areas: <?php echo $serviceType;?></h1><?php*/
	switch ($serviceType) {
	    case 'index':
	    	// The opening page for domain-only URLs
	    	include("$commonPath/area_index.php");
	        break;
	    case 'folio':
	    	// category-themed page
	    	include("$commonPath/area_folio.php");
	        break;
	    case 'blogs2':
	    	// code that needs to be reviewed and then tossed or integrated
	    	include("$commonPath/area_blogs2.php");
	        break;
	    case 'blogs':
	    	// case of a multi-author blog
	    	include("$commonPath/area_blogs.php");
	        break;
	    case 'blog':
	    	// case of a single-author blog
	    	include("$commonPath/area_blogs.php");
	        break;
	    case 'post':
	    	// case of a single post
	    	include("$commonPath/area_post.php");
	        break;
	    case 'admin':
	    	// case of overall admin functions
	    	include("$commonPath/area_admin.php");
	        break;
	    case 'page':
	    	// case of generic page (no blog meta; use for landing pages too)
	    	include("$commonPath/area_page.php");
	        break;
	    case 'default':
	    default :
	    	// everything that doesn't have an assigned type
	    	include("$commonPath/area_page.php");
	        break;
	}
//}

