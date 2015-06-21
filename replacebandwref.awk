# Given a Wikipedia source file, replace any citations to http://www.kirjasto.sci.fi with a new citation to {{Books and Writers}} template
#  Pass these variables
#   -v sourcefile = wikipedia source file
#   -v name = name of person w/out dismabig

@load "readfile"

function replace(old, new) {

       gsub("[[]","[[]", old)
       gsub("[(]","[(]", old)
       gsub("[{]","[{]", old)
       gsub("[?]","[?]", old)
       gsub("[.]","[.]", old)
       gsub("[*]","[*]", old)
       gsub("[$]","[$]", old)
       gsub("[+]","[+]", old)
       gsub("[|]","[|]", old)
       gsub("[-]","[-]", old)
       gsub("[&]","[&]", old)

       gsub(old,new,ArticleWork)

}

function bandwid(s      ,a, d) {
       match(s,"sci.fi/[^.]+[^.]",a)
       split(a[0],d,"/")
       return d[2]
}

BEGIN {

   Article = readfile(sourcefile)
   ArticleWork = Article

  # Replace all {{cite template cases

   c = patsplit(Article, b, "{[ ]{0,2}[Cc]ite[^}]+}")
   while (i++ < c) {
     if(b[i] ~ "kirjasto[.]sci[.]fi") {
       replace(b[i], sprintf("{Books and Writers |id=%s |name=%s |cite=yes}", bandwid(b[i]), name) )
     }
   }

   # Replace all remaining cases enclosed in <ref></ref> tags. N.B.: this must be last.

   c = split(ArticleWork, b, "<ref[^>]*>")
   i = 1
   while(i++ < c) {
     k = substr(b[i], 1, match(b[i], "</ref>") - 1)
     if(k ~ "kirjasto[.]sci[.]fi") {
       replace(k, sprintf("{{Books and Writers |id=%s |name=%s |cite=yes}}", bandwid(k), name) )
     }
   }

   print ArticleWork

}
