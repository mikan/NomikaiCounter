import ceylon.html {
	H1,
	H2,
	Body,
	Node,
	P,
	Div,
	Form,
	TextInput,
	Input,
	submit,
	Br,
	Dl,
	Dd,
	Dt,
	A,
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

"The /***/yes page content."
by ("Yutaka Kato")
shared class YesView(Session session) extends View() {
	
	shared actual Node getHtml(Request request) {
		return Html {
			doctype = html5;
			head(session.subject + " への参加");
			Body {
				Div {
					id = "wrapper";
					H1(title),
					H2 {
						classNames = "yes";
						text = session.subject + " への参加";
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
								valueOf = "yes";
							},
							Input("参加!", submit)
						}
					},
					P {
						A {
							classNames = "ornot";
							href = "./no";
							text = "不参加に切り替え";
						}
					},
					footer()
				}
			};
		};
	}
}
