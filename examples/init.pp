# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppet.com/guides/tests_smoke.html
#

class
{ '::existdb' :
  exist_user                  => test,
  exist_group                 => test,
  exist_home                  => '/opt/test',
  exist_service               => test,
  exist_data                  => '/var/lib/textgrid',
  exist_cache_size            => '128M',
  exist_collection_cache_size => '24M',
  exist_revision              => 'eXist-5.0.0',
  exist_version               => '5.0.0',
  java_home                   => '/usr/lib/jvm/jre',
  running                     => running,
}
