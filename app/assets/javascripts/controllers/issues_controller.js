Houston.IssuesController = Ember.ArrayController.extend({
  actions: {
    createTodo: function() {
      alert("DO STUFF!");
      // Get the todo title set by the "New Todo" text field
      // var title = this.get('newTitle');
      // if (!title) { return false; }
      // if (!title.trim()) { return; }

      // // Create the new Todo model
      // var todo = this.store.createRecord('todo', {
      //   title: title,
      //   isCompleted: false
      // });

      // // Clear the "New Todo" text field
      // this.set('newTitle', '');

      // // Save the new model
      // todo.save();
    }
  },
  remaining: function() {
    return this.filterBy('client_name', 'marriott').get('length');
  }.property('@each.archived'),
  inflection: function() {
    var remaining = this.get('remaining');
    return remaining === 1 ? 'issue' : 'issues';
  }.property('remaining')
});


