<?php

$appType = 'app';
$siteName ='Any2DITA';
$siteSlogan = 'New lamps for old';
$siteType = 'blog';
$siteOwner = 'Don Day';
$groupName = 'any2dita';
$groupOwner = 'Don Day';
$organization = 'donrday.com';
$copyrOwnerEmail = 'donday@donrday.com';
$defaultThemeName = 'vasile';
$defaultEditorName = 'text';
$defaultDitaType = 'basic';

$serviceTypes = array('about','admin');
$labels = array('About','Admin');

// tab definitions

	$config['about']['topic'] = 'about';
	$config['about']['label'] = 'About';
	$config['about']['areaType'] = 'page';
	$config['about']['sidebarItems'] = 'navigation,search,sites';//draft

	$config['admin']['topic'] = 'admin'; 
	$config['admin']['label'] = 'Setup';
	$config['admin']['areaType'] = 'admin';
	$config['admin']['sidebarItems'] = 'navigation,search,profile,personalization,jotsommarkdown';
