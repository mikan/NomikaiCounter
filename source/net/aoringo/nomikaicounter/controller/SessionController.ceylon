import ceylon.html.serializer {
	NodeSerializer
}
import ceylon.net.http.server {
	Request,
	Response
}
import net.aoringo.nomikaicounter.view {
	SessionView
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
shared class SessionController() extends Controller() {
	
	shared actual void handleGet(Request request, Response response) {
		String id = getId(request.path);
		if (id.empty) {
			showError(request, response, "Missing ID.");
			return;
		}
		SessionRepository repo = MongoSessionRepository();
		if (!repo.isValid(id)) {
			showError(request, response, "Illegal ID: " + id);
			return;
		}
		Session? session = repo.findSessionById(id);
		if (exists session) {
			NodeSerializer(response.writeString).serialize(SessionView(session).getHtml(request));
		} else {
			showError(request, response, "Session not found.");
		}
	}
	
	shared actual void handlePost(Request request, Response response) {
		// No action.
	}
}
