" Set filetype based on the starting string of the first line
"
if did_filetype()   " filetype already set..
    finish      " ..don't do these checks
endif
if getline(1) =~ '^title:'
    setfiletype markdown
endif
