<?php

// UI support: functions that generate output features.

// viewsCore.php defined some UI bits; nav, search, login (should go in a UI/themes support plugin instead)
// viewsMapAsList handles use of maps to generate sequenced content as a single result.
///include 'App/viewsMapAsList.php';
//include 'App/addResources.php';
//include 'App/View/UIPickerViews.php'; // the original alternative to what is now viewsMapsAsList
// needed only for admin and editing modes	//include 'App/View/viewsExtra.php'; 
///include 'App/View/UISelectViews.php'; // load UI and controls (widgets available for any theme)

function xpd_button($db_id, $blist) {
	$bits = explode(',',$blist);
	foreach($bits as $bit) {
		switch($bit) {
			case 'read':
			?><a href="?page=<?php echo $db_id;?>">Read</a><?php
			break;
			case 'read_form':
			?><form style="display:inline;" method="get" action="">
				<input type="hidden" name="page" value="<?php echo $db_id;?>"/>
				<input type="submit" value="Read">
			</form><?php
			break;


			case 'edit':
			?><a href="?edit=<?php echo $db_id;?>">Edit</a><?php
			break;
			case 'edit_form':
			?><form style="display:inline;" method="get" action="">
				<input type="hidden" name="edit" value="<?php echo $db_id;?>"/>
				<input type="submit" value="Edit">
			</form><?php
			break;

			case 'cancel':
			?><a href="?page=<?php echo $db_id;?>">Cancel</a><?php
			break;
			case 'cancel_form':
			?><form style="display:inline;" method="get" action="">
				<input type="hidden" name="page" value="<?php echo $db_id;?>"/>
				<input type="submit" value="Cancel">
			</form><?php
			break;

			case 'delete':
			?><a href="?delete=<?php echo $db_id;?>">Delete</a><?php
			break;
			case 'delete_form':
			?><form style="display:inline;" method="get" action="">
				<input type="hidden" name="delete" value="<?php echo $db_id;?>"/>
				<input type="submit" value="Delete">
			</form><?php
			break;

		}
	}
}


/* Edit mode content (forms) */

function form_create() {
    //We are not trying to post a comment, show the form.
	$datetime = date("F j, Y, g:i a");
	//$userdate = "1/2/2011"; 
	//$date = date("Y-m-d", strtotime($userdate)) //Y-m-d as SQL-like standard
	$fieldset = 'div';
	$legend = 'div';
	$editattrs = ' class="WYSIWYG" title="block text left right insert link image table source"';
	// Putting ANY class on the textarea causes the formatting to break down for some reason.
	?>
	<style>input.form_title {font-weight:bold; font-size:larger;}</style>
	<style>legend, .legend {font-weight:bold}</style>
	<form action="" method="post">
	  <div class="fieldset">
	    <div class="legend"></div>
	    Title: <input type="text" class="form_title" name="xpd_title" size="30" /><br />
	    Content: <textarea name="xpd_content" rows="4" cols="60"<?php echo $editattrs;?>></textarea>
	    Author: <input type="text" class="form_author" name="xpd_author" size="30" /><br />
	  </div>
	    <input type="hidden" name="xpd_timestamp" value="<?php echo $datetime;?>"></input>
	    <input type="hidden" name="xpd_act" value="create"></input>
	    <input type="submit" name="submit" value="Submit"></input>
	</form>
	<?php
}

function form_edit($in) {
$row = $in[0];
//var_dump($row);
	$datetime = date("F j, Y, g:i a");
	$editattrs = ' class="WYSIWYG" title="block text left right insert link image table source"';
	?>
	<style>input.form_title {font-weight:bold; font-size:larger;}</style>
	<style>legend, .legend {font-weight:bold}</style>
	<form action="" method="post">
	  <div class="fieldset">
	    <div class="legend"></div>
	    Title: <input type="text" class="form_title" name="xpd_title" size="30" value="<?php echo $row['post_title'];?>"/><br />
	    Content: <textarea name="xpd_content" rows="4" cols="60"<?php echo $editattrs;?>><?php echo $row['post_content'];?></textarea>
	    Author: <input type="text" class="author" name="xpd_author" size="30" value="<?php echo $row['post_author'];?>"/><br />
	  </div>
	    <input type="hidden" name="xpd_timestamp" value="<?php echo $row['post_date'];?>"></input>
	    <input type="hidden" name="xpd_updated" value="<?php echo $datetime;?>"></input>
	    <input type="hidden" name="xpd_postid" value="<?php echo $row['post_id'];?>"></input>
	    <input type="hidden" name="xpd_guid" value="<?php echo $row['guid'];?>"></input>
	    <input type="hidden" name="xpd_act" value="update"></input>
	    <input type="submit" name="submit" value="Update"></input>
	    <?php xpd_button($row['post_id'],'cancel_form');?>
	</form>
	
	<?php
}

