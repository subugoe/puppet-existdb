# @summary Manage deployment of XAR files.
#
# @param catalina_base
#   Specifies the base directory of the Tomcat installation. Valid options: a string containing an absolute path.
# @param app_base
#   Specifies where to deploy the XAR. Cannot be used in combination with `deployment_path`. Valid options: a string containing a path relative to `$EXIST_HOME`. `app_base`, Puppet deploys the XAR to your specified `deployment_path`. If you don't specify that either, the XAR deploys to `${exist_home}/autodeploy`.
# @param deployment_path
#   Specifies where to deploy the XAR. Cannot be used in combination with `app_base`. Valid options: a string containing an absolute path. `deployment_path`, Puppet deploys the XAR to your specified `app_base`. If you don't specify that either, the XAR deploys to `${exist_home}/autodeploy`.
# @param xar_ensure
#   Specifies whether the XAR should exist.
# @param xar_name
#   Specifies the name of the XAR. Valid options: a string containing a filename that ends in '.xar'. `name` passed in your defined type.
# @param xar_purge
#   Specifies whether to purge the exploded XAR directory. Only applicable when `xar_ensure` is set to 'absent' or `false`.
# @param xar_source
#    Specifies the source to deploy the XAR from. Valid options: a string containing a `puppet://`, `http(s)://`, or `ftp://` URL.
# @param allow_insecure
#   Specifies if HTTPS errors should be ignored when downloading the xar tarball.
# @param user
#   The 'owner' of the existdb xar file.
# @param group
#   The 'group' owner of the existdb xar file.
#
define existdb::xar
(
  $exist_home                          = '/usr/local/existdb',
  $app_base                            = undef,
  $deployment_path                     = undef,
  Enum['present','absent'] $xar_ensure = 'present',
  $xar_name                            = undef,
  Boolean $xar_purge                   = true,
  $xar_source                          = undef,
  Boolean $allow_insecure              = false,
  $user                                = 'existdb',
  $group                               = 'existdb',
)
{
  if $app_base and $deployment_path
  {
    fail('Only one of $app_base and $deployment_path can be specified.')
  }

  if $xar_name { $_xar_name = $xar_name }
  else { $_xar_name = $name }

  if $_xar_name !~ /\.xar$/
  {
    fail('xar_name must end with .xar')
  }

  if $deployment_path { $_deployment_path = $deployment_path }
  else
  {
    if $app_base { $_app_base = $app_base }
    else { $_app_base = 'autodeploy' }
    $_deployment_path = "${exist_home}/${_app_base}"
  }

  if $xar_ensure == 'absent'
  {
    file
    { "${_deployment_path}/${_xar_name}" :
      ensure => absent,
      force  => false,
    }
    if $xar_purge
    {
      $xar_dir_name = regsubst($_xar_name, '\.xar$', '')
      if $xar_dir_name != ''
      {
        file
        { "${_deployment_path}/${xar_dir_name}" :
          ensure => absent,
          force  => true,
        }
      }
    }
  }
  else
  {
    if ! $xar_source
    {
      fail('$xar_source must be specified if you aren\'t removing the XAR')
    }
    archive
    { "existdb::xar ${name}" :
      extract        => false,
      source         => $xar_source,
      path           => "${_deployment_path}/${_xar_name}",
      allow_insecure => $allow_insecure,
    }
    file
    { "existdb::xar ${name}" :
      ensure    => file,
      path      => "${_deployment_path}/${_xar_name}",
      owner     => $user,
      group     => $group,
      mode      => '0640',
      subscribe => Archive["existdb::xar ${name}"],
    }
  }
}
