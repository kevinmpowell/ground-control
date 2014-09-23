Houston.Router.reopen({
	location: 'auto'
});

Houston.Router.map(function() {
	this.resource('issues', { path: '/'}, function () {
		this.route('by-client', {path: ':slug/client/:client_name'});
	});

});

Houston.IssuesIndexRoute = Ember.Route.extend({
	actions: {
		githubSyncComplete: function(data) {
			this.refresh();
		}
	},
	model: function() {
		this.store.find('issue');
		return this.store.filter('issue', function(issue) {
			if (!issue.get('archived') && issue.get('assignee') == 'kevinmpowell')
			return issue;
		});
	}
});

Houston.IssuesByClientRoute = Ember.Route.extend({
	controllerName: 'issues_index',
	actions: {
		githubSyncComplete: function(data) {
			this.refresh();
		}
	},
	model: function(params){
		this.store.find('issue');
		return this.store.filter('issue', function(issue) {
			if (issue.get('client_name') == params.client_name && !issue.get('archived') && issue.get('assignee') == 'kevinmpowell')
			return issue;
		});
	},
	renderTemplate: function(controller) {
		this.render('issues/index', {controller: 'issues_index'});
	}
})