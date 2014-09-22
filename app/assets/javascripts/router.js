Houston.Router.reopen({
	location: 'auto'
});

Houston.Router.map(function() {
	this.resource('issues', { path: '/'}, function () {
		// Additional child routes will go here later
		// this.route('yahoo');
		this.route('by-client', {path: ':slug/client/:client_name'});
	});

});

// Houston.IssuesRoute = Ember.Route.extend({
// 	model: function() {
// 		return this.store.find('issue');
// 	}
// });

Houston.IssuesIndexRoute = Ember.Route.extend({
	model: function() {
		return this.store.find('issue');
		// return this.modelFor('issues');
	}
});

Houston.IssuesByClientRoute = Ember.Route.extend({
	controllerName: 'issues_index',
	model: function(params){
		return this.store.filter('issue', function(issue) {
			if (issue.get('client_name') == params.client_name)
			return issue;
		});
	},
	renderTemplate: function(controller) {
		this.render('issues/index', {controller: controller});
	}
})