import ceylon.collection {

	ArrayList
}
"The session entity."
by ("Yutaka Kato")
shared class Session() {
	variable String _id = "";
	variable String _author = "";
	variable String _subject = "";
	variable String _description = "";
	variable String _deadline = "";
	variable ArrayList<Post> _posts = ArrayList<Post>();
	shared String id => _id;
	assign id => _id = id;
	shared String author => _author;
	assign author => _author = author;
	shared String subject => _subject;
	assign subject => _subject = subject;
	shared String description => _description;
	assign description => _description = description;
	shared String deadline => _deadline;
	assign deadline => _deadline = deadline;
	shared ArrayList<Post> posts => _posts;
	assign posts => _posts = posts;
	
	shared String toString() {
		return "[new] name=" + author + " subject=" + subject + " description=" + description + " deadline=" + deadline;
	}
	
	shared Post createPost(String name, String action, String message) {
		Post post = Post();
		post.name = name;
		post.action = action;
		post.message = message;
		return post;
	}
	
	shared Integer countYes() {
		return posts.count((Session.Post element) => element.action.equals("yes"));
	}
	
	shared Integer countNo() {
		return posts.count((Session.Post element) => element.action.equals("no"));
	}
	
	shared class Post() {
		variable String _name = "";
		variable String _action = "";
		variable String _message = "";
		shared String name => _name;
		assign name => _name = name;
		shared String action => _action;
		assign action => _action = action;
		shared String message => _message;
		assign message => _message = message;
		
		shared Boolean isYes() {
			return action.equals("yes");
		}
	}
}
