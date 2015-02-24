<?php
?>

    <script src="<?php echo "$themesDir/$themeName/"; ?>tabcontent/tabcontent.js" type="text/javascript"></script>
    <link href="<?php echo "$themesDir/$themeName/"; ?>tabcontent/template6/tabcontent.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
function toggleContent() {
  // Get the DOM reference
  var contentId = document.getElementById("content");
  // Toggle 
  contentId.style.display == "block" ? contentId.style.display = "none" : 
contentId.style.display = "block"; 
}
</script>
