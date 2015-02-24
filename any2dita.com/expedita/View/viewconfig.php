<?php
// define functions and vars that configure the themes and views

	function pageTitle() {
		global $siteName;
		echo $siteName;
	}

	function metaTitle() {
		return '';
	}
	
	function metaDesc() {
		return '';
	}
	
	function metaKeywords() {
		return '';
	}
	
	function metaCanonical() {
		global $url;
		return SERVERNAME.'/'.trim($url, '/');
	}
	//*/

	function siteURL() {
		echo BASE_URL;
	}
	function siteName() {
		global $siteName;
		echo $siteName;
	}
	function siteSlogan() {
		global $siteSlogan;
		echo $siteSlogan;
	}
	function xnavigation() {
	?><ul>
	<li>nav items here</li>
	</ul><?php
	}
	function xfooter() {
	}
?>