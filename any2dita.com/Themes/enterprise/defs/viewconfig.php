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
	<div class="post">
		<h2 class="titlesingle">
			<?php echo $row['post_title'];?>
		</h2>
		<h3 class="postedsingle">Posted on <?php echo $row['post_date'];?> by <a href="<?php echo $row['guid'];?>"><?php echo $row['post_author'];?></a>
		</h3>
		<div class="storysingle">
			<?php echo $row['post_content'];?>
		</div>
		<div class="meta">
			<p>Filed under 
				<a href="<?php echo categoryPath('Uncategorized');?>" class="category">Uncategorized</a> | 
				<a href="#" class="comment">1 Comment &raquo;</a> | 
		(<?php xpd_button($row['post_id'],'edit');?>)
			</p>
		</div>
	</div>
	<?php
}

function view_postsummary($row) {
	global $headlevel1, $widgetlevel1;
	?>
	<div class="post">
		<h2 class="title"><?php echo $row['post_title'];?></h2>
		<h3 class="posted">Posted on <?php echo $row['post_date'];?> by <a href="<?php echo $row['guid'];?>"><?php echo $row['post_author'];?></a>
		</h3>
		<div class="story">
			<?php echo summary($row['post_content']);?> <?php xpd_button($row['post_id'],'read');?>
		</div>
		<div class="meta">
			<p>Filed under 
				<a href="<?php echo categoryPath('Uncategorized');?>" class="category">Uncategorized</a> | 
				<a href="#" class="comment">1 Comment &raquo;</a> <?php xpd_button($row['post_id'],'read');?>
			</p>
		</div>
	</div>
	<?php
}

function view_page($row) {
	global $headlevel1, $widgetlevel1;
	?>
	<div class="post">
		<h<?php echo $headlevel1;?>>
			<a href="<?php echo pagePath($row['post_id']);?>"><?php echo $row['post_title'];?></a>
		</h<?php echo $headlevel1;?>>
		<div>
			<?php echo $row['post_content'];?>
		</div>
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
<form method="get" action="#">
	<div>
		<input type="text" id="textfield1" name="textfield1" value="" size="18" />
		<input type="submit" id="submit1" name="submit1" value="Search" />
	</div>
</form>
<?php
}

function zform_navigation() {
// add subnav logic here using the actual serviceTypes
?>
<ul>
	<li><a href="#">Home</a></li>
	<li><a href="#">About</a></li>
	<li><a href="#">Services</a></li>
	<li><a href="#">Contact</a></li>
</ul>
<?php
}

function secondary3($itemlist='search') {
global $itemdefs;
$items = explode(',',$itemlist)
?>
<?php view_secondary_page($itemdefs['new']);?>
<ul>
<?php foreach($items as $item):?>
	<?php view_secondary_listitem($itemdefs[$item]);?>
<?php endforeach;?>
</ul>
<?php
}

?>