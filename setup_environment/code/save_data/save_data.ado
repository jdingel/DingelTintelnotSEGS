program save_data
    version 11
    syntax anything(name=filename) [if], key(varlist) [outsheet log_replace log(str) missok* nopreserve logonly]
    if "`preserve'"!="nopreserve" {
        preserve
    }

    if "`if'"!="" {
        keep `if'
    }
    isid `key', sort `missok'
    order `key', first
    compress

    * Define default log value
    if "`log'"=="" {
        local filenamestripped = subinstr(`"`filename'"',char(34),"",.)
        if strpos("`filenamestripped'", "../output") local log = "../report/" + subinstr("`filenamestripped'","../output/","",1) + ".log"
        if strpos("`filenamestripped'", "../temp") local log = "../report/" + subinstr("`filenamestripped'","../temp/","",1) + ".log"
    }

    if "`logonly'"=="" { //The logonly option skips saving
    if "`outsheet'"!="" {
        outsheet using `filename', `options'
    }
    else {
        save `filename', `options'
    }
    }

    if "`log_replace'"!="" {
        print_info_to_log using `log', filename(`filename') key(`key') overwrite
    }
    else {
        print_info_to_log using `log', filename(`filename') key(`key')
    }

    //Remove date that 'describe' command prints in logfile
    shell sed -i.bak 's/[0-3]*[0-9] [JFMASOND][aceopu][bcglnprtvy] 202[2-9] [0-2][0-9]:[0-5][0-9]//' `log'
    rm `log'.bak

    if "`preserve'"!="nopreserve" {
        restore
    }
end

program print_info_to_log
    syntax using/, filename(str) key(varlist) [nolog overwrite]
    set linesize 100 //arbitrary selection

    if "`using'"~="none" {
        if "`overwrite'"!=""{
            qui log using `using', text replace name(save_data_log)
        }
        else{
            qui log using `using', text append name(save_data_log)
        }
    }
    di "=================================================================================================="
    if regexm("`filename'", "\.") == 0 {
        di "File: `filename'.dta"
    }
    else {
        di "File: `filename'"
    }
    di "Key: `key'"
    di "=================================================================================================="
    datasignature
    desc
    sum

    // We do not list the one observation because the summary statistics above are sufficient.
    if _N >= 2{
        display "The first 2 observations of the dataset are:"
        list if inrange(_n, 1, 2)
        display "The last 2 observations of the dataset are:"
        list if inrange(_n, _N-1, _N)
        di ""
    }
    cap log close save_data_log
end
