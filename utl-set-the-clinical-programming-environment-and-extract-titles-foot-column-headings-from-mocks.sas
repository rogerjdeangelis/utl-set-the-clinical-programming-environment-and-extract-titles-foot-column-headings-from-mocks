%let pgm=utl-set-the-clinical-programming-environment-and-extract-titles-foot-column-headings-from-mocks;

%let pgm=utl-set-the-clinical-programming-environment-and-extract-titles-foot-column-headings-from-mocks;

Set the clinical programming environment and extract titles foot column headings from mocks

This is under development

/****************************************************************************************************************************/
/*                                                                                                                          */
/* Study token=abc                                                                                                          */
/*                                                                                                                          */
/* PROGRAM:                 abc_000Init.sas                                                                                 */
/* PROGRAM PATH:            d:/abc/oto/   (production AWS:/abc)                                                             */
/*                                                                                                                          */
/* PURPOSE:                 Create Programming Enviromment for ABC-217 Trial mRNAGen Incorporated                           */
/*                                                                                                                          */
/* TRIAL:                   ABC-217                                                                                         */
/*                                                                                                                          */
/* DEVELOPMENT SOFTWARE;    Development: local 64bit Win 10 Pro Workstation SAS 9\4M7 64bit R4.12 64\32bit  Python 3.10.2   */
/* PRODUCTION SOFTWARE;     Production 64bit Windows Server SAS 9\4M7 64bit (R and Python not meeded)                       */
/*                                                                                                                          */
/* PROGRAMMER:              RogerJDeAngelis@gmail.com                                                                       */
/*                                                                                                                          */
/* VERSIONING:              d;\abc\ver (production AWS:\abc\ver)                                                            */
/*                                                                                                                          */
/* REQUESTOR:               mRNAGen Pharmaceiticals Inc                                                                     */
/*                                                                                                                          */
/* AUTOCALL MACRO LIBRARY:  d:abc\oto   (production AWS:\abc\oto)                                                           */
/*                                                                                                                          */
/* VALIDATED:               YES                                                                                             */
/*                                                                                                                          */
/* RISK LEVEL:              High                                                                                            */
/*                                                                                                                          */
/* VALIDATION PGM:          d:\abc\sas\abs_000initV.sas (production AWS:\abc)                                               */
/*                                                                                                                          */
/* DEVELOPMENT PATH:        d:\abc                                                                                          */
/* PRODUCTION PATH :        AWS:\abc (development version is MOVED to production-only one environment is active at any time)*/
/*                                                                                                                          */
/* MOCKS;                   d:\doc\abc_moc.docx  (production AWS:\abc)                                                      */
/*                                                                                                                          */
/* ISSUE LOG:               d:\abc\xls\abc_050Ldsp.xlsx (production AWS:\abc)                                               */
/*                                                                                                                          */
/* DEPENDENCIES:            The Curent working Directory must be either development d:/abc or production AWS:/abc           */
/*                          See sample inputs below used to produce Subject Dispsition Listing with this init               */
/*                                                                                                                          */
/* VALIDATION:              Done by John Smith johnSmith@mRNAGen.com                                                        */
/*                          All standard macros go through this testing                                                     */
/*                          User Requirements                                                                               */
/*                          Funntional Requirements                                                                         */
/*                          Unit Test Plans                                                                                 */
/*                          Configuration Management Requirements                                                           */
/*                          Unit Test Plans and Test Cases                                                                  */
/*                          can be found in                                                                                 */
/*                             d\abc\pdf\abc_000init_validation.pdf (production AWS:\abc\pdf\abc_000init_validation.pdf)    */
/*                                                                                                                          */
/* R PACKAGES:              tm pdftools (these tools parse the mocks and are not used in production)                        */
/*                                                                                                                          */
/* EXTERNAL MACROS:         %utlnopts, %utlopts, %stop_submission, %utl_curDir, %array, %do_over %utl_submit_r64            */
/*                          %utl_submit_ps64 %arraydelete                                                                   */
/*                                                                                                                          */
/* INTERNAL MACROS:         %abc_000init                                                                                    */
/*                                                                                                                          */
/****************************************************************************************************************************/
/*                                                                              _               _                           */
/*   _                   _      _ __  _ __ ___   ___ ___  ___ ___    ___  _   _| |_ _ __  _   _| |_                         */
/*  (_)_ __  _ __  _   _| |_   | `_ \| `__/ _ \ / __/ _ \/ __/ __|  / _ \| | | | __| `_ \| | | | __|                        */
/*  | | `_ \| `_ \| | | | __|  | |_) | | | (_) | (_|  __/\__ \__ \ | (_) | |_| | |_| |_) | |_| | |_                         */
/*  | | | | | |_) | |_| | |_   | .__/|_|  \___/ \___\___||___/___/  \___/ \__,_|\__| .__/ \__,_|\__|                        */
/*  |_|_| |_| .__/ \__,_|\__|  |_|                                                 |_|                                      */
/*          |_|                                                                                                             */
/*                                                                                                                          */
/* ROOT = d:/abc (production AWS:/abc)                                                                                      */
/*                                                                                                                          */
/* Minimal setup to demonstrate using  abc_00init.sas along with abc_050Ldsp.sas to create the disposition listing          */
/*                                                                                                                          */
/* You need to manually create                                                                                              */
/* these folders and populate them for an intial run                                                                        */
/*                                                                                                                          */
/*                                                                                                                          */
/*  .\sas  <-------------.                   .--->  .\log                                                                   */
/*   |                    \                 /        |                                                                      */
/*   \ abc_050Ldsp.sas     \               /         \ abc_050Ldsp.log                                                      */
/*                          \             /                                                                                 */
/*  .\adam <-------------.   \  _____    / .---->.\rtf                                                                      */
/*   \ adsl.sas7bdat      \   /       \ / /          |                                                                      */
/*                         \ |         | /           \ adc_050Ldsp.rtf                                                      */
/*                          -| PROCESS |/                                                                                   */
/*  .\oto  <-----------<-----|         |--------> First time you run sbc_000init it will create these folders               */
/*     abc000init.sas         \_______ /                                                                                    */
/*                            /                    .\b64   -->  Base 64 encoding for binary exports                         */
/*            .\doc   <-----./                     .\cdm   -->  Common Data Model All meta data Question Answer             */
/*              |                                  .\csv   -->  Delimiited files csv, pipe, tab delimited                   */
/*              \abc_mocks.docx                    .\fmt   -->  Formats                                                     */
/*                                                    \abcFmt.sas7bcat                                                      */
/*                                                 .\lst   -->  Lists                                                       */
/*                                                 .\pdf   -->  SAP Protocol final CSR                                      */
/*                                                 .\png   -->  Graphic Output                                              */
/*                                                 .\raw   -->  Raw data from client                                        */
/*                                                 .\rtf   -->  RTf reports                                                 */
/*                                                 .\sd1   -->  Intermediate backing tables for tables, listing and graphs  */
/*                                                 .\sdm   -->  SDTM tables                                                 */
/*                                                 .\txt   -->  Related text files                                          */
/*                                                 .\usr   -->  SAS profile SAS user libary                                 */
/*                                                 .\xls   -->  All excel Files, Issue log, specs drives all processing     */
/*                                                 .\xml   -->  Define XML                                                  */
/*                                                 .\xpt   -->  SAS V5 transport files                                      */
/*                                                 .\zip   -->  Zip files                                                   */
/*                                                                                                                          */
/* KEY PRINT OUTPUT WHEN ARGUMENT META=1                                                                                    */
/*                                                                                                                          */
/* This init program can parse the mock listings for titles, footnotes and columnm headings.                                */
/* The meta data appears in the output window and can easily be cut and pasted in to table, listing or report program.      */
/* Frequently this meta data can be used for arguments to standard macros.                                                  */
/*                                                                                                                          */
/* Here is an example of what th output window might look like.                                                             */
/*                    _   _     _                      _                                                                    */
/*   _   _ ___  ___  | |_| |__ (_)___   _ __ ___   ___| |_ __ _                                                             */
/*  | | | / __|/ _ \ | __| `_ \| / __| | `_ ` _ \ / _ \ __/ _` |                                                            */
/*  | |_| \__ \  __/ | |_| | | | \__ \ | | | | | |  __/ || (_| |                                                            */
/*   \__,_|___/\___|  \__|_| |_|_|___/ |_| |_| |_|\___|\__\__,_|                                                            */
/*              _                     _                   _                                                                 */
/*    ___ _   _| |_    __ _ _ __   __| |  _ __   __ _ ___| |_ ___                                                           */
/*   / __| | | | __|  / _` | `_ \ / _` | | `_ \ / _` / __| __/ _ \                                                          */
/*  | (__| |_| | |_  | (_| | | | | (_| | | |_) | (_| \__ \ ||  __/                                                          */
/*   \___|\__,_|\__|  \__,_|_| |_|\__,_| | .__/ \__,_|___/\__\___|                                                          */
/*                                       |_|                                                                                */
/* abc_050Ldsp Protocol: ABC Pharmaceuticals                                                               Page 1 of n      */
/* abc_050Ldsp Population: All Subjects                                                                                     */
/* abc_050Ldsp Template 1                                                                                                   */
/* abc_050Ldsp Summary of Populations[1]                                                                                    */
/* abc_050Ldsp Xanomeline      Xanomeline                                                                                   */
/* abc_050Ldsp                            Placebo       Low Dose        High Dose        Total                              */
/* abc_050Ldsp Population                 (N=xxx)        (N=xxx)         (N=xxx)        (N=xxx)                             */
/* abc_050Ldsp Intent-To-Treat (ITT)     xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                            */
/* abc_050Ldsp Safety                    xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                            */
/* abc_050Ldsp Efficacy                  xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                            */
/* abc_050Ldsp Completer Week 24         xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                            */
/* abc_050Ldsp Complete Study            xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                            */
/* abc_050Ldsp [1] Phase I Intravenous Infusion                                                                             */
/* abc_050Ldsp NOTE: N in column headers represents number of subjects the in study (i.e., signed informed consent). The    */
/* abc_050Ldsp ITT population includes all subjects randomized. The Safety population includes all randomized subjects      */
/* abc_050Ldsp to have taken at least one dose of the study drug. The Efficacy population includes all subjects in the      */
/* abc_050Ldsp safety population who also have at least one post-baseline ADAS-Cog and CIBIC+ assessment.                   */
/* abc_050Ldsp Source: p:/abc/abc_050Ldsp.sas                                                 21:05 Monday, June 26, 2006   */
/*                  _                                                                                                       */
/*    ___ _ __   __| |                                                                                                      */
/*   / _ \ `_ \ / _` |                                                                                                      */
/*  |  __/ | | | (_| |                                                                                                      */
/*   \___|_| |_|\__,_|                                                                                                      */
/*                                                                                                                          */
/*                                                                                                                          */
/**************************************************************************************************************************/*/
/*                                                __ _                                                                      */
/*   _ __  _ __ ___   __ _ _ __ __ _ _ __ ___    / _| | _____      __                                                       */
/*  | `_ \| `__/ _ \ / _` | `__/ _` | `_ ` _ \  | |_| |/ _ \ \ /\ / /                                                       */
/*  | |_) | | | (_) | (_| | | | (_| | | | | | | |  _| | (_) \ V  V /                                                        */
/*  | .__/|_|  \___/ \__, |_|  \__,_|_| |_| |_| |_| |_|\___/ \_/\_/                                                         */
/*  |_|              |___/                                                                                                  */
/*                                                                                                                          */
/*   1. call %abc_00init to set up environment                                                                              */
/*                                                                                                                          */
/*       Typical Arguments                                                                                                  */
/*                                                                                                                          */
/*         root         =d:/abc         --> either d:/abc for development or p:/abc for production                          */
/*         meta         =0              --> set to 1 to  parse mock for meta data                                           */
/*         program      =abc_050Ldsp    --> must match the souce program in the mock. Must have prefix abc                  */
/*                                                                                                                          */
/*         program_type =l              --> sets up the correct enviornment for listings tables graphs sdtm                 */
/*                                      --> l=list,rtf t=table.rtf g=graph.png s=sdtm a=adam                                */
/*         user_macros  =0              --> 0 to turn off user macro library                                                */
/*         debug        =1              --> set to 0 for production                                                         */
/*         mocks        =d:\abc\doc\abc_mocks.docx  --> location of mocks ' /                                               */
/*                                                                                                                          */
/*   2. Declare global RTF symbols ie   <= >=                                                                               */
/*                                                                                                                          */
/*   3. Check working directory. Is it development d:\abc or production AWS:\abc                                            */
/*      If niether then abort                                                                                               */
/*                                                                                                                          */
/*   4, Set autocall macro library  d:\abc\oto or production AWS:\abc\oto                                                   */
/*      If niether then abort                                                                                               */
/*                                                                                                                          */
/*   5. Echo and check macro arguments if any argument is incorrect the                                                     */
/*      Echo example values, echo supplied arguments and truth table showin the incorrect arguments                         */
/*                                                                                                                          */
/*   6. Create all the folders that will be neded for the entire CSR                                                        */
/*                                                                                                                          */
/*   7. Assign filenames based on the whether the program is a table, listing, graph, ADaM or SDTM                          */
/*      Note readonly is specified when the program does not output to that folder                                          */
/*                                                                                                                          */
/*   8. Prep for mock parsing parsing by converting the mocks to a pdf.                                                     */
/*                                                                                                                          */
/*   8. Convert the pdf to text and select just the mock lines with usefull meta data.                                      */
/*                                                                                                                          */
/*  10. Add dimesion variable program name to each record in the mocks.                                                     */
/*      This allows us to display just the mock of interest                                                                 */
/*                                                                                                                          */
/*                                                                                                                          */
/************************************************************************************************************************** */
/*                                                                                                                          */
/* VERSION HISTORY                                                                                                          */
/*                                                                                                                          */
/*   Programmer                            Date              Description of Changes                                         */
/*                                                                                                                          */
/*   roger.deangelis@westat.com           2022/05/28         Creation                                                       */
/*                                                                                                                          */
/****************************************************************************************************************************/
;;;;

