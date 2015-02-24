<?php

	//$commonPath = $themeName;
	$commonPath = 'Themes';
	switch ($serviceType) {
	    case 'default':
	    default :
		    // everything that doesn't have an assigned type
	    	?>
	    	<hr/>here we are<hr/>
			<div class='areawrap'>
		    <?php include("$commonPath/area_$serviceType.php"); ?>
	    	</div>
	    	<?php
	        break;
	}
