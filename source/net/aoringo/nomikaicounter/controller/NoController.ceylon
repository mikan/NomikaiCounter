import ceylon.net.http.server {
	Request,
	Response
}
import net.aoringo.nomikaicounter.view {
	NoView,
	SuccessView
}
import ceylon.html.serializer {
	NodeSerializer
}
import net.aoringo.nomikaicounter.model.mongo {
	MongoSessionRepository
}
import net.aoringo.nomikaicounter.model {
	Session,
	SessionRepository
}
import net.aoringo.nomikaicounter.controller {
	Controller
}

by ("Yutaka Kato")
shared class NoController() extends Controller() {
	
	SessionRepository repository = MongoSessionRepository();
	
	shared actual void handleGet(Request request, Response response) {
		String id = getId(request.path);
		if (id.empty) {
			showError(request, response, "Missing ID.");
			return;
		}
		if (!repository.isValid(id)) {
			showError(request, response, "Illegal ID: " + id);
			return;
		}
		Session? session = repository.findSessionById(id);
		if (exists session) {
			NodeSerializer(response.writeString).serialize(NoView(session).getHtml(request));
		} else {
			showError(request, response, "Session not found.");
		}
	}
	
	shared actual void handlePost(Request request, Response response) {
		assert (exists String sessionId = request.parameter("sessionId"));
		assert (exists String name = request.parameter("name"));
		assert (exists String action = request.parameter("action"));
		assert (exists String message = request.parameter("message"));
		
		// Check parameters
		if (name.empty) {
			showError(request, response, "Name is empty.");
			return;
		} else if (!isValidText(name)) {
			showError(request, response, "Name contains illegal character.");
			return;
		} else if (action.empty) {
			showError(request, response, "Action is empty.");
			return;
		} else if (!isValidText(action)) {
			showError(request, response, "Action contains illegal character.");
			return;
		} else if (!isValidText(message)) {
			showError(request, response, "Message contains illegal character.");
			return;
		}
		
		Session? session = repository.findSessionById(sessionId);
		if (exists session) {
			Session.Post post = session.createPost(
				iso2unicode(name),
				iso2unicode(action),
				iso2unicode(message));
			repository.addPost(session, post);
			NodeSerializer(response.writeString).serialize(SuccessView().getHtml(request));
		} else {
			showError(request, response, "Session not found.");
		}
	}
}
