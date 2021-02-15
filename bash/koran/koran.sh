#!/bin/bash

# - BEGIN HEADER
if [[ -f $1 ]];then
	echo "File $2 exist! DELETE or change output"
	exit 1
fi

header="
<head><title>Koran `date`</title></head>"

css='
<style type="text/css">
body {
	font-size:3em;
}
ul {
	padding:0;
	border:1px solid blue;
}
li {
	list-style-type:none;
	display:flex;
	border:1px solid red;
	flex-direction:column;
}
li > a {
	flex-wrap:wrap;
	justify-content:center;
	padding:1em;
}
img {
	flex-wrap:no-wrap;
}
</style>'

customJS='
<script type="text/javascript">
$(document).ready(function(){
	$("img").hide();
	$("a").click(function(){
		$(this).siblings("img").toggle();
});
	$("img").click(function(){
		$(this).toggle();
});});
</script>'
# - END HEADER

# Without argument, just download jQuery and cat
import_jQuery(){
	jQuery_file='jquery.min.js'
	jQuery_url='https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js'
	while [[ ! -f "$jQuery_file" ]];do
		wget "$jQuery_url";
	done
	echo "<script type='text/javascript'>"
	cat "$jQuery_file";
	echo -n "</script>"
}

# $1 Output File
# $2 Image File Name
import_image(){
	filename=${2%.*}
	filename=${filename/.\//}
	echo -n "<li><a>$filename</a><img src='data:image/png;base64," >> "$1"
	base64 -w0 "$2" >> "$1"
	echo -n "'></li>" >> "$1"
}

# $1 Output File
buildHeader(){
	echo "$header" >> "$1"
	echo "$css" >> "$1"
	import_jQuery >> "$1"
	echo "$customJS" >> "$1"
}
buildHeader "$1"

# $1 Output File
# $2 Image Directory
buildContent(){
	echo -n "<ul>" >> "$1"
	while read -r image;do
		import_image "$1" "$image"
	done < <(find "$2" -maxdepth 1 -type f|sort)
	echo -n "</ul>" >> "$1"
}
buildContent "$1" "$2"
