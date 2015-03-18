import ceylon.html {
	H2,
	Body,
	Node,
	P,
	H1,
	Div,
	submit,
	Br,
	Dt,
	TextInput,
	Dl,
	Form,
	Input,
	A,
	Dd,
	hidden,
	html5,
	Html
}
import ceylon.net.http.server {
	Request
}

import net.aoringo.nomikaicounter.model {
	Session
}

"The /***/no page content."
by ("Yutaka Kato")
shared class NoView(Session session) extends View() {
	
	shared actual Node getHtml(Request request) {
		return Html {
			doctype = html5;
			head(session.subject + " への不参加");
			Body {
				Div {
					id = "wrapper";
					H1(title),
					H2 {
						classNames = "no";
						text = session.subject + " への不参加";
					},
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
					Form {
						action = "";
						method = "post";
						Div {
							P("名前 / Your Name"),
							TextInput {
								name = "name";
								required = true;
							},
							P("メッセージ / Massage"),
							TextInput("message"),
							Br(),
							Input {
								name = "sessionId";
								type = hidden;
								valueOf = session.id;
							},
							Input {
								name = "action";
								type = hidden;
								valueOf = "no";
							},
							Input("不参加", submit)
						}
					},
					P {
						A {
							classNames = "ornot";
							href = "./yes";
							text = "参加に切り替え";
						}
					},
					footer()
				}
			};
		};
	}
}
