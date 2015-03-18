import ceylon.html {
	Node,
	H2,
	Body,
	P,
	H1,
	Div,
	html5,
	Html
}
import ceylon.net.http.server {
	Request
}

"The error page content."
by ("Yutaka Kato")
shared class ErrorView(String errorMessage) extends View() {
	
	shared actual Node getHtml(Request request) {
		return Html {
			doctype = html5;
			head("ERROR");
			Body {
				Div {
					id = "wrapper";
					H1(title),
					H2("ERROR"),
					P {
						text = errorMessage;
						classNames = "error";
					},
					footer()
				}
			};
		};
	}
}