%macro abc_000Init(
     meta         =0           /* set to 1 to  parse mock for meta data - only if mock changed    */
    ,program      =abc_050LDsp.sas /* must match the souce program in the mock. Must have prefix abc  */
    ,program_type =l           /* sets up the correct enviornment for listings tables graphs sdtm */
                               /* l=list,rtf t=table.rtf g=graph.png s=sdtm a=adam                */
    ,debug        =1           /* set to 0 for production                                         */
    ,mocks        =d:\abc\doc\abc_mocks.docx                                 /* location of mocks */
    );

    /*--
         Only set getMeta to 1 if mocs have changed.
         If getmeta=1 then the init macro wil parse the mock listing and
         print out all the meta data need for macro arguments
         title statements
         column headers
         footnotes
         notes

         You will only need to update program meta data when mocs change

    --*/

    %global
         ods_ul      /* RTF sequence for cell underline             */
         ods_space   /* RTF sequence for single blank space         */
         ods_le      /* RTF character for less than or equal to     */
         ods_ne      /* RTF character for not equal to              */
         ods_mu      /* RTF character for Greek mu                  */
         ods_ge      /* RTF character for greater than or equal to  */
         ods_dg      /* RTF character for degree C                  */
    ;

    /*-- Immediately set SASAUTOS --*/

       /* to check without macro just execute this code and the datastep delow

       x "cd d:\abc";

       %let meta            = 0;
       %let program         = abc_050Ldsp;
       %let program_type    = g;
       %let user_macros     = 1;
       %let debug           = 1;
       %let mocks           = d:\abc\doc\abc_mocks.docx;

       */

