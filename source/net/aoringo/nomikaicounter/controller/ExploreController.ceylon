import ceylon.net.http.server {

	Request,
	Response
}
import net.aoringo.nomikaicounter.model.mongo {

	MongoSessionRepository
}
import net.aoringo.nomikaicounter.model {

	SessionRepository,
	Session
}
import net.aoringo.nomikaicounter.view {
	ExploreView
}
import ceylon.html.serializer {

	NodeSerializer
}
by ("Yutaka Kato")
shared class ExploreController() extends Controller() {
	
	SessionRepository repository = MongoSessionRepository();
	
	shared actual void handleGet(Request request, Response response) {
		List<Session> sessions = repository.findRecentSessions(30);
		NodeSerializer(response.writeString).serialize(ExploreView(sessions).getHtml(request));
	}
	
	shared actual void handlePost(Request request, Response response) {
		// no action
	}
	
}