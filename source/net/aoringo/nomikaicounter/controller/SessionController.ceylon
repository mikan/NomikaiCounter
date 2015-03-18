import ceylon.html.serializer {
	NodeSerializer
}
import ceylon.net.http.server {
	Request,
	Response
}
import net.aoringo.nomikaicounter.view {
	SessionView,
	ErrorView
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
			NodeSerializer(response.writeString).serialize(
				ErrorView("Missing ID.").getHtml(request));
			return;
		}
		SessionRepository repo = MongoSessionRepository();
		if (!repo.isValid(id)) {
			NodeSerializer(response.writeString).serialize(
				ErrorView("Illegal ID: " + id).getHtml(request));
			return;
		}
		Session? session = repo.findSessionById(id);
		if (exists session) {
			NodeSerializer(response.writeString).serialize(SessionView(session).getHtml(request));
		} else {
			NodeSerializer(response.writeString).serialize(
				ErrorView("Session not found.").getHtml(request));
		}
	}
	
	shared actual void handlePost(Request request, Response response) {
		// No action.
	}
}
