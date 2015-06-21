# Given a Wikipedia source file, replace any URL external links to kirjasto.sci.fi with the {{Books and Writers}} template
#  Pass these variables
#   -v sourcefile = wikipedia source file
#   -v name = name of person w/out dismabig

BEGIN {

   while ((getline s < sourcefile ) > 0) {

     if(s ~ "*[ ]{0,2}[[]{0,1}[ ]{0,2}http[s]{0,1}[:]//[w]{0,1}[w]{0,1}[w]{0,1}[.]{0,1}kirjasto[.]sci[.]fi") {
       match(s,"sci.fi/[^.]+[^.]",a)
       split(a[0],b,"/")
       bwid = b[2]
       newbw = sprintf("* {{Books and Writers |id=%s |name=%s}}",bwid,name)
       print newbw
     } else {
       print s
     }
   }

}
