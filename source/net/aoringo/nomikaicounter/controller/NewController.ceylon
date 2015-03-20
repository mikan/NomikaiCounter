import ceylon.html.serializer {
	NodeSerializer
}
import ceylon.net.http.server {
	Request,
	Response
}
import net.aoringo.nomikaicounter.model.mongo {
	MongoSessionRepository
}
import net.aoringo.nomikaicounter.view {
	NewView,
	ErrorView,
	SessionView
}
import net.aoringo.nomikaicounter.model {
	Session,
	SessionRepository
}
import net.aoringo.nomikaicounter.controller {
	Controller
}

by ("Yutaka Kato")
shared class NewController() extends Controller() {
	
	SessionRepository repository = MongoSessionRepository();
	
	"Handle /new actions."
	shared actual void handleGet(Request request, Response response) {
		NodeSerializer(response.writeString).serialize(NewView().getHtml(request));
	}
	
	shared actual void handlePost(Request request, Response response) {
		print("[new] POST received.");
		assert (exists name = request.parameter("name"));
		assert (exists subject = request.parameter("subject"));
		assert (exists description = request.parameter("description"));
		assert (exists deadline = request.parameter("deadline"));
		if (!isValidText(name) || !isValidText(subject) || !isValidText(description) || !isValidText(deadline)) {
			NodeSerializer(response.writeString).serialize(ErrorView("Illegal character(s) contained.").getHtml(request));
			return;
		}
		Session session = Session();
		session.author = iso2unicode(name);
		session.subject = iso2unicode(subject);
		session.description = iso2unicode(description);
		session.deadline = iso2unicode(deadline);
		print("[new] parameters: " + session.toString());
		
		// Check duplicates.
		try {
			Session? duplicateCheck = repository.findSessionBySessionObject(session);
			if (exists duplicateCheck) {
				print("[new] session duplicated!");
				NodeSerializer(response.writeString).serialize(ErrorView("Session already found.").getHtml(request));
				return;
			} else {
				print("[new] ready to insert");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// Insert new session.
		repository.insertSession(session);
		Session? inserted = repository.findSessionBySessionObject(session);
		if (exists inserted) {
			NodeSerializer(response.writeString).serialize(SessionView(inserted).getHtml(request));
		} else {
			NodeSerializer(response.writeString).serialize(ErrorView("Insert failed.").getHtml(request));
		}
	}
}
