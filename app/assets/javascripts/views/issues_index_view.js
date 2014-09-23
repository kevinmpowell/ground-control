Houston.IssuesIndexView = Ember.View.extend({
	didInsertElement: function() {
		var controller = this.get('controller');
		this.$(".issue-list").sortable({
			axis: "y",
			stop: function(event, ui) {
				var sorted_issue_ids = $(".issue-list").sortable("toArray", {attribute:"data-issue-id"}).filter(function(item,idx){return item !== "";}); //Filter strips empty ember-added items
				controller.updateSortOrder(sorted_issue_ids);
			}
		});
	}
});