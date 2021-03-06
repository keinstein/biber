# -*- cperl -*-
use strict;
use warnings;
use utf8;
no warnings 'utf8' ;

use Test::More;
use Test::Differences;
unified_diff;

if ($ENV{BIBER_DEV_TESTS}) {
  plan tests => 3;
}
else {
  plan skip_all => 'BIBER_DEV_TESTS not set';
}

use Biber;
use Biber::Output::bbl;
use Log::Log4perl;
chdir("t/tdata") ;

# Set up Biber object
my $biber = Biber->new(noconf => 1);
my $LEVEL = 'ERROR';
my $l4pconf = qq|
    log4perl.category.main                             = $LEVEL, Screen
    log4perl.category.screen                           = $LEVEL, Screen
    log4perl.appender.Screen                           = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.utf8                      = 1
    log4perl.appender.Screen.Threshold                 = $LEVEL
    log4perl.appender.Screen.stderr                    = 0
    log4perl.appender.Screen.layout                    = Log::Log4perl::Layout::SimpleLayout
|;
Log::Log4perl->init(\$l4pconf);

$biber->parse_ctrlfile('remote-files.bcf');
$biber->set_output_obj(Biber::Output::bbl->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('sortlocale', 'en_GB.UTF-8');
Biber::Config->setoption('quiet', 1);
Biber::Config->setoption('nodieonerror', 1); # because the remote bibs might be messy

# Now generate the information
$biber->prepare;
my $out = $biber->get_output_obj;
my $section = $biber->sections->get_section(0);
my $main = $biber->datalists->get_list('nty/global//global/global');
my $bibentries = $section->bibentries;

my $cu1 = q|    \entry{citeulike:8283461}{article}{}
      \name{author}{4}{}{%
        {{uniquename=0,uniquepart=base,hash=45569c08e4409a489ea0089b05700737}{%
           family={Marazziti},
           familyi={M\bibinitperiod},
           given={D.},
           giveni={D\bibinitperiod},
           givenun=0}}%
        {{uniquename=0,uniquepart=base,hash=64c5a832511e0dd6aecf02f2d598b4e4}{%
           family={Akiskal},
           familyi={A\\bibinitperiod},
           given={H.\bibnamedelimi S.},
           giveni={H\bibinitperiod\bibinitdelim S\bibinitperiod},
           givenun=0}}%
        {{uniquename=0,uniquepart=base,hash=161a28db2496421f437aa4390748e14d}{%
           family={Rossi},
           familyi={R\bibinitperiod},
           given={A.},
           giveni={A\bibinitperiod},
           givenun=0}}%
        {{uniquename=0,uniquepart=base,hash=a586782bf328ff75bf4f3120e1f5787d}{%
           family={Cassano},
           familyi={C\bibinitperiod},
           given={G.\bibnamedelimi B.},
           giveni={G\bibinitperiod\bibinitdelim B\bibinitperiod},
           givenun=0}}%
      }
      \strng{namehash}{a700cc0bdce78f5a1f50ff6314ff6f2a}
      \strng{fullhash}{094b095bbb7ac93fdd3e2eafdcec0cac}
      \strng{bibnamehash}{a700cc0bdce78f5a1f50ff6314ff6f2a}
      \strng{authorbibnamehash}{a700cc0bdce78f5a1f50ff6314ff6f2a}
      \strng{authornamehash}{a700cc0bdce78f5a1f50ff6314ff6f2a}
      \strng{authorfullhash}{094b095bbb7ac93fdd3e2eafdcec0cac}
      \field{sortinit}{M}
      \field{sortinithash}{cfd219b90152c06204fab207bc6c7cab}
      \field{extradatescope}{labelyear}
      \field{labeldatesource}{year}
      \field{labelnamesource}{author}
      \field{labeltitlesource}{title}
      \field{abstract}{{BACKGROUND}: The evolutionary consequences of love are so important that there must be some long-established biological process regulating it. Recent findings suggest that the serotonin ({5-HT}) transporter might be linked to both neuroticism and sexual behaviour as well as to obsessive-compulsive disorder ({OCD}). The similarities between an overvalued idea, such as that typical of subjects in the early phase of a love relationship, and obsession, prompted us to explore the possibility that the two conditions might share alterations at the level of the {5-HT} transporter. {METHODS}: Twenty subjects who had recently (within the previous 6 months) fallen in love, 20 unmedicated {OCD} patients and 20 normal controls, were included in the study. The {5-HT} transporter was evaluated with the specific binding of {3H}-paroxetine ({3H}-Par) to platelet membranes. {RESULTS}: The results showed that the density of {3H}-Par binding sites was significantly lower in subjects who had recently fallen in love and in {OCD} patients than in controls. {DISCUSSION}: The main finding of the present study is that subjects who were in the early romantic phase of a love relationship were not different from {OCD} patients in terms of the density of the platelet {5-HT} transporter, which proved to be significantly lower than in the normal controls. This would suggest common neurochemical changes involving the {5-HT} system, linked to psychological dimensions shared by the two conditions, perhaps at an ideational level.}
      \field{issn}{0033-2917}
      \field{journaltitle}{Psychological medicine}
      \field{month}{5}
      \field{number}{3}
      \field{title}{Alteration of the platelet serotonin transporter in romantic love.}
      \field{volume}{29}
      \field{year}{1999}
      \field{pages}{741\bibrangedash 745}
      \range{pages}{5}
      \verb{urlraw}
      \verb http://www.biomedexperts.com/Abstract.bme/10405096
      \endverb
      \verb{url}
      \verb http://www.biomedexperts.com/Abstract.bme/10405096
      \endverb
      \keyw{love,romantic}
    \endentry
|;

my $dl1 = q|    \entry{AbdelbarH98}{article}{}
      \name{author}{2}{}{%
        {{uniquename=0,uniquepart=base,hash=03fb065ad674e2c6269f3542112e30df}{%
           family={Abdelbar},
           familyi={A\bibinitperiod},
           given={A.M.},
           giveni={A\bibinitperiod},
           givenun=0}}%
        {{uniquename=0,uniquepart=base,hash=6ad6790ec94c4b5195bcac153b20da0e}{%
           family={Hedetniemi},
           familyi={H\bibinitperiod},
           given={S.M.},
           giveni={S\bibinitperiod},
           givenun=0}}%
      }
      \strng{namehash}{bb887c5d0458bfb1f3f7e6afc8d1def4}
      \strng{fullhash}{bb887c5d0458bfb1f3f7e6afc8d1def4}
      \strng{bibnamehash}{bb887c5d0458bfb1f3f7e6afc8d1def4}
      \strng{authorbibnamehash}{bb887c5d0458bfb1f3f7e6afc8d1def4}
      \strng{authornamehash}{bb887c5d0458bfb1f3f7e6afc8d1def4}
      \strng{authorfullhash}{bb887c5d0458bfb1f3f7e6afc8d1def4}
      \field{sortinit}{A}
      \field{sortinithash}{d77c7cdd82ff690d4c3ef13216f92f0b}
      \field{extradatescope}{labelyear}
      \field{labeldatesource}{year}
      \field{labelnamesource}{author}
      \field{labeltitlesource}{title}
      \field{journaltitle}{Artificial Intelligence}
      \field{title}{Approximating {MAP}s for belief networks is {NP}-hard and other theorems}
      \field{volume}{102}
      \field{year}{1998}
      \field{pages}{21\bibrangedash 38}
      \range{pages}{18}
    \endentry
|;

my $ssl = q|    \entry{merleau-ponty_philosophe_2010}{incollection}{}
      \name{author}{1}{}{%
        {{uniquename=0,uniquepart=base,hash=83d062f99d033839537243075d75bad2}{%
           family={Merleau-Ponty},
           familyi={M\bibinithyphendelim P\bibinitperiod},
           given={Maurice},
           giveni={M\bibinitperiod},
           givenun=0}}%
      }
      \name{editor}{1}{}{%
        {{hash=ff5f90046157eecef0c22da4dac6486e}{%
           family={Lefort},
           familyi={L\bibinitperiod},
           given={Claude},
           giveni={C\bibinitperiod}}}%
      }
      \list{language}{1}{%
        {Fransk}%
      }
      \list{location}{1}{%
        {Paris}%
      }
      \list{publisher}{1}{%
        {Éditions Gallimard}%
      }
      \strng{namehash}{83d062f99d033839537243075d75bad2}
      \strng{fullhash}{83d062f99d033839537243075d75bad2}
      \strng{bibnamehash}{83d062f99d033839537243075d75bad2}
      \strng{authorbibnamehash}{83d062f99d033839537243075d75bad2}
      \strng{authornamehash}{83d062f99d033839537243075d75bad2}
      \strng{authorfullhash}{83d062f99d033839537243075d75bad2}
      \strng{editorbibnamehash}{ff5f90046157eecef0c22da4dac6486e}
      \strng{editornamehash}{ff5f90046157eecef0c22da4dac6486e}
      \strng{editorfullhash}{ff5f90046157eecef0c22da4dac6486e}
      \field{sortinit}{M}
      \field{sortinithash}{cfd219b90152c06204fab207bc6c7cab}
      \field{extradatescope}{labelyear}
      \field{labeldatesource}{year}
      \field{labelnamesource}{author}
      \field{labeltitlesource}{title}
      \field{booktitle}{Œuvres}
      \field{title}{Le philosophe et son ombre}
      \field{year}{2010}
      \field{pages}{1267\bibrangedash 1289}
      \range{pages}{23}
      \keyw{Husserl,Edmund,autrui,chair,constitution,intercorporéité,l'impensé,ouverture}
    \endentry
|;


eq_or_diff( $out->get_output_entry('citeulike:8283461', $main), $cu1, 'Fetch from citeulike') ;
eq_or_diff( $out->get_output_entry('AbdelbarH98', $main), $dl1, 'Fetch from plain bib download') ;
eq_or_diff( $out->get_output_entry('merleau-ponty_philosophe_2010', $main), $ssl, 'HTTPS test') ;
