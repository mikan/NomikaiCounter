import ceylon.html {
	H2,
	Body,
	Node,
	H1,
	Div,
	Dl,
	Dt,
	Dd,
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
import net.aoringo.nomikaicounter.view {
	View
}
import ceylon.io {

	SocketAddress
}

"The /***/ page content."
by ("Yutaka Kato")
shared class SessionView(Session session) extends View() {
	
	shared actual Node getHtml(Request request) {
		return Html {
			doctype = html5;
			head(session.subject);
			Body {
				Div {
					id = "wrapper";
					H1(title),
					H2(session.subject),
					Dl {
						Dt("作成者 / Author"),
						Dd(session.author),
						Dt("件名 / Subject"),
						Dd(session.subject),
						Dt("開催概要 / Description"),
						Dd(textOrEmptyMessage(session.description)),
						Dt("回答納期 / Deadline"),
						Dd(textOrEmptyMessage(session.deadline))
					},
					Dl {
						Dt("参加ページURL"),
						Dd {
							A {
								text = getUri(request, session.id) + "yes";
								href = getUri(request, session.id) + "yes";
								
							}
						},
						Dt("不参加ページURL"),
						Dd {
							A {
								text = getUri(request, session.id) + "no";
								href = getUri(request, session.id) + "no";
							}
						}
					},
					Dl {
						Dt("参加表明数"),
						Dd(session.countYes().string),
						Dt("不参加表明数"),
						Dd(session.countNo().string)
					},
					Div(table()),
					footer()
				}
			};
		};
	}
	
	String getUri(Request request, String id) {
		variable String path = request.path;
		if (!path.contains(id)) {
			path = "/" + id + "/";
		}
		SocketAddress address = request.destinationAddress;
		if (address.port.equals(80)) {
			return "http://" + address.address + path;
		} else {
			return "http://" + address.address + ":" + address.port.string + path;			
		}
	}
	
	String table() {
		if (session.posts.empty) {
			return "<div style=\"color:red\">(データがありません)</div>";
		}
		variable String result = "<table>";
		result += "<tr><th>回答者</th><th>回答</th><th>メッセージ</th></tr>";
		for (post in session.posts) {
			if (post.isYes()) {
				result += "<tr>"
						+ "<td>" + post.name + "</td>"
						+ "<td class=\"yes\">" + post.action.uppercased + "</td>"
						+ "<td>" + post.message + "</td>"
						+ "</tr>";				
			} else {
				result += "<tr>"
						+ "<td>" + post.name + "</td>"
						+ "<td class=\"no\">" + post.action.uppercased + "</td>"
						+ "<td>" + post.message + "</td>"
						+ "</tr>";

			}
		}
		result += "</table>";
		return result;
	}
}
