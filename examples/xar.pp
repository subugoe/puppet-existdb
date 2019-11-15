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
class  {'::existdb': }

existdb::xar
{ 'tesfile.xar' :
  xar_name   => 'testfile.xar',
  xar_source => 'https://ci.de.dariah.eu/exist-repo/public/eXide-2.4.6.xar',
}
