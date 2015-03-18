import ceylon.html {
	H2,
	Body,
	P,
	Node,
	Form,
	TextInput,
	Div,
	submit,
	Input,
	Br,
	H1,
	A,
	html5,
	Html
}
import ceylon.net.http.server {
	Request
}

"The /new page content."
by ("Yutaka Kato")
shared class NewView() extends View() {
	
	shared actual Node getHtml(Request request) {
		return Html {
			doctype = html5;
			head("新規作成 / Create");
			Body {
				Div {
					id = "wrapper";
					H1(title),
					H2("新規作成 / Create"),
					Form {
						action = "/";
						method = "post";
						acceptCharset = "UTF-8";
						Div {
							P("名前 / Your Name"),
							TextInput {
								name = "name";
								required = true;
							},
							P("件名 / Subject"),
							TextInput {
								name = "subject";
								required = true;
							},
							P("開催概要 / Description"),
							TextInput {
								name = "description";
								required = false;
							},
							P("回答納期 / Deadline"),
							TextInput {
								name = "deadline";
								required = false;
								id = "datepicker";
							},
							Br(),
							Input("作成", submit)
						}
					},
					Div {
						id = "navi";
						A {
							text = "探索 / Explore";
							href = "/explore";
						}
					},
					footer()
				}
			};
		};
	}
}
