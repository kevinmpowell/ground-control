GroundControl.Issue = DS.Model.extend({
	url: DS.attr('string'),
	title: DS.attr('string'),
	body: DS.attr('string'),
	state: DS.attr('string'),
	html_url: DS.attr('string'),
	number: DS.attr('string'),
	repo_name: DS.attr('string'),
	client_name: DS.attr('string'),
	closed: DS.attr('boolean'),
	archived: DS.attr('boolean'),
	assignee: DS.attr('string'),
	labels: DS.attr('string'),
	local_sort_order: DS.attr('number'),
	repo_url: function() {
		return "http://github.com/" + this.get('repo_name');
	}.property('repo_name'),
	didLoad: function(){
		var self = this;
		// setInterval(function() {self.reload()}, 5*1000); //every 5 seconds
	}
});