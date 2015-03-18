"Repository definition of drinking sessions."
by ("Yutaka Kato")
shared interface SessionRepository {
	
	shared formal Boolean isValid(String id);
	shared formal Session? findSessionById(String id);
	shared formal Session? findSessionBySessionObject(Session session);
	shared formal List<Session> findRecentSessions(Integer limit);
	shared formal void insertSession(Session session);
	shared formal void addPost(Session session, Session.Post post);
}
