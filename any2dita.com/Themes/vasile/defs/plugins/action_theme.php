<?php

register_action("_nav_primary", "_nav_primary_common");

function _nav_primary_common() { 
	global $serviceTypes, $serviceType, $sitenavdata;
	ob_start();
	?>
<ul>
	<?php foreach($serviceTypes as $item): 
	$rhi = ($serviceType == $item) ? ' class="active"' : '' ;
	?>
	<li<?php echo $rhi;?>>
		<a href="<?php echo $item;?>"><?php echo $sitenavdata[$item];?></a>
	</li>
	<?php endforeach; ?>
</ul>
	<?php
	$output = ob_get_clean();
	echo $output;
}


?>