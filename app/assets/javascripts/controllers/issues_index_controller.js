Houston.IssuesIndexController = Ember.ArrayController.extend({
  sortProperties: ['local_sort_order'],
  sortAscending: true,
  visible: function() {
    return this.get('length');
  }.property('length'),
  inflection: function() {
    var visible = this.get('visible');
    return visible === 1 ? 'issue' : 'issues';
  }.property('visible'),
  updateSortOrder: function(sorted_issue_ids) {
    $.ajax({
      url:'/update-issue-sort-order.json',
      data: {
        sorted_issue_ids: sorted_issue_ids
      },
      dataType:'html',
      type: 'PUT',
      success: function(){
        // DO NOTHING
        // alert("SORTED!");
      },
      error: function(a, b, c){
        console.log(a);
        console.log(b);
        console.log(c);
        alert("An error occurred while saving the sort order");
      }
    });
  },
  actions: {
    archiveIssue: function() {
      var issue = this.get('model');
      issue.set('archived', true);
      issue.save();
    }
  }
});