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

function view_sidebaritem($row) {// (note special 'ul class="list"' prop and 'first/last' classes for visual list items)
	global $headlevel1, $widgetlevel1;
	?>
	<div class="box">
		<h3><?php echo $row['post_title'];?></h3>
		<?php echo $row['post_content'];?>
	</div>
	<?php
}

function view_post($row) {//
	global $headlevel1, $widgetlevel1;
	?>
	<div class="box">
		<h2><?php echo $row['post_title'];?></h2>
		<?php echo $row['post_content'];?>
	</div>
		<p class="meta">
			Posted: <?php echo $row['post_date'];?>
			by <a href="<?php echo $row['guid'];?>"><?php echo $row['post_author'];?></a>
			(<?php xpd_button($row['post_id'],'edit');?>)
		</p>
	<?php
}

function view_page($row) {//
	global $headlevel1, $widgetlevel1;
	?>
	<div class="box">
		<h2><?php echo $row['post_title'];?></h2>
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
//echo "CONVERTING TO: $c<br/>";
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

function titled_hook($title,$hookname,$args) {
?>
	<h3><?php echo $title;?></h3>
	<?php hook_action($hookname,$args);?>
<?php
}

function page_bottom() {// need to work on this as a full visual chunk of the page
global $itemdefs;
?>
<div id="page-bottom">
	<div id="page-bottom-sidebar">
		<?php titled_hook('Categories','list_categories',array(get_categories()));?>
		<?php //view_secondary_items($itemdefs['authors'],'widget');//this puts on a wrapper, not needed in this context.?>
	</div>
	<div id="page-bottom-content">
	<?php 	show_resource(15,'sidebaritem');?>
	</div>
	<br class="clearfix" />
</div>
<?php
}
?>