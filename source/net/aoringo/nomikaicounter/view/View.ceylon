import ceylon.html {
	Link,
	LinkType,
	Node,
	Script,
	Div,
	P,
	CharsetMeta,
	Head
}
import ceylon.net.http.server {
	Request
}

"Base of pages."
by ("Yutaka Kato")
shared abstract class View() {
	
	String _title = "Nomikai Counter";
	String path = "/resource/";
	String jqPath = path + "jquery/";
	String jquiPath = path + "jqueryui/";
	
	"Getter of title."
	shared String title => _title;
	
	"Create head element with specified title."
	shared Head head(String title) {
		return Head {
			title = title;
			CharsetMeta("utf-8"),
			Link("StyleSheet", path + "main.css", LinkType("text/css")),
			Link("StyleSheet", jquiPath + "jquery-ui.min.css", LinkType("text/css")),
			Script(jqPath + "jquery-1.11.2.min.js"),
			Script(jquiPath + "jquery-ui.min.js"),
			Script(path + "main.js")
		};
	}
	
	shared Div footer() {
		return Div {
			id = "footer";
			P("Copyright&copy; 2014-2015 Yutaka Kato"),
			P("Written in Ceylon language")
		};
	}
	
	shared String textOrEmptyMessage(String source) {
		if (source.empty) {
			return "(なし)";
		}
		return source;
	}
	
	shared formal Node getHtml(Request request);
}
