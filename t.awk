
@include "readfile"

BEGIN{

  insert_text = "This is an archive of a dead website. The original website was published by Petri Liukkonen under <a href=\"https://creativecommons.org/licenses/by-nd-nc/1.0/fi/deed.en\">Creative Commons BY-ND-NC 1.0 Finland</a> and reproduced here under those terms for non-commercial use. All pages are unmodified as they originally appeared; some links and images may no longer function. A .zip of the website is also <a href=\"https://github.com/greencardamom/BooksAndWriters\">available</a>.<br>"

  fp = readfile(sourcefile)

  gsub(/index[.]htm[#]/, "index.html#", fp)

  #newstr = "<!--Vara4--></p><p>" insert_text "</p>"

  #nfp = gensub(/<[ ]{0,}![ ]{,0}--[ ]{0,}[Vv][Aa][Rr][Aa]4[ ]{0,}--[ ]{0,}>[ \n\t]{0,}<[ ]{0,}\/[ ]{0,}[Pp][ ]{0,}>/, newstr, 1, fp)

  #if(fp == nfp)
  #  print "Unable to process " sourcefile > "/dev/stderr"
  #else
  #  print nfp > sourcefile

  print fp > sourcefile

}

