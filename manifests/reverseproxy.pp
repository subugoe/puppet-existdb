# configure reverse proxies for eXist-db servers
class existdb::reverseproxy
(
  $servers,
  $exist_home    = '/usr/local/existdb',
  $exist_service = 'eXist-db',
)
{
  create_resources(existdb::reverseproxy::server, $servers)

  augeas
  { 'eXist jetty-http.xml' :
    lens    => 'Xml.lns',
    incl    => "${exist_home}/etc/jetty/jetty-http.xml",
    context => "/files${exist_home}/etc/jetty/jetty-http.xml/",
    changes =>
    [
      'ins New before Configure/Call[#attribute/name = "addConnector"]',
      'set Configure/New/#attribute/id httpConfig',
      'set Configure/New[#attribute/id = "httpConfig"]/#attribute/class org.eclipse.jetty.server.HttpConfiguration',
      'set Configure/New[#attribute/id = "httpConfig"]/Call/#attribute/name addCustomizer',
      'set Configure/New[#attribute/id = "httpConfig"]/Call/Arg/New/#attribute/class org.eclipse.jetty.server.ForwardedRequestCustomizer',
    ],
    onlyif  => 'match Configure/New[#attribute/id = "httpConfig"] size == 0',
    require => File[$exist_home],
    notify  => Service[$exist_service],
  }
}
