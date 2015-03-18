import ceylon.html {
	Node,
	H2,
	Body,
	H1,
	Div,
	A,
	html5,
	Html
}
import ceylon.net.http.server {
	Request
}

import net.aoringo.nomikaicounter.model {
	Session
}
"The explore page content."
by ("Yutaka Kato")
shared class ExploreView(List<Session> sessions) extends View() {
	shared actual Node getHtml(Request request) {
		return Html {
			doctype = html5;
			head("探索 / Explore");
			Body {
				Div {
					id = "wrapper";
					H1(title),
					H2("探索 / Explore"),
					Div(table()),
					Div {
						id = "navi";
						A {
							text = "戻る / Go back";
							href = "/";
						}
					},
					footer()
				}
			};
		};
	}
	
	String table() {
		if (sessions.empty) {
			return "<div style=\"color:red\">(データがありません)</div>";
		}
		variable String result = "<table>";
		result += "<tr><th>作成者</th><th>件名</th><th>回答納期</th></tr>";
		for (session in sessions) {
			result += "<tr>"
					+ "<td>" + session.author + "</td>"
					+ "<td><a href=\"/" + session.id + "/\">" + session.subject + "</a></td>"
					+ "<td>" + session.deadline + "</td>"
					+ "</tr>";
		}
		result += "</table>";
		return result;
	}
}
