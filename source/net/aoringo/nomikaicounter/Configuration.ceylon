by ("Yutaka Kato")
shared class Configuration() {
	
	String _address = "0.0.0.0";
	Integer _port = 10000;
	String _contentRoot = ".";
	String _resourceDir = "/resources/";
	String _title = "Nomikai Counter";
	String _versionLabel = "NomikaiCounter v1.0.0, Written in <a href=\"http://ceylon-lang.org/\">Ceylon</a>";
	String _copyright = "Copyright&copy; 2014-2015 Yutaka Kato";
	
	shared String address => _address;
	shared Integer port => _port;
	shared String contentRoot = _contentRoot;
	shared String resourceDir = _resourceDir;
	shared String title => _title;
	shared String versionLabel => _versionLabel;
	shared String copyright => _copyright;
}
