<?php


function navigation() {
?>
	<ul>
		<li class="active"><a href="#">Home</a></li>
		<li><a href="#">About</a></li>
		<li><a href="#">Portfolio</a></li>
		<li><a href="#">Contact</a></li>
	</ul>
<?php
}

function article1() {
?>
	<header class="">
		<h2><a href="#" title="<?php echo "First Post";?>"></a></h2>
	</header>
	<footer>
		<p class="post-info">This post was created on <?php echo "7 May 2013";?> by <?php echo "Duis Elit";?>.</p>
	</footer>
	<section>
		<?php echo "body content here.";?>
	</section>
<?php
}
