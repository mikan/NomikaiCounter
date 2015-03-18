import ceylon.collection {
	ArrayList
}
import ceylon.interop.java {
	CeylonIterable,
	CeylonDestroyable,
	javaString
}
import ceylon.json {
	Object,
	Array
}
import com.mongodb {
	MongoClient,
	DBObject,
	DBCollection,
	BasicDBObject,
	WriteResult,
	BasicDBList
}
import com.mongodb.util {
	JSON
}
import java.lang {
	IllegalArgumentException,
	JavaInteger=Integer
}
import net.aoringo.nomikaicounter.model {
	SessionRepository,
	Session
}
import org.bson.types {
	ObjectId
}

"See API: http://api.mongodb.org/java/current/index.html"
by ("Yutaka Kato")
shared class MongoSessionRepository() satisfies SessionRepository {
	
	Configuration conf = Configuration();
	DBCollection colls = MongoClient(conf.host, conf.port).getDB(conf.db).getCollection(conf.colls);
	String idField = "_id";
	String authorField = "author";
	String subjectField = "subject";
	String descriptionField = "description";
	String deadlineField = "deadline";
	String postsField = "posts";
	String nameField = "name";
	String actionField = "action";
	String messageField = "message";
	
	shared actual Boolean isValid(String id) {
		try {
			ObjectId(id);
			return true;
		} catch (IllegalArgumentException e) {
			return false;
		}
	}
	
	"Find session by id"
	shared actual Session? findSessionById(String id) {
		print("[mongo] findSessionById(" + id + ") begin");
		DBObject query = BasicDBObject(idField, ObjectId(id));
		try (dbCursor = CeylonDestroyable(colls.find(query))) {
			for (dbObject in CeylonIterable(dbCursor.resource)) {
				Session result = createSession(dbObject);
				print("[mongo] findSessionById(" + id + ") returns " + result.subject);
				return result;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		print("[mongo] findSessionById(" + id + ") returns null");
		return null;
	}
	
	"Find session by author, subject, description and deadline."
	shared actual Session? findSessionBySessionObject(Session session) {
		print("[mongo] findSessionBySessionObject(" + session.subject + ") begin");
		DBObject query = BasicDBObject()
			.append(authorField, javaString(session.author))
			.append(subjectField, javaString(session.subject))
			.append(descriptionField, javaString(session.description))
			.append(deadlineField, javaString(session.deadline));
		try (dbCursor = CeylonDestroyable(colls.find(query))) {
			for (dbObject in CeylonIterable(dbCursor.resource)) {
				Session result = createSession(dbObject);
				print("[mongo] findSessionBySessionObject(" + session.subject + ") returns " + result.subject);
				return result;
			}
		}
		print("[mongo] findSessionBySessionObject(" + session.subject + ") returns null");
		return null;
	}
	
	shared actual List<Session> findRecentSessions(Integer limit) {
		print("[mongo] findRecentSessions(" + limit.string + ") begin");
		ArrayList<Session> sessions = ArrayList<Session>();
		DBObject sortOrder = BasicDBObject("$natural", JavaInteger(-1));
		try (dbCursor = CeylonDestroyable(colls.find().sort(sortOrder).limit(limit))) {
			for (dbObject in CeylonIterable(dbCursor.resource)) {
				sessions.add(createSession(dbObject));
			}
		}
		print("[mongo] findRecentSessions(" + limit.string + ") end. Size is " + sessions.size.string);
		return sessions;
	}
	
	shared actual void insertSession(Session session) {
		print("[mongo] insertSession(" + session.subject + ") begin");
		Object obj = Object {
			authorField->session.author,
			subjectField->session.subject,
			descriptionField->session.description,
			deadlineField->session.deadline,
			postsField->Array { }
		};
		assert (is DBObject v = JSON.parse(obj.string));
		WriteResult result = colls.insert(v);
		print(result);
		try (dbCursor = CeylonDestroyable(colls.find())) {
			for (dbObject in CeylonIterable(dbCursor.resource)) {
				print(dbObject);
			}
		}
		print("[mongo] insertSession(" + session.subject + ") end");
	}
	
	shared actual void addPost(Session session, Session.Post post) {
		print("[mongo] addPost() begin");
		DBObject findQuery;
		if (!session.id.empty) {
			findQuery = BasicDBObject(idField, ObjectId(session.id));
		} else {
			print("[mongo] Warning: id is missing. Creating query with non-identity params.");
			findQuery = BasicDBObject()
				.append(authorField, javaString(session.author))
				.append(subjectField, javaString(session.subject))
				.append(descriptionField, javaString(session.description))
				.append(deadlineField, javaString(session.deadline));
		}
		DBObject postItem = BasicDBObject()
			.append(nameField, javaString(post.name))
			.append(actionField, javaString(post.action))
			.append(messageField, javaString(post.message));
		DBObject updateQuery = BasicDBObject("$push", BasicDBObject(postsField, postItem));
		
		WriteResult result = colls.update(findQuery, updateQuery);
		print("[mongo] addPost() end. Result is " + result.string);
	}
	
	Session createSession(DBObject dbObject) {
		Session session = Session();
		if (is ObjectId id = dbObject.get(idField)) {
			session.id = id.string;
		}
		if (dbObject.containsField(authorField)) {
			session.author = dbObject.get(authorField).string;
		}
		if (dbObject.containsField(subjectField)) {
			session.subject = dbObject.get(subjectField).string;
		}
		if (dbObject.containsField(descriptionField)) {
			session.description = dbObject.get(descriptionField).string;
		}
		if (dbObject.containsField(deadlineField)) {
			session.deadline = dbObject.get(deadlineField).string;
		}
		if (dbObject.containsField(postsField)) {
			if (is BasicDBList dbList = JSON.parse(dbObject.get(postsField).string)) {
				for (obj in CeylonIterable(dbList)) {
					if (is DBObject postObj = obj) {
						String name = postObj.get(nameField).string;
						String action = postObj.get(actionField).string;
						String message = postObj.get(messageField).string;
						session.posts.add(session.createPost(name, action, message));
						print("[mongo] ADDED " + name + " " + action + " " + message);
					}
				}
			} else {
				print("[mongo] ERROR: Posts data parse failed.");
			}
		}
		print("session.posts.size=" + session.posts.size.string);
		return session;
	}
}
