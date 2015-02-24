<?php

/* Redirecting get/post handlers (these generally need to change the URL and REST state after testing/setting) */

// State changer: xType
if (!isset(	$_SESSION['xType'])) {
	$xType = $defaultXtype;
	$_SESSION['xType'] = $xType;
} else {
	$xType = $_SESSION['xType'];
}

if (isset($_GET['xType'])) {
	$xType =  trim(filter_var($_GET['xType'], FILTER_SANITIZE_STRING));
	$_SESSION['xType'] = $xType;
	header("Location: " . strtok($_SERVER['REQUEST_URI'], '?'));
	exit;
}

// State changer: themeName
if (!isset($_SESSION[$groupName.'themeName'])) {
	$themeName = $defaultThemeName;
	$_SESSION[$groupName.'themeName'] = $themeName;
} else {
	$themeName = $_SESSION[$groupName.'themeName'];
}

if (isset($_GET['themeName'])) {
	$themeName =  trim(filter_var($_GET['themeName'], FILTER_SANITIZE_STRING));
	$_SESSION[$groupName.'themeName']  = $themeName;
	header('Location: '.strtok($_SERVER['REQUEST_URI'], '?'));//get rid of get query by restarting current URL in new theme.
	exit; // header
}

// State changer: groupName
if (!isset($_SESSION['groupName'])) {
	$groupName = $defaultGroupName;
	$_SESSION['groupName'] = $groupName;
} else {
	$groupName = $_SESSION['groupName'];
}

if (isset($_GET['groupName'])) {
	$groupName =  trim(filter_var($_GET['groupName'], FILTER_SANITIZE_STRING));
	$_SESSION['groupName']  = $groupName;
	include contentPath().'_prefs.php';
	$themeName = $defaultThemeName;
	$_SESSION[$groupName.'themeName'] = $themeName;
	header('Location: '.strtok($_SERVER['REQUEST_URI'], '?'));//get rid of get query by restarting current URL in new theme.
	exit; // header
}



/* Non-redirecting get/post handlers (these fall through after testing/setting) */

// GET resoures
if (isset($_GET['page'])) {
	$pagenum = $_GET['page'];
	$mode = 'read';
	$collectionType = 'resource:'.$pagenum;
} elseif (isset($_GET['edit'])) {
	$pagenum = $_GET['edit'];
	$mode = 'edit';
	$collectionType = 'resource:'.$pagenum;
} elseif (isset($_GET['render'])) {
	$xmlpath = $_GET['render'];
	$mode = 'render';
	$collectionType = 'renderItem';
} elseif (isset($_GET['tab'])) {
	$tabType = $_GET['tab'];
	$_SESSION['serviceType'] = $_GET['tab'];
		// effectively induce a page request
		$pagenum = keyfrom($tabType);
	$mode = 'read';
	$collectionType = 'resource:'.$pagenum;
} elseif (isset($_GET['serviceType'])) {
	$serviceType = $_GET['serviceType'];
	$_SESSION['serviceType'] = $serviceType;
		// effectively induce a page request
		$pagenum = keyfrom($serviceType);
	$mode = 'read';
	$collectionType = 'resource:'.$pagenum;
} elseif (isset($_GET['slug'])) {
	$slug = $_GET['slug'];
	$tabType = $slug;
		$pagenum = keyfrom($slug);
		//$pagenum = newpage($slug);
	$mode = 'read';
	$collectionType = 'resource:'.$pagenum;
} else {
	$pagenum = '*';
	$mode = 'read';
	$collectionType = 'collection:*';
}


?>