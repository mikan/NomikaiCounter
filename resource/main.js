/*
 * Copyright(C) 2014-2015 Yutaka Kato All rights reserved.
 */

$(function() {
	$("#datepicker").datepicker();
	$("input[type=submit], button").button().submit(function(event) {
		event.preventDefault();
	});
});