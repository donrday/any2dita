<?php

//echo "SERVICETYPE: $serviceType<br/>";
//echo "AREATYPE   : $areaType<br/>";

function contentArea($i) {
	global $postNavtitle, $postTopic, $serviceType, $groupName, $config, $key;
	switch ($i) {
	    case 'index':
			?>
			<div class='areawrap'>
				<?php if (isset($postNavtitle))echo '<h3>'.$postNavtitle.'</h3>'; ?>
				<?php echo endpoint($serviceType);?>
			</div>
			<?php listMapAsList($config[$serviceType]['featuredMap'], 'preview'); ?>
			<?php
	        break;
	    case 'folio':
			?>
			<div class='areawrap'>
				<?php if (isset($postNavtitle))echo '<h3>'.$postNavtitle.'</h3>'; ?>
				<?php echo endpoint($serviceType);?>
			</div>
			<?php listMapAsList($config[$serviceType]['featuredMap'], 'preview'); ?>
			<?php
	        break;
	    case 'blog':
			?>
			<div class='areawrap'>
				<?php if (isset($postNavtitle))echo '<h3>'.$postNavtitle.'</h3>'; ?>
				<?php echo endpoint($serviceType);?>
			</div>
			<?php //listMapAsList($config[$serviceType]['featuredMap'], $config[$resourceName]['itemStyle']); ?>
			<?php if ($config[$serviceType]['featuredMap'] == 'bloglist'): ?>
			<?php listSearchResultsAsBloglist('Day', $groupName, 'topic', 3, 'blog'); ?>
			<?php listSearchResultsAsBloglist('Boses', $groupName, 'topic', 3, 'blog'); ?>
			<?php //listPostsByAuthor('topic', 3, 'blurb', 'Michael'); ?>
			<?php endif; ?>
			<?php
	        break;
	    case 'page':
			?>
			<div class='areawrap'>
				<?php if (isset($postNavtitle))echo '<h3>'.$postNavtitle.'</h3>'; ?>
				<?php echo endpoint($serviceType);?>
			</div>
			<?php
	        break;
	    case 'post':
			?>
			<div class='areawrap'>
				<?php if (isset($postNavtitle))echo '<h3>'.$postNavtitle.'</h3>'; ?>
				<?php echo endpoint($serviceType);?>
			</div>
			<p class="blog_post_meta">
				<small>Posted by <a href="#"><?php echo $key['author']; ?></a>
					&bull; <?php echo $key['date']; ?>
					&bull; Category: <a href="#"><?php echo $key['category']; ?></a>
					<?php if (isset($_SESSION['authenticated'])) { 	?>
						&bull; <a onClick="fn('<?php echo 'blog/topic/'.$filename; ?>?edit')"><b>Edit</b></a>
						<?php listVersions($xmlFile); ?>
					<?php } ?>
				</small>
			</p>
			<?php
	        break;
	    case 'admin':
			?>
			<div class='areawrap'>
				<?php if (isset($postNavtitle))echo '<h3>'.$postNavtitle.'</h3>'; ?>
				<?php echo endpoint($serviceType);?>
			</div>
			<?php
	        break;
	    default :
			?>
			<div class='areawrap'>
				<?php if (isset($postNavtitle))echo '<h3>'.$postNavtitle.'</h3>'; ?>
				<?php echo endpoint($serviceType);?>
			</div>
			<?php
	        break;
	}
}


/* ============== view functions =================== */
//include 'contentPolicy.php';
function contentPolicy($policyName, $policyArg) {
global $post_id;
?>
	<h1>Feature:</h1>
	<?php showPage($policyArg); ?>
	<hr />
	<h2>Add new Post</h2>
	<?php //form_add_post(); ?>
<?php
}
