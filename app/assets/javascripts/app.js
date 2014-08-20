// Nothing here yet

var dispatcher = new WebSocketRails('localhost:3001/websocket');

dispatcher.bind('github_status', function(data) {
  console.log(data); // would output 'this is a message'
});

dispatcher.on_open = function(data) {
  console.log('Connection has been established: ', data);
  // You can trigger new server events inside this callback if you wish.
	dispatcher.trigger('testing', {something: "here"});
}

