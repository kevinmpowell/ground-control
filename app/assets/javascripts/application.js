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
//= require ./houston

// for more details see: http://emberjs.com/guides/application/
Houston = Ember.Application.create({
	rootElement: "body",
	PUSHER_OPTS: {key: '1bd4ccfda7bf1b908b19', connection: {}, logAllEvents: true }
});
// Houston.ApplicationAdapter = DS.FixtureAdapter.extend();

//= require_tree .

