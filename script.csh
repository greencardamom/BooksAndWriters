#!/usr/bin/tcsh 

set AGENT="en:User:Green Cardamom/kirjasto.sci.fi" # Customize your contact info
set WI_BASEPATH="/home/username/"                  # Your home directory (w/trailing slash)
set WI_DIRNAME="scriptdir"                         # Directory name (no path) where the script resides (no trailing slash) off of WI_BASEPATH

# Example: If your script is in /home/tom/wikiawb then set WI_BASEPATH="/home/tom/" and WI_DIRNAME="wikiawb"

set bandw = 1 # Set to 0 to disable code block

set AWK="/bin/gawk"
set SED="/bin/sed"
set WGET="/bin/wget"
set CP="/bin/cp"
set RM="/usr/bin/rm"
set MV="/usr/bin/mv"
set MKDIR="/bin/mkdir"
set DATE="/bin/date"

setenv LANG en_US.UTF-8
setenv LC_COLLATE en_US.UTF-8

set WI_PATH="$WI_BASEPATH""$WI_DIRNAME""/"         # Full path to the script directory

# Create temp directory
set stamp=`$DATE +"%m%d%H%M%S"`
set TEMP_DIRECTORY="$WI_PATH""temp"
set WI_TEMP="$TEMP_DIRECTORY""/wi-""$stamp""/"             
$MKDIR "$WI_TEMP"
if ( ! -e "$WI_TEMP" ) then #
  echo "Unable to create temp directory ""$WI_TEMP"
  goto myend
endif

#If cntrl-c interrupt, clean up temporary files - go to the myend: tag
onintr myend

#No argument?
if ($#argv == 0) then
  echo "$stamp"": No argument." 
  exit
endif

# Wikipedia article name
set namewiki = "$argv[1]"

# Name without ()'s
set name = `$AWK -v name="$namewiki" 'BEGIN{split(name,s,"("); print s[1]}'`

#Convert spaces to _
set namewikiunder = `$AWK -v s="$namewiki" 'BEGIN{gsub(/ /,"_",s); gsub(/'\''/,"%27",s); print s}'`

# Flag when article is to be updated or not
set update = "no"

# Save Wikipedia wikisource to article.txt
$WGET --retry-connrefused --waitretry=1 --read-timeout=2 --timeout=2 --no-dns-cache --user-agent="$AGENT" -q -O- https://en.wikipedia.org/wiki/Special:Export/"$namewikiunder" | $AWK '{RS=("<text xml|</text")} NR==3' | $AWK 'NR==2 {gsub(/&lt;/,"<");gsub(/&gt;/,">");gsub(/&quot;/,"\"");gsub(/&amp;/,"\\&");gsub("{{reflist","{{Reflist");gsub(/<[Rr]eferences \/>/,"{{Reflist}}");gsub(/<[Rr]eferences\/>/,"{{Reflist}}");print}' RS=">"  > "$WI_TEMP""article.txt"

  # Books and Writers

    if("$bandw" == 1) then
      echo ""  > /dev/stderr
      echo "Books and Writers" > /dev/stderr
      set xtermok = 0

      # External links
      set bandwcount = `$AWK -v i=0 '{IGNORECASE=1} $0 ~ "*[ ]{0,2}[[]{0,1}[ ]{0,2}http[s]{0,1}[:]//[w]{0,1}[w]{0,1}[w]{0,1}[.]{0,1}kirjasto[.]sci[.]fi" {i++} END {print i}' "$WI_TEMP""article.txt"`
      if($bandwcount > 0 ) then
        echo "  Found 1 external link" > /dev/stderr
        $AWK -v name="$name" -v sourcefile="$WI_TEMP"article.txt -f "$WI_PATH"replacebandw.awk > "$WI_TEMP"o
        $MV "$WI_TEMP"o "$WI_TEMP"article.txt
        set update = "yes"
      endif

      # Citations
      $AWK -v name="$name" -v sourcefile="$WI_TEMP"article.txt -f "$WI_PATH"replacebandwref.awk > "$WI_TEMP"o
      if(`$AWK -lreadfile -v one="$WI_TEMP"o -v two="$WI_TEMP"article.txt 'BEGIN{a = readfile(one); b = readfile(two); if(length(a) - 1 != length(b) ) print 1}'` == 1) then
        echo "  Found citation(s)" > /dev/stderr
        $CP "$WI_TEMP"o "$WI_TEMP"article.txt
        set update = "yes"
      endif

      if("$update" == "no") then
        set ptext = "Manual intervention required. Update article and press the <ENTER> key when done..."
        printf "\n$ptext" > /dev/stderr
        set junk = ($<)
      endif

    endif

if("$update" == "yes") then

  $AWK 'BEGINFILE{if (ERRNO) nextfile} {print $0}' "$WI_TEMP"article.txt > "$TEMP_DIRECTORY"/article.txt

  # Remove leading and trailing blank lines
  # https://stackoverflow.com/questions/7359527/removing-trailing-starting-newlines-with-sed-awk-tr-and-friends
  $AWK '{ LINES=LINES $0 "\n"; } /./ { printf "%s", LINES; LINES=""; }' "$TEMP_DIRECTORY"/article.txt | $SED '/./,$\!d' > "$TEMP_DIRECTORY"/o
  $MV "$TEMP_DIRECTORY"/o "$TEMP_DIRECTORY"/article.txt


endif

