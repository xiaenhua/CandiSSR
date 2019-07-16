function ask_program_path {
    local program_name="${1}"

    while :
    do
        local program_path=""
        echo 1>&2
        read -p "${program_name} is not found. Is the program already installed? [y/N] " -n 1
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            echo 1>&2
            read -p "Please enter the path of ${program_name} program (ex: /home/${program_name}/bin/): " program_path
            [ -e "${program_path}" -a -x "${program_path}" ] && break
        else
            break
        fi
    done

    echo "${program_path}"
}

function determine_program_path {
    local program_name="${1}"
    local program_path=""
   
    program_path="$(which "${program_name}" 2> /dev/null | tail -n1 | tr -d '\t')" #To remove alias information
    if [ -z "${program_path}" ]
    then
        program_path=$(ask_program_path "${program_name}")
    else
        if [ -e "${program_path}" -a -x "${program_path}" ]
        then
            echo 1>&2
            read -p "The detected path of ${program_name} is ${program_path}. Is it correct? [Y/n] " -n 1
            if [[ ${REPLY} =~ ^[Nn]$ ]]
            then
                program_path="$(ask_program_path "${program_name}")"
            fi
        else
            program_path="$(ask_program_path "${program_name}")"
        fi
    fi

    echo "${program_path}"
}

BASE_DIR=$(cd "$(dirname "$0")" && pwd)

PERL_PATH="$(which perl 2> /dev/null | tail -n1 | tr -d '\t')" #To remove alias information

echo
echo "START TO SET UP FOR CandiSSR!!!"

[ -e "${BASE_DIR}/CandiSSR.cfg" ] && rm -f "${BASE_DIR}/CandiSSR.cfg"
touch "${BASE_DIR}/CandiSSR.cfg"

echo "#!${PERL_PATH}" >> "${BASE_DIR}/CandiSSR.cfg"
echo "" >> "${BASE_DIR}/CandiSSR.cfg"
echo "##############PROGRAM SETTINGS############" >> "${BASE_DIR}/CandiSSR.cfg";
echo "\$CandiSSR_HOME='${BASE_DIR}';" >> "${BASE_DIR}/CandiSSR.cfg"

exec 16<> setup.data
while read -u 16 var_name program_name program_url
do
    program_path="$(determine_program_path "${program_name}")"
    if [ -z "${program_path}" ]
    then    
        echo -e "\nYou can download ${program_name} at ${program_url}.\nPlease, install the program and restart this script."
        rm -f "${BASE_DIR}/CandiSSR.cfg"
        exit 1
    else
       [ $program_name != "misa" ] && echo "\$${var_name}='$(dirname ${program_path})';" >> "${BASE_DIR}/CandiSSR.cfg" || echo "\$${var_name}='${program_path}';" >> "${BASE_DIR}/CandiSSR.cfg"
    fi
done

echo "##############PROGRAM SETTINGS END############" >> "${BASE_DIR}/CandiSSR.cfg";
echo "" >> "${BASE_DIR}/CandiSSR.cfg"

cat "${BASE_DIR}/CandiSSR.cfg" "${BASE_DIR}/CandiSSR.template" > "${BASE_DIR}/CandiSSR.pl"
[ -e "${BASE_DIR}/CandiSSR.cfg" ] && rm -f "${BASE_DIR}/CandiSSR.cfg"

chmod a+x CandiSSR.pl

echo
echo "CandiSSR is successfully installed!!!"
echo
echo "More information please refer to: http://www.plantkingdomgdb.com/CandiSSR/.";
echo

exit 0


