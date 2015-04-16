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
import net.aoringo.nomikaicounter {

	Configuration
}

"Base of pages."
by ("Yutaka Kato")
shared abstract class View() {
	
	Configuration conf = Configuration();
	String path = conf.resourceDir;
	String jqPath = path + "jquery/";
	String jqUiPath = path + "jqueryui/";
	
	"Getter of title."
	shared String title => conf.title;
	
	"Create head element with specified title."
	shared Head head(String title) {
		return Head {
			title = title;
			CharsetMeta("utf-8"),
			Link("StyleSheet", path + "main.css", LinkType("text/css")),
			Link("StyleSheet", jqUiPath + "jquery-ui.min.css", LinkType("text/css")),
			Script(jqPath + "jquery-1.11.2.min.js"),
			Script(jqUiPath + "jquery-ui.min.js"),
			Script(path + "main.js")
		};
	}
	
	shared Div footer() {
		return Div {
			id = "footer";
			P(conf.versionLabel),
			P(conf.copyright)
		};
	}
	
	shared String textOrEmptyMessage(String source) {
		if (source.empty) {
			return "(empty)";
		}
		return source;
	}
	
	shared formal Node getHtml(Request request);
}
