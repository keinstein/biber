use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 7;

use Biber;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata") ;

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('set-dynamic.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);

# Now generate the information
$biber->prepare;
my $section0 = $biber->sections->get_section(0);
my $section1 = $biber->sections->get_section(1);
my $out = $biber->get_output_obj;

my $string1 = q|  \entry{DynSet}{set}{}
    \set{Dynamic1,Dynamic2,Dynamic3}
    \name{labelname}{1}{%
      {{Dynamism}{D.}{Derek}{D.}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Dynamism}{D.}{Derek}{D.}{}{}{}{}}%
    }
    \strng{namehash}{DD1}
    \strng{fullhash}{DD1}
    \field{sortinit}{0}
    \field{labelyear}{2002}
    \field{annotation}{Some Dynamic Note}
    \field{shorthand}{d1}
    \field{title}{Doing Daring Deeds}
    \field{year}{2002}
  \endentry

|;

my $string2 = q|  \entry{Dynamic1}{book}{}
    \inset{DynSet}
    \name{labelname}{1}{%
      {{Dynamism}{D.}{Derek}{D.}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Dynamism}{D.}{Derek}{D.}{}{}{}{}}%
    }
    \strng{namehash}{DD1}
    \strng{fullhash}{DD1}
    \field{sortinit}{0}
    \field{annotation}{Some Dynamic Note}
    \field{shorthand}{d1}
    \field{title}{Doing Daring Deeds}
    \field{year}{2002}
  \endentry

|;

my $string3 = q|  \entry{Dynamic2}{book}{}
    \inset{DynSet}
    \name{labelname}{1}{%
      {{Bunting}{B.}{Brian}{B.}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Bunting}{B.}{Brian}{B.}{}{}{}{}}%
    }
    \strng{namehash}{BB1}
    \strng{fullhash}{BB1}
    \field{sortinit}{0}
    \field{shorthand}{d2}
    \field{title}{Beautiful Birthdays}
    \field{year}{2010}
  \endentry

|;

my $string4 = q|  \entry{Dynamic3}{book}{}
    \inset{DynSet}
    \name{labelname}{1}{%
      {{Regardless}{R.}{Roger}{R.}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Regardless}{R.}{Roger}{R.}{}{}{}{}}%
    }
    \strng{namehash}{RR1}
    \strng{fullhash}{RR1}
    \field{sortinit}{0}
    \field{shorthand}{d3}
    \field{title}{Reckless Ravishings}
    \field{year}{2000}
  \endentry

|;

# Labelyear is now here as skiplab is not set for this entry when cited in section
# without citation of a set it is a member of
my $string5 = q|  \entry{Dynamic3}{book}{}
    \name{labelname}{1}{%
      {{Regardless}{R.}{Roger}{R.}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Regardless}{R.}{Roger}{R.}{}{}{}{}}%
    }
    \strng{namehash}{RR1}
    \strng{fullhash}{RR1}
    \field{sortinit}{0}
    \field{labelyear}{2000}
    \field{shorthand}{d3}
    \field{title}{Reckless Ravishings}
    \field{year}{2000}
  \endentry

|;

is($out->get_output_entry('DynSet'), $string1, 'Dynamic set test 1');
is($out->get_output_entry('Dynamic1'), $string2, 'Dynamic set test 2');
is($out->get_output_entry('Dynamic2'), $string3, 'Dynamic set test 3');
is($out->get_output_entry('Dynamic3'), $string4, 'Dynamic set test 4');
is($out->get_output_entry('Dynamic3', 1), $string5, 'Dynamic set test 5');
is_deeply([$section0->get_shorthands], ['DynSet'], 'Dynamic set skiplos 1');
is_deeply([$section1->get_shorthands], ['Dynamic3'], 'Dynamic set skiplos 2');

unlink "*.utf8";
