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
//= require angular/angular
//= require pusher-angular.min
//= require_self

// for more details see: http://emberjs.com/guides/application/
(function(){
	window.client = new Pusher('1bd4ccfda7bf1b908b19');
	var app = angular.module("groundControl", ['pusher-angular']);

	app.filter('unique', function() {
	    return function(input, key) {
	        var unique = {};
	        var uniqueList = [];
	        for(var i = 0; i < input.length; i++){
	            if(typeof unique[input[i][key]] == "undefined"){
	                unique[input[i][key]] = "";
	                uniqueList.push(input[i]);
	            }
	        }
	        return uniqueList;
	    };
	});

	app.controller("AppController", ['$http', '$pusher', '$rootScope', function($http, $pusher, $rootScope){
		var appController = this;
		this.name = "Ground Control";
		this.issues_to_be_synced = 0;
		this.issues_synchronized = 0;
		this.progress_bar_width = "0";
		this.github_sync_complete = false;
		this.github_syncing = false;

		var pusher = $pusher(client);		
		var user_channel = pusher.subscribe('kevin-powell-pusher-channel');

		user_channel.bind('github_issue_sync_count', function(data){
			appController.issues_to_be_synced = data.total_issues;
			appController.issues_synchronized = 0;

			if (appController.issues_synchronized == appController.issues_to_be_synced) {
				alert("NOTHING TO SYNC");
			}
		});

		user_channel.bind('github_issue_synced', function(data){
			appController.github_issue_synced(data);
		});

		this.github_issue_synced = function(data) {
			appController.issues_synchronized = appController.issues_synchronized + 1;
			console.log(appController.issues_synchronized);
			console.log(appController.issues_to_be_synced);
			if (appController.issues_synchronized == appController.issues_to_be_synced) {
				appController.progress_bar_width = '100%';
				// this.get("controllers.issuesIndex").send("githubSyncComplete");
				appController.github_sync_complete = true;
				appController.github_syncing = false;
				$rootScope.$broadcast("github_sync_complete");
			}
			else {
				var width = ( appController.issues_synchronized / appController.issues_to_be_synced ) * 100;
				appController.progress_bar_width = width + '%';
				appController.github_syncing = true;
			}
		}

		this.sync_github_issues = function(){
			this.progress_bar_width = '0';
			this.github_syncing = true;
			this.github_sync_complete = false;

			$http.put('/synchronize-github-issues-for-user/' + current_user_id);
		}

	}]);

	app.controller("IssuesController", ['$http', '$filter', '$scope', '$rootScope', function($http, $filter, $scope, $rootScope){
		var issuesController = this;
		this.issues = [];
		this.filtered_issues = [];
		this.active_client = "all";

		this.client_active = function(client_name) {
			return this.active_client === client_name;
		}

		this.filter_issues_by_client = function(client_name) {
			this.active_client = client_name;
			this.apply_client_filter();
		}

		this.apply_client_filter = function() {
			if (this.active_client === "all") {
				this.filtered_issues = this.issues;
			}
			else {
				this.filtered_issues = $filter('filter')(this.issues, {client_name: this.active_client})
			}
		}

		this.update_visible_issues_count = function(){
			this.visible_issues_count = $(".issue-list-item:visible").length;
		}

		this.load_active_issues = function(){
			$http.get('/issues.json').success(function(data){
				var issues = $filter('filter')(data, function(issue, index){
					return issue.archived === false;
				});
				issues = $filter('orderBy')(issues, 'local_sort_order');
				issuesController.issues = issues;
				issuesController.apply_client_filter();
			}).error(function(a,b,c){
				alert("an error occurred");
			});
		};

		this.update_sort_order = function(sorted_issue_ids){
			$http.put('/update-issue-sort-order.json', {sorted_issue_ids: sorted_issue_ids}).success(function(){
				issuesController.load_active_issues();
			});
		}

		$scope.archive_issue = function(issue_id){
			$http.put('/issues/' + issue_id + '.json', {archived: true}).success(function(data){
				issuesController.load_active_issues();
			});
		}

		$rootScope.$on("github_sync_complete", function(){
			issuesController.load_active_issues();
		});

		$(".issue-list").sortable({
			axis: "y",
			stop: function(event, ui) {
				var sorted_issue_ids = $(".issue-list").sortable("toArray", {attribute:"data-issue-id"});
				issuesController.update_sort_order(sorted_issue_ids);
			}
		});

		this.load_active_issues();
	}]);

	app.controller("ClientReposController", ['$http', '$filter', function($http, $filter){
		var clientReposController = this;
		this.client_names = [];

		this.load_client_names = function(){
			$http.get('/client_repos.json').success(function(data){
				var client_names = $filter('unique')(data, 'client_name');
				clientReposController.client_names = client_names;
			});
		}

		this.load_client_names();
	}]);
})();

function copy_github_commit_data_to_clipboard() {
	var issue_url = $(".issue-list-item:visible:first").find(".issue-list-item-title a").attr("href");
	var github_commit_string = 'git commit -m "[amends ' + issue_url + '] ';
	window.prompt("Copy to clipboard: Ctrl+C, Enter", github_commit_string);
}

$(document).on('keydown', null, 'ctrl+g', function() {
	copy_github_commit_data_to_clipboard();
});


//= require_tree .

