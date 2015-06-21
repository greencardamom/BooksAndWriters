Project to archive the Books and Writers website (kirjasto.sci.fi)

## Overview 

This repository contains two distinct elements:

	1. An archive of the Books and Writers website (Books and Writers.zip)
	
	2. Source code to update Wikipedia using AutoWikiBrowser (AWB)

The project website is [here](https://en.wikipedia.org/wiki/User:Green_Cardamom/kirjasto.sci.fi).

## Steps for archiving 

1. Download index page:

```
wget -q -O- "https://web.archive.org/web/20130704043115/http://www.kirjasto.sci.fi/indeksi.htm" > indeksi.htm
```

2. Download author pages:

```
grep '<li><a href="/web/20130704043115/http://www.kirjasto.sci.fi' indexsi.htm | grep -oE "sci.fi/[^.]*[^.]" | awk '{split($0,a,"/"); printf("wget --retry-connrefused --waitretry=1 --read-timeout=2 --timeout=5 --tries=1 --no-dns-cache -q -O- -q -O- \"https://web.archive.org/web/20150210175324/http://www.kirjasto.sci.fi/%s.htm\" > %s.htm\n",a[2],a[2])}'
```

## AWB source code 

This project is essentially completed so these scripts are no longer needed. They provide a basis for similar projects 
ie. automatically replacing certain text within a <ref></ref> pair with new text, and/or replacing an external links 
with a new external link. This is a common task, in particular as websites go offline and need Wayback replacements 
and/or changing bare URLs to templates (such as migrating all the findagrave.org URLs to the {{findagrave}} template).

To run the script with AutoWikiBrowser (AWB):

	0. Apply for AWB access (WP:AWB)
	1. Download and install Cygwin.
	2. Create a directory called "scriptname" (customize) in your /home/username directory
	3. Create a directory called "temp" off of the one made in step 2 (eg. /home/username/scriptname/temp)
	4. In AWB Tools->External Program Processing

		Enabled (check)
		Program or script: c:\cygwin\bin\tcsh.exe
		Arguments or Parameters: /home/username/scriptname/script.csh "%%title%%"
		Input/Output file: c:\cygwin\home\username\scriptname\temp\article.txt


## Books and Writers template 

A template written in Lua for linking to Books and Writers is at Template:Books_and_Writers on the English Wikipedia.

## Credits 

The Books and Writers website is Copyright Petri Liukkonen under the Creative Commons Finnish license BY-ND-NC (http://creativecommons.org/licenses/by-nd-nc/1.0/fi/deed.en)

The source code is Copyright User:Green Cardamom at en.wikipedia.org with a MIT License.

