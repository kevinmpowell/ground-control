// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery.hotkeys
// Loads all Bootstrap javascripts
//= require bootstrap
//= require pusher.min
//= require jquery
//= require handlebars
//= require ember
//= require ember-data
//= require ember-pusher.min
//= require_self
//= require ./ground-control

// for more details see: http://emberjs.com/guides/application/
GroundControl = Ember.Application.create({
	rootElement: "body",
	PUSHER_OPTS: {key: '1bd4ccfda7bf1b908b19', connection: {}, logAllEvents: true }
});

function copy_github_commit_data_to_clipboard() {
	var issue_url = $(".issue-list-item:visible:first").find(".issue-list-item-title a").attr("href");
	var github_commit_string = 'git commit -m "[amends ' + issue_url + '] ';
	window.prompt("Copy to clipboard: Ctrl+C, Enter", github_commit_string);
}

$(document).on('keydown', null, 'ctrl+g', function() {
	copy_github_commit_data_to_clipboard();
});


//= require_tree .

