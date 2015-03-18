import ceylon.net.http.server {
	Request,
	Response
}
import net.aoringo.nomikaicounter.view {
	NoView,
	ErrorView,
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
			NodeSerializer(response.writeString).serialize(NoView(session).getHtml(request));
		} else {
			NodeSerializer(response.writeString).serialize(
				ErrorView("Session not found.").getHtml(request));
		}
	}
	
	shared actual void handlePost(Request request, Response response) {
		assert (exists String sessionId = request.parameter("sessionId"));
		assert (exists String name = request.parameter("name"));
		assert (exists String action = request.parameter("action"));
		assert (exists String message = request.parameter("message"));
		Session? session = repository.findSessionById(sessionId);
		if (exists session) {
			Session.Post post = session.createPost(
				iso2unicode(name),
				iso2unicode(action),
				iso2unicode(message));
			repository.addPost(session, post);
			NodeSerializer(response.writeString).serialize(SuccessView().getHtml(request));
		} else {
			NodeSerializer(response.writeString).serialize(
				ErrorView("Session not found.").getHtml(request));
		}
	}
}
