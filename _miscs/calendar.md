---
layout: page
title:  My Calendar
show_date: false
description: 
permalink: /miscs/calendar
show: true
---

Times are shown in your timezone, as long as the program works properly.

<div id="calendar_container"></div>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jstimezonedetect/1.0.7/jstz.js"></script>

<script type="text/javascript">
    let timezone = jstz.determine();
    let pre = '<iframe src="https://calendar.google.com/calendar/embed?height=600&wkst=1&bgcolor=%23ffffff&ctz=';
    let post = '&showTitle=1&mode=WEEK&title=Save%20the%20Day%20for%20Collaboration&src=YnZnMWFjdmxsaWQ3aGozaGYzdnFqamluaGtAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ&color=%233F51B5" style="border:solid 1px #777" width="100%" height="600" frameborder="0" scrolling="no"></iframe>';
    let iframe_html = pre + timezone.name() + post;
    document.getElementById("calendar_container").innerHTML = iframe_html;
</script>