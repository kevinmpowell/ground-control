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
//= require_self

// for more details see: http://emberjs.com/guides/application/
(function(){
	var app = angular.module("groundControl", [ ]);

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

	app.controller("AppController", function(){
		this.name = "Ground Control";
	});

	app.controller("IssuesController", ['$http', '$filter', '$scope', function($http, $filter, $scope){
		var issuesController = this;
		this.issues = [];

		this.load_active_issues = function(){
			$http.get('/issues.json').success(function(data){
				var issues = $filter('filter')(data, function(issue, index){
					return issue.archived === false;
				});
				issues = $filter('orderBy')(issues, 'local_sort_order');
				issuesController.issues = issues;
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

