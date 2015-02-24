<?php

// Reset the full system (session wipe) when the ?reset parameter is passed. 
register_action('initialize','xpd_reset');
 
function xpd_reset() {
	if (isset($_GET['reset'])) {
		session_unset(); 
		$host  = $_SERVER['HTTP_HOST'];
		$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
		$extra = 'mypage.php';
		//header("Location: http://$host$uri/includes/$extra"); // Use this call to jump to a new reset page.
		header("Location: http://$host$uri"); // Back to the site root.
		//header('Location: '.BASE_URL);
		exit; // header
	}
}


// Stop th full system when the ?stop parameter is passed.
register_action('initialize','xpd_stop');
 
function xpd_stop() {
    if (isset ($_GET['stop'])) {
    	die( 'STOPPED!');
    }
}

// Add some text after the header
register_action( '__after_header' , 'add_promotional_text' );
function add_promotional_text() {

	// If we're not on the home page, do nothing
	if ( !is_front_page() )
		return;

	// Echo the html
	echo "<div style='border:1px red solid;background:pink;display:inline-block;padding:4px;'>Special offer! June only: Free chocolate for everyone!</div><hr/>";
}


?>