/*                  _    _                __       _     _
__      _____  _ __| | _(_)_ __   __ _   / _| ___ | | __| | ___ _ __
\ \ /\ / / _ \| `__| |/ / | `_ \ / _` | | |_ / _ \| |/ _` |/ _ \ `__|
 \ V  V / (_) | |  |   <| | | | | (_| | |  _| (_) | | (_| |  __/ |
  \_/\_/ \___/|_|  |_|\_\_|_| |_|\__, | |_|  \___/|_|\__,_|\___|_|
                                 |___/
*/
    data _null_;

       length curDir $255;

       rc     = filename("fr",".");
       curdir = pathname("fr");
       rc     = filename("fr");

       putlog curdir=;

       if upcase(curDir) not in ( "D:\ABC", "AWS:\ABC") then do;
              putlog " " //;
              putlog "Current Working Directory no d:\abc or AWS:\abc" //;
              call execute ('%stop_submission');
       end;

       /*--                              _ _ _
        _ __ ___   __ _  ___ _ __ ___   | (_) |__  _ __ __ _ _ __ _   _
       | `_ ` _ \ / _` |/ __| `__/ _ \  | | | `_ \| `__/ _` | `__| | | |
       | | | | | | (_| | (__| | | (_) | | | | |_) | | | (_| | |  | |_| |
       |_| |_| |_|\__,_|\___|_|  \___/  |_|_|_.__/|_|  \__,_|_|   \__, |
                                                                  |___/
       --*/

       select (upcase(curDir));

          when ("D:\ABC")
             call execute(
                 "options sasautos=
                 (
                 'C:\Program Files\SASHome\SASFoundation\9.4\core\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\aacomp\sasmacro'
                 'C:\ProgramFiles\SASHome\SASFoundation\9.4\accelmva\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\dmscore\sasmacro'
                 'C:\ProgramFiles\SASHome\SASFoundation\9.4\graph\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\hps\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\mlearning\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\stat\sasmacro'
                 'd:/abc/oto'
                 );");
          when ("QWS:\ABC")
              call execute(
                 "options sasautos=
                 (
                 'C:\Program Files\SASHome\SASFoundation\9.4\core\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\aacomp\sasmacro'
                 'C:\ProgramFiles\SASHome\SASFoundation\9.4\accelmva\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\dmscore\sasmacro'
                 'C:\ProgramFiles\SASHome\SASFoundation\9.4\graph\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\hps\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\mlearning\sasmacro'
                 'C:\Program Files\SASHome\SASFoundation\9.4\stat\sasmacro'
                 'AWS:/abc/oto'
                 );");
          otherwise do;
              putlog "Cannot set sasautos autocall library does not exist";
              call execute ('%stop_submission');
          end;
       end;
    run;quit;
/*    _     _
  ___| |__ | | __  _ __ ___   __ _  ___ _ __ ___     __ _ _ __ __ _ ___
 / __| `_ \| |/ / | `_ ` _ \ / _` |/ __| `__/ _ \   / _` | `__/ _` / __|
| (__| | | |   <  | | | | | | (_| | (__| | | (_) | | (_| | | | (_| \__ \
 \___|_| |_|_|\_\ |_| |_| |_|\__,_|\___|_|  \___/   \__,_|_|  \__, |___/
                                                              |___/
*/

    %utlnopts;

    data abc_000InitArgs;

         length
              program_type_arg $1
              program_arg      $32
              mocks_arg        $96
         ;

         retain
              meta_arg          &meta
              program_arg      "&program"
              debug_arg         &debug
              program_type_arg "&program_type"
              mocks_arg        "&mocks"
         ;

         /*-- show the macro arguments in the log --*/
         putlog     "Macro abc_000Init arguments" /;
         putlog (_all_) (= $ /);
         putlog ' ' //;

         if meta_arg in (0,1) then meta_arg=1;
         else do;
              meta_arg=0;
              putlog "--> Please supply 1 or 0 to parse or not parse the assciated mock table <--";
         end;

         if debug_arg in (0,1) then debug_arg=1;
         else do;
              debug_arg=0;
              putlog "--> Please supply 1 or 0 to turn debug options on or off respectively <--";
         end;

         if upcase(program_type_arg) in ("L","T","G","S","A")  then  program_type_arg='1';
         else do;
              program_type_arg='0';
              putlog "--> Please supply a program type of L T G S or A for listing table graph sdtm or adam  <--";
         end;

         if upcase(program_arg) =: "ABC"  then  program_arg='1';
         else do;
              program_arg='0';
              putlog "--> Please supply a program that begins with the prefix abc <--";
         end;

         /* check that mock exists */

         if fileexist(mocks_arg)  then mocks_arg='1';
         else do;
             mocks_arg='0';
             putlog "--> " mocks_arg " do not exist  <--";
         end;

         errsum = sum(
             meta_arg
            ,input(program_arg,2.)
            ,debug_arg
            ,input(program_type_arg,2.)
            ,input(mocks_arg,2.)
            ,0
         );


         call symputx("_errsum",put(errsum,2.));

         /*-- Show an example call if user is having an issue  --*/
         if errsum ne 5 then do;
             put /
               '  Example call                                                                                            ' //
               '    %abc_000Init(                                                                                         ' /
               '                                      --> you must have defaults set                                      ' /
               '        ,meta         =0              --> set to 1 to  parse mock for meta data                           ' /
               '        ,program      =abc_050Ldsp    --> must match the souce program in the mock. Must have prefix abc  ' /
               '        ,program_type =l              --> sets up the correct enviornment for listings tables graphs sdtm ' /
               '                                      --> l=list,rtf t=table.rtf g=graph.png s=sdtm a=adam                ' /
               '        ,debug        =1              --> set to 0 for production                                         ' /
               '        ,mocks        =d:\abc\doc\abc_mocks.docx  --> location of mocks ' /
               '    );' // ' ' /
            ;
         end;

         /*-- truth table for macro args all should be 1s --*/
         putlog     "Truth table for macro args  all should be ones" /;
         putlog (_all_) (= $ /);
         putlog ' ' //;

         /*-- gently stop interactively if call does not execute --*/
         if errsum ne 5 then call execute('%stop_submission');  /* stop all processing and abort */

       run;quit;

       %utlopts;

/*               _           __       _     _
 _ __ ___   __ _| | _____   / _| ___ | | __| | ___ _ __ ___
| `_ ` _ \ / _` | |/ / _ \ | |_ / _ \| |/ _` |/ _ \ `__/ __|
| | | | | | (_| |   <  __/ |  _| (_) | | (_| |  __/ |  \__ \
|_| |_| |_|\__,_|_|\_\___| |_|  \___/|_|\__,_|\___|_|  |___/

*/

       %let _curDir=%curDir;
       %utlnopts;

       /*-- create directories that do not exist alread --*/

       /*-- create macro array --*/
       %array(_dirs,values=adm b64 cdm csv doc fmt log lst oto pdf png raw rtf sd1 sas sdm txt usr xls xml xpt zip);

       data _null_;
            %do_over(_dirs,phrase=%str(
                 length root $200 dir $300;
                 root="&_curDir";
                 dir ="?";
                 rc=dcreate(dir,root);
                 putlog "Folder &_curDir/? created";
                 ));
       run;quit;

       /*-- delete macro array --*/
       %arraydelete(_dirs);
/*             _               _ _ _
  __ _ ___ ___(_) __ _ _ __   | (_) |__  _ __   __ _ _ __ ___   ___  ___
 / _` / __/ __| |/ _` | `_ \  | | | `_ \| `_ \ / _` | `_ ` _ \ / _ \/ __|
| (_| \__ \__ \ | (_| | | | | | | | |_) | | | | (_| | | | | | |  __/\__ \
 \__,_|___/___/_|\__, |_| |_| |_|_|_.__/|_| |_|\__,_|_| |_| |_|\___||___/
                 |___/
*/

       %put &=program_type;

       data _null_;

        select (upcase("&program_type"));

           when ( "L","G","T")  /* tables listings graphs */

               call execute('
                libname abcSd1 "&_curDir./sd1"                ; /* backing datasets */
                libname abcRaw "&_curDir./raw" access=readonly; /* RAW datasets  */
                libname abcSdm "&_curDir./sdm" access=readonly; /* SDTM datasets */
                libname abcAdm "&_curDir./adm" access=readonly; /* ADaM datasets */
                libname abcFmt "&_curDir./fmt" access=readonly; /* formats       */
                libname abcCdm "&_curDir./cdm" access=readonly; /* meta data     */
                ');

           when ("S")          /* SDTMS */

            call execute('
                libname abcSd1 "&_curDir./sd1"                ; /* backing datasets */
                libname abcRaw "&_curDir./raw" access=readonly; /* RAW datasets  */
                libname abcSdm "&_curDir./sdm"                ; /* SDTM datasets */
                libname abcAdm "&_curDir./adm" access=readonly; /* ADaM datasets */
                libname abcFmt "&_curDir./fmt"                ; /* formats       */
                libname abcCdm "&_curDir./cdm" access=readonly; /* meta data     */
                ');

           when ("A")           /* ADaM  */

            call execute('
                libname abcSd1 "&_curDir./sd1"                ; /* backing datasets */
                libname abcRaw "&_curDir./raw" access=readonly; /* RAW datasets  */
                libname abcSdm "&_curDir./sdm" access=readonly; /* SDTM datasets */
                libname abcAdm "&_curDir./adm"                ; /* ADaM datasets */
                libname abcFmt "&_curDir./fmt"                ; /* formats       */
                libname abcCdm "&_curDir./cdm" access=readonly; /* meta data     */
             ');

           otherwise putlog "No Libnames assigned";

        end;

       run;quit;

/*    _    __                       _           _
 _ __| |_ / _|  ___ _   _ _ __ ___ | |__   ___ | |___
| `__| __| |_  / __| | | | `_ ` _ \| `_ \ / _ \| / __|
| |  | |_|  _| \__ \ |_| | | | | | | |_) | (_) | \__ \
|_|   \__|_|   |___/\__, |_| |_| |_|_.__/ \___/|_|___/
                    |___/
*/
      %let ods_ul     = %str(^R/RTF'\brdrb\brdrs\brdrw19 '); /* RTF sequence for cell underline             */
      %let ods_space  = %str(^R/RTF'\~');                    /* RTF sequence for single blank space         */
      %let ods_le     = %str(^R/RTF'{\uc1\u8804\~}');        /* RTF character for less than or equal to     */
      %let ods_ne     = %str(^R/RTF'{\uc1\u8800\~}');        /* RTF character for not equal to              */
      %let ods_mu     = %str(^R/RTF'{\uc1\u956\~}') ;        /* RTF character for Greek mu                  */
      %let ods_ge     = %str(^R/RTF'{\uc1\u8805\~}');        /* RTF character for greater than or equal to  */
      %let ods_dg     = %str(^R/RTF'{\uc1\u176\~}') ;        /* RTF character for degree C                  */

/*__                            _
 / _| ___  _ __ _ __ ___   __ _| |_ ___
| |_ / _ \| `__| `_ ` _ \ / _` | __/ __|
|  _| (_) | |  | | | | | | (_| | |_\__ \
|_|  \___/|_|  |_| |_| |_|\__,_|\__|___/

*/
    options fmtsearch=( abcFmt.abcFmt work.formats );

/*                    _          _                    _  __
 _ __ ___   ___   ___| | _____  | |_ ___    _ __   __| |/ _|
| `_ ` _ \ / _ \ / __| |/ / __| | __/ _ \  | `_ \ / _` | |_
| | | | | | (_) | (__|   <\__ \ | || (_) | | |_) | (_| |  _|
|_| |_| |_|\___/ \___|_|\_\___/  \__\___/  | .__/ \__,_|_|
                                           |_|
*/

%utlfkil(d:/abc/pdf/abc_mocks.pdf); /* this is required replace option not specified */

%utl_submit_ps64("
$word_app = New-Object -ComObject Word.Application;
    $document = $word_app.Documents.Open('d:/abc/doc/abc_mocks.docx');
    $document.SaveAs([ref] 'd:/abc/pdf/abc_mocks.pdf', [ref] 17);
    $document.Close();
$word_app.Quit();
");

/*                    _                _  __   _          _        _
 _ __ ___   ___   ___| | __  _ __   __| |/ _| | |_ ___   | |___  _| |_
| `_ ` _ \ / _ \ / __| |/ / | `_ \ / _` | |_  | __/ _ \  | __\ \/ / __|
| | | | | | (_) | (__|   <  | |_) | (_| |  _| | || (_) | | |_ >  <| |_
|_| |_| |_|\___/ \___|_|\_\ | .__/ \__,_|_|    \__\___/   \__/_/\_\\__|
                            |_|
*/

%utlfkil(d:/abc/txt/abc_mocks.txt); /* this is required replace option not specified */

%utl_submit_r64("
library('tm');
library('pdftools');
file <- 'd:/abc/pdf/abc_mocks.pdf';
Rpdf <- readPDF(control = list(text = '-layout'));
corpus <- VCorpus(URISource(file),
      readerControl = list(reader = Rpdf));
want <- content(content(corpus)[[1]]);
write(want,file='d:/abc/txt/abc_mocks.txt');
");

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  d:/abc/txt/abc_mocks.txt                                                                                              */
/*                                                                                                                        */
/*  Protocol: ABC Pharmaceuticals                                                                          Page 1 of n    */
/*  Population: All Subjects                                                                                              */
/*                                                    Template 1                                                          */
/*                                             Summary of Populations[1]                                                  */
/*                                                           Xanomeline      Xanomeline                                   */
/*                                              Placebo       Low Dose        High Dose        Total                      */
/*                   Population                 (N=xxx)        (N=xxx)         (N=xxx)        (N=xxx)                     */
/*                   Intent-To-Treat (ITT)     xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                    */
/*                   Safety                    xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                    */
/*                   Efficacy                  xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                    */
/*                   Completer Week 24         xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                    */
/*                   Complete Study            xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                    */
/*  [1] Phase I Intravenous Infusion                                                                                      */
/*  NOTE: N in column headers represents number of subjects entered in study (i.e., signed informed consent). The         */
/*  ITT population includes all subjects randomized. The Safety population includes all randomized subjects known         */
/*  to have taken at least one dose of randomized study drug. The Efficacy population includes all subjects in the        */
/*  safety population who also have at least one post-baseline ADAS-Cog and CIBIC+ assessment.                            */
/*  Source: p:/abc/abc_050Ldsp.sas                                                          21:05 Monday, June 26, 2006   */
/*                                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

%utlfkil(d:/abc/txt/abc_mocksfix.txt);

/*-- get rid of problem characters ==*/
data abc_000initFix;
  length lyn $200;
  infile "d:/abc/txt/abc_mocks.txt";
  file   "d:/abc/txt/abc_mocksfix.txt";

  input;

    _infile_=compress(_infile_,,'c');   /* non printable chars */
   _infile_=compress(_infile_,'0A'x);
   _infile_=compress(_infile_,'0C'x);
   _infile_=compress(_infile_,'0D'x);
   _infile_=compress(_infile_,'00'x);
   _infile_=compress(_infile_,'09'x);
   _infile_=compress(_infile_,'—');

  if _infile_ ne "";
  lyn=put(_infile_,$char171.);
  put _infile_;
  putlog _infile_;
run;quit;

%utlfkil("d:/abc/txt/abc_mocks.txt");
%utlfkil("d:/abc/pdf/abc_mocks.pdf");

/**************************************************************************************************************************/
/*                                                                                                                        */
/* Up to 40 obs WORK.ABC_000INITFIX total obs=140 30MAY2022:19:10:09                                                      */
/*                                                                                                                        */
/*                                                          LYN                                                           */
/*                                                                                                                        */
/*   Protocol: ABC Pharmaceuticals                                                                          Page 1 of n   */
/*   Population: All Subjects                                                                                             */
/*                                                     Template 1                                                         */
/*                                              Summary of Populations[1]                                                 */
/*                                                            Xanomeline      Xanomeline                                  */
/*                                               Placebo       Low Dose        High Dose        Total                     */
/*                    Population                 (N=xxx)        (N=xxx)         (N=xxx)        (N=xxx)                    */
/*                    Intent-To-Treat (ITT)     xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                   */
/*                    Safety                    xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                   */
/*                    Efficacy                  xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                   */
/*                    Completer Week 24         xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                   */
/*                    Complete Study            xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                   */
/*   [1] Phase I Intravenous Infusion                                                                                     */
/*   NOTE: N in column headers represents number of subjects entered in study (i.e., signed informed consent). The        */
/*   ITT population includes all subjects randomized. The Safety population includes all randomized subjects known        */
/*   to have taken at least one dose of randomized study drug. The Efficacy population includes all subjects in the       */
/*   safety population who also have at least one post-baseline ADAS-Cog and CIBIC+ assessment.                           */
/*   Source: p:/abc/abc_050Ldsp.sas                                                      21:05 Monday, June 26, 2006      */
/*                                                                                                                        */
/**************************************************************************************************************************/

data abc_000initFixRev(where=(index(upcase(pgmNam),"%upcase(&program)")>0));

   length pgmNam $64;
   retain pgmNam;

   if _n_=0 then set abc_000initFix nobs=numObs;

   do pt = numObs to 1 by -1;
     set abc_000initFix point=pt;
     if index(lyn,'Source:')>0 then pgmNam=lyn;
     output;
   end;

   stop;

run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* REVERSED                                                                                                               */
/* Up to 40 obs WORK.ABC_000INITFIXREV total obs=18 30MAY2022:19:23:14  (reversed)                                        */
/*                                                                                                                        */
/* Source: p:/abc/abc_050Ldsp.sas                                                           21:05 Monday, June 26, 2006   */
/* safety population who also have at least one post-baseline ADAS-Cog and CIBIC+ assessment.                             */
/* to have taken at least one dose of randomized study drug. The Efficacy population includes all subjects in the         */
/* ITT population includes all subjects randomized. The Safety population includes all randomized subjects known          */
/* NOTE: N in column headers represents number of subjects entered in study (i.e., signed informed consent). The          */
/* [1] Phase I Intravenous Infusion                                                                                       */
/*                  Complete Study            xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                     */
/*                  Completer Week 24         xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                     */
/*                  Efficacy                  xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                     */
/*                  Safety                    xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                     */
/*                  Intent-To-Treat (ITT)     xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                     */
/*                  Population                 (N=xxx)        (N=xxx)         (N=xxx)        (N=xxx)                      */
/*                                             Placebo       Low Dose        High Dose        Total                       */
/*                                                          Xanomeline      Xanomeline                                    */
/*                                            Summary of Populations[1]                                                   */
/*                                                   Template 1                                                           */
/* Population: All Subjects                                                                                               */
/* Protocol: ABC Pharmaceuticals                                                                          Page 1 of n     */
/*                                                                                                                        */
/**************************************************************************************************************************/

data abc_000initFixRevRev;

   if _n_=0 then set abc_000initFixRev nobs=numObs;

   do pt = numObs to 1 by -1;
     set abc_000initFixRev point=pt;
     pgmNam = scan(substr(pgmNam,16),1,'.');
     output;
   end;

   stop;
run;quit;

/*******************************************************************************************************************************/
/*                                                                                                                             */
/* Up to 40 obs WORK.ABC_000INITFIXREVREV total obs=18 30MAY2022:19:27:33                                                      */
/*                                                                                                                             */
/*   PGMNAM                               LYN                                                                                  */
/*                                                                                                                             */
/* abc_050Ldsp Protocol: ABC Pharmaceuticals                                             Page 1 of n                           */
/* abc_050Ldsp Population: All Subjects                                                                                        */
/* abc_050Ldsp                                    Template 1                                                                   */
/* abc_050Ldsp                             Summary of Populations[1]                                                           */
/* abc_050Ldsp                                           Xanomeline      Xanomeline                                            */
/* abc_050Ldsp                              Placebo       Low Dose        High Dose        Total                               */
/* abc_050Ldsp   Population                 (N=xxx)        (N=xxx)         (N=xxx)        (N=xxx)                              */
/* abc_050Ldsp   Intent-To-Treat (ITT)     xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                             */
/* abc_050Ldsp   Safety                    xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                             */
/* abc_050Ldsp   Efficacy                  xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                             */
/* abc_050Ldsp   Completer Week 24         xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                             */
/* abc_050Ldsp   Complete Study            xxx (xx%)      xxx (xx%)       xxx (xx%)      xxx (xx%)                             */
/* abc_050Ldsp [1] Phase I Intravenous Infusion                                                                                */
/* abc_050Ldsp NOTE: N in column headers represents number of subjects entered in study (i.e., signed informed consent). The   */
/* abc_050Ldsp ITT population includes all subjects randomized. The Safety population includes all randomized subjects known   */
/* abc_050Ldsp to have taken at least one dose of randomized study drug. The Efficacy population includes all subjects in the  */
/* abc_050Ldsp safety population who also have at least one post-baseline ADAS-Cog and CIBIC+ assessment.                      */
/* abc_050Ldsp Source: p:/abc/abc_050Ldsp.sas 21:05 Monday, June 26, 2006data abc_000initFixRev;                               */
/*                                                                                                                             */
/*******************************************************************************************************************************/

/*
                  _   _     _                      _
 _   _ ___  ___  | |_| |__ (_)___   _ __ ___   ___| |_ __ _
| | | / __|/ _ \ | __| `_ \| / __| | `_ ` _ \ / _ \ __/ _` |
| |_| \__ \  __/ | |_| | | | \__ \ | | | | | |  __/ || (_| |
 \__,_|___/\___|  \__|_| |_|_|___/ |_| |_| |_|\___|\__\__,_|

*/

data _null_;

  file print;

put '                   _   _     _                      _            ';
put '  _   _ ___  ___  | |_| |__ (_)___   _ __ ___   ___| |_ __ _     ';
put ' | | | / __|/ _ \ | __| `_ \| / __| | `_ ` _ \ / _ \ __/ _` |    ';
put ' | |_| \__ \  __/ | |_| | | | \__ \ | | | | | |  __/ || (_| |    ';
put '  \__,_|___/\___|  \__|_| |_|_|___/ |_| |_| |_|\___|\__\__,_|    ';
put '             _                     _                   _         ';
put '   ___ _   _| |_    __ _ _ __   __| |  _ __   __ _ ___| |_ ___   ';
put '  / __| | | | __|  / _` | `_ \ / _` | | `_ \ / _` / __| __/ _ \  ';
put ' | (__| |_| | |_  | (_| | | | | (_| | | |_) | (_| \__ \ ||  __/  ';
put '  \___|\__,_|\__|  \__,_|_| |_|\__,_| | .__/ \__,_|___/\__\___|  ';
put '                                      |_|                        ';

do until (dne);

  set abc_000initFixRevRev end=dne;

  put pgmNam lyn;

end;

put '                 _    ';
put '   ___ _ __   __| |   ';
put '  / _ \ `_ \ / _` |   ';
put ' |  __/ | | | (_| |   ';
put '  \___|_| |_|\__,_|   ';
put '                      ';

stop;

run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

%mend abc_000Init;



%abc_000Init(
                                     /* You must have defaults set                                      */
     meta         = 1                /* set to 1 to  parse mock for meta data                           */
    ,program      = abc_050LDsp.sas  /* must match the souce program in the mock. Must have prefix abc  */
    ,program_type = l                /* sets up the correct enviornment for listings tables graphs sdtm */
                                     /* l=list,rtf t=table.rtf g=graph.png s=sdtm a=adam                */
    ,debug        = 1                /* set to 0 for production                                         */
    ,mocks        = d:\abc\doc\abc_mocks.docx /* location of mocks */
    );