function form_contact() {
?>
	<form action="" method="post" id="contactform">
			<p>
				<label for="name">Your Name*</label>
				<input id="name" name="xpd_name" class="text" />
			</p>
			<p>
				<label for="email">E-Mail*</label>
				<input id="email" name="xpd_email" class="text" />
			</p>
			<p>
				<label for="company">Website</label>
				<input id="company" name="xpd_company" class="text" />
			</p>
			<p>
				<label for="message">Your Message*</label>
				<textarea id="message" name="xpd_message" rows="6" cols="50"></textarea>
			</p>
			<p class="buttons">
				<input type="submit" name="xpd_imageField" id="imageField"  value="Send message" class="send" />
			</p>
	</form>
<?php
}

function form_archives() {
// list style
?>
<ul>
	<li><a href="#">January 2007</a></li>
	<li><a href="#">December 2006</a></li>
	<li><a href="#">November 2006</a></li>
	<li><a href="#">October 2006</a></li>
	<li><a href="#">September 2006</a></li>
	<li><a href="#">August 2006</a></li>
	<li><a href="#">July 2006</a></li>
	<li><a href="#">June 2006</a></li>
</ul>
<?php
}

function form_pages2() {
// list style
?>
<ul>
	<li><a href="#">My Blog</a></li>
	<li><a href="#">My Photos</a></li>
	<li><a href="#">My Favorites</a></li>
	<li><a href="#">About Me</a></li>
	<li><a href="#">Contact Me</a></li>
</ul>
<?php
}

function form_pages() {
// list style
?>
<ul>
	<li><a href="#">About HTML</a></li>
	<li><a href="#">About WYSIWYG (rich text)</a></li>
	<li><a href="#">About Markdown</a></li>
	<li><a href="#">About Wikitexts</a></li>
</ul>
<?php
}

function form_blogroll() {
// list style
?>
<ul>
	<li><a href="#">WebGod of Gates</a></li>
	<li><a href="#">AnotherFriendlySite.net</a></li>
	<li><a href="#">CoolSite.com</a></li>
	<li><a href="#">MyBestFriend.com</a></li>
</ul>
<?php
}

register_action('list_authors','form_authors'); // declare for independent query: hook_action('list_authors');
function form_authors($items) {
?>
<ul>
<?php foreach($items as $item):?>
	<li><a href="<?php echo $item['url'];?>"><?php echo $item['name'];?></a></li>
<?php endforeach;?>
</ul>
<?php
}

register_action('list_categories','form_categories'); // declare for independent query: hook_action('list_categories');
function form_categories($items) {
?>
<ul>
<?php foreach($items as $item):?>
	<li><a href="<?php echo $item['url'];?>"><?php echo $item['category'];?></a> (<?php echo $item['count'];?>)</li>
<?php endforeach;?>
</ul>
<?php
}

/* from tree_tops:
<form action="" method="post">
  <div class="form_settings">
    <p><span>Name</span><input class="contact" type="text" name="your_name" value=""></p>
    <p><span>Email Address</span><input class="contact" type="text" name="your_email" value=""></p>
    <p><span>Message</span><textarea class="contact textarea" rows="8" cols="50" name="your_enquiry"></textarea></p>
    <p style="padding-top: 15px"><span>&nbsp;</span><input class="submit" type="submit" name="contact_submitted" value="submit"></p>
  </div>
</form>
*/
register_action('table_topics','form_topics_table'); // declare for independent query: hook_action('table_topics');

function form_topics_table() {
$items = db_readmany($pagenum);
?>
<table>
<tr><th>name</th><th>link</th></tr>
<?php foreach($items as $item):?>
	<td>
		<i><?php echo $item['post_id'];?></i>
	</td>
	<td>
		<i><?php echo $item['post_title'];?></i>
	</td>
<?php endforeach;?>
</table>
<?php
}

/*   Button bars for various actions. xpd_button defines individual buttons.
Buttons adjoin like words in a sentence, and will wrap to a new line in a responsive way.
Actions with input forms will usually have their own submit buttons, but we can add button
controls into those forms for Cancel or other GET actions.
*/

//hook_action('editor_button_bar');

// This hook may be better placed in the UI support plugin for themes/editors. It IS a GUI component.
// I don't think this is useful code, however. save will be part of the editing form. And accessing the
// editor should be prevented in the first place if not authorized. Or hide the Save control in the editor!
register_action('editor_button_bar','xpd_button_bar_editor');
function xpd_button_bar_editor() {
	global $auth;
	if ($auth) {
?><button>Save</button> <?php
}
?><?php global $row; xpd_button($row['post_id'],'cancel_form');?><?php
}

// Note that included applications can augment this list. Bookmark would be a good test.
register_action('tool_button_bar','xpd_tool_button_bar');
function xpd_button_bar_tool() {
	global $auth;
	if ($auth) {
		?><button>Edit</button> <button>Revert</button> <?php
	}
		?><button>Bookmark</button><?php
}

?>