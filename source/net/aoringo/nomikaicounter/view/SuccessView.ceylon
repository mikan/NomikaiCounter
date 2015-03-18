import ceylon.html {
	Node,
	Body,
	Div,
	H1,
	H2,
	P,
	html5,
	Html
}
import ceylon.net.http.server {
	Request
}
shared class SuccessView() extends View() {
	shared actual Node getHtml(Request request) {
		return Html {
			doctype = html5;
			head("完了");
			Body {
				Div {
					id = "wrapper";
					H1(title),
					H2("完了 / Success"),
					P("登録が完了しました。ありがとうございました。"),
					footer()
				}
			};
		};
	}
}
