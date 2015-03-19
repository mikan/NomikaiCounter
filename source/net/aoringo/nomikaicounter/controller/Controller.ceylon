import ceylon.net.http.server {
	Request,
	Response
}
import net.aoringo.nomikaicounter.view {
	ErrorView
}
import ceylon.html.serializer {
	NodeSerializer
}
import ceylon.io.charset {
	utf8,
	iso_8859_1,
	getCharset,
	Charset
}
import ceylon.net.http {

	Header
}

"Base of controllers."
by ("Yutaka Kato")
shared abstract class Controller() {
	
	"Handle requests."
	shared void handle(Request request, Response response) {
		response.addHeader(Header("Content-Type", "text/html; charset=UTF-8"));
		switch (request.method.string)
		case ("GET") {
			handleGet(request, response);
		}
		case ("POST") {
			handlePost(request, response);
		}
		else {
			NodeSerializer(response.writeString).serialize(
				ErrorView("Unsupported operation.").getHtml(request));
		}
	}
	
	shared formal void handleGet(Request request, Response response);
	
	shared formal void handlePost(Request request, Response response);
	
	"Get id from path. Returns id, or empty string if not found."
	shared String getId(String path) {
		Iterator<String> i = path.split('/'.equals, true, true).iterator();
		while (is String token = i.next()) {
			if (!token.empty) {
				return token;
			}
		}
		return "";
	}
	
	shared String iso2unicode(String iso) {
		Charset? charset = getCharset(iso);
		if (exists charset) {
			if (charset.equals(utf8)) {
				return iso;
			}
		}
		return utf8.decode(iso_8859_1.encode(iso));
	}
}
