<?php
/* Reading mode views */
// included by each themeconfig

// Enable standard forms to be rendered in the prevailing GUI.
function view_search() {
	?>
	<div class="xpdmain">
		<?php form_search();?>
	</div>
	<?php
}

function view_create() {
	?>
	<div class="xpdmain">
		<?php form_create();?>
	</div>
	<?php
}

function view_edit($row) {
	?>
	<div class="xpdmain">
		<?php form_edit($row);?>
	</div>
	<?php
}

function view_contact() {
	?>
	<div class="xpdmain">
		<?php form_contact();?>
	</div>
	<?php
}

function view_postsummary($row) {
	global $headlevel1, $widgetlevel1;
	?>
	<div class="xpdmain">
		<h<?php echo $headlevel1;?>>
			<?php echo $row['post_title'];?>
		</h<?php echo $headlevel1;?>>
		<?php echo $row['post_desc'];?> 
		<p><a href="<?php echo pagePath($row['post_id']);?>">Continue reading</a><?php //xpd_button($row['post_id'],'read');?> &raquo; </p>
	</div>
	<?php
}

function view_sidebaritem($row) {
	global $headlevel1, $widgetlevel1;
	?>
	<div class="xpdwidget">
		<h<?php echo $widgetlevel1;?>>
			<?php echo $row['post_title'];?>
		</h<?php echo $widgetlevel1;?>>
		<?php echo $row['post_content'];?>
	</div>
	<?php
}

function view_post($row) {
	global $headlevel1, $widgetlevel1;
	?>
	<div class="xpdmain">
		<h<?php echo $headlevel1;?>>
			<?php echo $row['post_title'];?>
		</h<?php echo $headlevel1;?>>
		<?php echo $row['post_content'];?>

		<p class="meta">
			Posted: <?php echo $row['post_date'];?>
			by <a href="<?php echo $row['guid'];?>"><?php echo $row['post_author'];?></a>
			(<?php xpd_button($row['post_id'],'edit');?>)
		</p>
	</div>
	<?php
}

function view_page($row) {
	global $headlevel1, $widgetlevel1;
	?>
	<div class="xpdmain">
		<h<?php echo $headlevel1;?>>
			<a href="<?php echo pagePath($row['post_id']);?>"><?php echo $row['post_title'];?></a>
		</h<?php echo $headlevel1;?>>
		<?php echo $row['post_content'];?>
	</div>
	<?php
}

function view_rendition($row,$xType) {
	global $headlevel1, $widgetlevel1;
	?>
	<div class="xpdmain">
<pre>
<?php 
$c = 'render_'.$xType;
echo "CONVERTING TO: $c<br/>";
echo htmlentities($c($row));
?>
</pre>
	</div>
	<?php
}

// extras in this template:

function form_search() {
?>
<form name="form1" id="form1" method="post" action="">
	<input type="text" name="xpd_textfield" value="Search..." />
	<input class=" button" type="submit" name="Submit" value="GO" />
</form>		
<?php
}

?>