#!/bin/bash
#
#___________________________________________________________________________________________
#
#
#
# Purpose :
#           Install stable BeSman Utility
#
#
#___________________________________________________________________________________________
#
# Global variables
BESMAN_PLATFORM=$(uname)
RUNAS=$(id -un)
SCRIPT_NAME=$(basename $0)

export BESMAN_SERVICE="https://raw.githubusercontent.com"

#BESMAN_NAMESPACE="hyperledgerkochi"
#BESMAN_VERSION="0.0.5"
BESMAN_NAMESPACE="mohatte"
BESMAN_VERSION="0.0.1"
BESMAN_ENV_REPOS="$BESMAN_NAMESPACE/besman-env-repo"
# BESMAN_DIST_BRANCH=${BESMAN_DIST_BRANCH:-REL-${BESMAN_VERSION}}


GITHUB_BASE_URL="https://github.com"
#"https://github.com/$namespace/$repo_name/archive/master.zip"
ENV_REPOS_ZIP_FILE="archive/master.zip"
#"https://github.com/${BESMAN_NAMESPACE}/BeSman/issues"

#"https://api.github.com/repos/$namespace/$repo_name"
BESNAN_ENV_REPOS_BASE_URL="https://api.github.com/repos"

#BESMAN_DIST_FILE="${BESMAN_SERVICE}/${BESMAN_NAMESPACE}/BeSman/dist/dist/besman-latest.zip"
#BESMAN_DIST_ENV="${BESMAN_SERVICE}/${BESMAN_NAMESPACE}/BeSman/master/dist/environments"

BESMAN_DIST_FILE="${GITHUB_BASE_URL}/${BESMAN_NAMESPACE}/BeSman/blob/BeSman/master/besman-latest.zip?raw=true"
#BESMAN_DIST_ENV="${BESMAN_SERVICE}/${BESMAN_NAMESPACE}/BeSman/main/master/dist/environments"
BESMAN_DIST_ENV="${BESMAN_SERVICE}/${BESMAN_NAMESPACE}/BeSman/BeSman/master/dist/environments"


if [ -z "$BESMAN_DIR" ]; then
    BESMAN_DIR="$HOME/.besman"
fi

# variables
besman_bash_profile="${HOME}/.bash_profile"
besman_profile="${HOME}/.profile"
besman_bashrc="${HOME}/.bashrc"
besman_zshrc="${HOME}/.zshrc"

besman_bin_folder="${BESMAN_DIR}/bin"
besman_src_folder="${BESMAN_DIR}/src"
besman_tmp_folder="${BESMAN_DIR}/tmp"
besman_env_folder="${BESMAN_DIR}/envs"
besman_etc_folder="${BESMAN_DIR}/etc"
besman_var_folder="${BESMAN_DIR}/var"
besman_log_folder="${BESMAN_DIR}/log"
besman_config_file="${besman_etc_folder}/config"
besman_stage_folder="${besman_tmp_folder}/stage"

besman_zip_file="${besman_tmp_folder}/besman-${BESMAN_VERSION}.zip"
besman_user_config_file="${besman_etc_folder}/user-config.cfg"


# Info Log setup
YYYYMMDD=$(date +"%Y%m%d")
LOG_FILE=${besman_log_folder}/${SCRIPT_NAME}_${YYYYMMDD}.log


#####**************************************************#####
#     Function to write info log                                #
#####**************************************************#####
function write_info {
    echo "$1"
    echo "$(date '+%D %T') -INFO $1" >> ${LOG_FILE}
    echo ""
}

#####**************************************************#####
#     Function to write log                                #
#####**************************************************#####
function write_err {
    echo "ERROR: $1 - Exitcode $2"
    echo "$(date '+%D %T') -ERROR $1 - Exitcode $2" >> ${LOG_FILE}
    echo "-----------------------------------------------------------" >> ${LOG_FILE}
    exit $2
}

#####**************************************************#####
#         Process  Starts Here                             #
#####**************************************************#####
if [[ ! -d "$besman_log_folder" ]]; then
   mkdir -p "$besman_log_folder"
fi

if [ "$RUNAS" == "root" ]; then
    write_info "The ${SCRIPT_NAME} is running with root user"
else
    write_err "The ${SCRIPT_NAME} is NOT Authorizied to run with ${RUNAS} user" 1
fi

besman_init_snippet=$( cat << EOF
#THIS MUST BE AT THE END OF THE FILE FOR BESMAN TO WORK!!!
export BESMAN_DIR="$BESMAN_DIR"
[[ -s "${BESMAN_DIR}/bin/besman-init.sh" ]] && source "${BESMAN_DIR}/bin/besman-init.sh"
EOF
)

# OS specific support (must be 'true' or 'false').
cygwin=false;
darwin=false;
solaris=false;
freebsd=false;
linux=false;
case "$(uname)" in
    CYGWIN*)
        cygwin=true
        ;;
    Darwin*)
        darwin=true
        ;;
    SunOS*)
        solaris=true
        ;;
    FreeBSD*)
        freebsd=true
        ;;
    Linux*)
        linux=true
esac



figlet Setting up BeSman >> besman.txt
cat besman.txt
rm besman.txt
# Sanity checks

write_info "Checking for a previous installation of BeSman..."
if [ -d $BESMAN_DIR/bin ]; then
        write_info "BeSman found."
        echo ""
        echo "======================================================================================================"
        echo " You already have BeSman installed."
        echo " BESMAN was found at:"
        echo ""
        echo "    ${BESMAN_DIR}"
        echo ""
        echo " Please consider running the following if you need to upgrade."
        echo ""
        echo "    $ bes selfupdate force"
        echo ""
        echo "======================================================================================================"
        echo ""
        exit 0
fi

write_info "Checking for unzip..."
if [ -z $(which unzip) ]; then
        echo "unzip command Not found in $(uname)"
        echo "======================================================================================================"
        echo " Please install unzip on your system using your favourite package manager."
        echo ""
        echo " Restart after installing unzip."
        echo "======================================================================================================"
        echo ""
        exit 1
fi

write_info "Checking for zip..."
if [ -z $(which zip) ]; then
        echo "zip command Not found in $(uname)."
        echo "======================================================================================================"
        echo " Please install zip on your system using your favourite package manager."
        echo ""
        echo " Restart after installing zip."
        echo "======================================================================================================"
        echo ""
        exit 1
fi

write_info "Checking for curl..."
if [ -z $(which curl) ]; then
        echo "curl command Not found in $(uname)."
        echo ""
        echo "======================================================================================================"
        echo " Please install curl on your system using your favourite package manager."
        echo ""
        echo " Restart after installing curl."
        echo "======================================================================================================"
        echo ""
        exit 1
fi

if [[ "$solaris" == true ]]; then
        echo "Checking for gsed..."
        if [ -z $(which gsed) ]; then
                echo "Not found."
                echo ""
                echo "======================================================================================================"
                echo " Please install gsed on your solaris system."
                echo ""
                echo " BESMAN uses gsed extensively."
                echo ""
                echo " Restart after installing gsed."
                echo "======================================================================================================"
                echo ""
                exit 1
        fi
else
        write_info "Checking for sed..."
        if [ -z $(which sed) ]; then
                echo "sed command Not found in $(uname)."
                echo ""
                echo "======================================================================================================"
                echo " Please install sed on your system using your favourite package manager."
                echo ""
                echo " Restart after installing sed."
                echo "======================================================================================================"
                echo ""
                exit 1
        fi
fi


write_info "Installing BeSman scripts..."


# Create directory structure

echo "Create distribution directories..."
mkdir -p "$besman_bin_folder"
mkdir -p "$besman_src_folder"
mkdir -p "$besman_env_folder"
mkdir -p "$besman_etc_folder"
mkdir -p "$besman_var_folder"
mkdir -p "$besman_tmp_folder"
mkdir -p "$besman_stage_folder"



write_info "Prime the config file..."
write_info "config selfupdate/debug_mode = true"

touch "$besman_config_file"
echo "besman_auto_answer=false" >> "$besman_config_file"
echo "besman_auto_selfupdate=false" >> "$besman_config_file"
echo "besman_insecure_ssl=false" >> "$besman_config_file"
echo "besman_curl_connect_timeout=7" >> "$besman_config_file"
echo "besman_curl_max_time=10" >> "$besman_config_file"
echo "besman_beta_channel=false" >> "$besman_config_file"
echo "besman_debug_mode=true" >> "$besman_config_file"
echo "besman_colour_enable=true" >> "$besman_config_file"

write_info "Setting up user configs"
touch "$besman_user_config_file"
echo "BESMAN_VERSION=$BESMAN_VERSION" >> "$besman_user_config_file"
echo "BESMAN_USER_NAMESPACE=" >> "$besman_user_config_file"
echo "BESMAN_ENV_ROOT=$HOME/BeSman_env" >> "$besman_user_config_file"
echo "BESMAN_NAMESPACE=hyperledgerkochi" >> "$besman_user_config_file"
echo "BESMAN_INTERACTIVE_USER_MODE=true" >> "$besman_user_config_file"
echo "BESMAN_DIR=$HOME/.besman" >> "$besman_user_config_file"
echo "BESMAN_ENV_REPOS=$BESMAN_ENV_REPOS" >> "$besman_user_config_file"

write_info "Downloading latest baseman script archive..."

# once move to besman namespace needs to update besman-latest.zip
curl -sL --location --progress-bar "${BESMAN_DIST_FILE}" > "$besman_zip_file"


ARCHIVE_OK=$(unzip -qt "$besman_zip_file" | grep 'No errors detected in compressed data')
if [[ -z "$ARCHIVE_OK" ]]; then
        write_info "Downloaded zip archive corrupt. Are you connected to the internet?"
        echo ""
        write_info "If problems persist, please ask for help on our Github:"
        write_info "* easy sign up: ${GITHUB_BASE_URL}"
        #rm -rf "$BESMAN_DIR"
        write_err "${GITHUB_BASE_URL}/${BESMAN_NAMESPACE}/BeSman/issues" 2
fi

write_info "Extracting script archive..."
if [[ "$cygwin" == 'true' ]]; then
        echo "Cygwin detected - normalizing paths for unzip..."
        besman_zip_file=$(cygpath -w "$besman_zip_file")
        besman_stage_folder=$(cygpath -w "$besman_stage_folder")
fi
unzip -qo "$besman_zip_file" -d "$besman_stage_folder"
if [[ $? -eq 0 ]]; then
	write_info "$besman_zip_file uncompress success"
else
	write_err "$besman_zip_file uncompress failed" $?
fi

write_info "Install scripts..."


curl -sL "${BESMAN_DIST_ENV}" > tmp.txt
if [[ $? -eq 0 ]]; then
	write_info "${BESMAN_DIST_ENV} file received"
else
	write_err "${BESMAN_DIST_ENV} file missing" $?
fi
sed -i 's/,/ /g' tmp.txt
environments=$(<tmp.txt)
for i in $environments;
do
	write_info "$besman_stage_folder/besman-$i.sh script moved to $besman_env_folder"
        mv "$besman_stage_folder"/besman-$i.sh "$besman_env_folder"
done
rm tmp.txt
mv "${besman_stage_folder}/besman-init.sh" "$besman_bin_folder"
write_info "$besman_stage_folder/besman-init.sh script moved to $besman_bin_folder"
mv "$besman_stage_folder"/besman-* "$besman_src_folder"
write_info "$besman_stage_folder/besman-* files moved to $besman_src_folder"
mv "$besman_stage_folder"/list.txt "$besman_var_folder"
write_info "$besman_stage_folder/list.txt file moved to $besman_var_folder"
[[ -d ${besman_stage_folder} ]] && rm -rf ${besman_stage_folder}/*

echo "Set version to $BESMAN_VERSION ..."
echo "$BESMAN_VERSION" > "${BESMAN_DIR}/var/version.txt"
function download_from_env_repo
{
        echo "checking for external repos..."
        env_repos=$(echo "$BESMAN_ENV_REPOS" | sed 's/,/ /g')
        cached_list="$BESMAN_DIR/var/list.txt"
        zip_stage_folder="$HOME/zip_stage_folder"
        mkdir -p "$zip_stage_folder"
        echo "Downloading environment files from $BESMAN_ENV_REPOS"
        for i in ${env_repos[@]}; do
                namespace=$(echo $i | cut -d "/" -f 1)
                repo_name=$(echo $i | cut -d "/" -f 2)
                if curl -s "${BESNAN_ENV_REPOS_BASE_URL}/$namespace/$repo_name" | grep -q "Not Found"
                then
                       write_info "${BESNAN_ENV_REPOS_BASE_URL}/$namespace/$repo_name - Not Found"
                       continue
                fi
                write_info "${BESNAN_ENV_REPOS_BASE_URL}/$namespace/$repo_name - Found"
                curl -sL "${GITHUB_BASE_URL}/$namespace/$repo_name/${ENV_REPOS_ZIP_FILE}" -o "$HOME/$repo_name.zip"
                unzip -q $HOME/$repo_name.zip -d $zip_stage_folder
		if [[ $? -eq 0 ]]; then
			 write_info "$HOME/$repo_name.zip file uncompressed to $zip_stage_folder"
		 else
			 write_err "$HOME/$repo_name.zip file uncompress failed" $?
		 fi
                remote_list="$zip_stage_folder/$repo_name-master/list.txt"
                #echo " remote list : $remote_list"
                if [[ ! -f "$remote_list" ]]; then
                        echo "Error:No list file found for $repo_name"
                        rm -rf "$zip_stage_folder"
                        continue
                fi
                environment_files=$(find $zip_stage_folder/$repo_name-master -type f -name "besman-*.sh")
                if [[ -z "${environment_files}" ]]; then
                        echo "No environment files found for $namespace/$repo_name"
                        continue
                fi
                for j in ${environment_files[@]}; do
                        trimmed_file_name="${j##*/}"
                        environment=$(echo "$trimmed_file_name" | cut -d "-" -f 2 | sed 's/.sh//g')
                        if cat "$cached_list" | grep -qw "$namespace/$repo_name/$environment"
                        then
                                continue
                        fi
                        mv "$j" "$BESMAN_DIR"/envs/
                        echo "" >> $cached_list
                        cat "$remote_list" | grep "$namespace/$repo_name/$environment"  >> "$cached_list"
                done
                rm "$HOME/$repo_name.zip"
        done
        if [[ -d $zip_stage_folder ]]; then
                rm -rf $zip_stage_folder
        fi
        unset environment_files namespace repo_name trimmed_file_name environment zip_stage_folder cached_list remote_list
}
download_from_env_repo
if [[ $darwin == true ]]; then
  touch "$besman_bash_profile"
  echo "Attempt update of login bash profile on OSX..."
  if [[ -z $(grep 'besman-init.sh' "$besman_bash_profile") ]]; then
    echo -e "\n$besman_init_snippet" >> "$besman_bash_profile"
    echo "Added besman init snippet to $besman_bash_profile"
  fi
else
  echo "Attempt update of interactive bash profile on regular UNIX..."
  touch "${besman_bashrc}"
  if [[ -z $(grep 'besman-init.sh' "$besman_bashrc") ]]; then
      echo -e "\n$besman_init_snippet" >> "$besman_bashrc"
      echo "Added besman init snippet to $besman_bashrc"
  fi
fi

echo "Attempt update of zsh profile..."
touch "$besman_zshrc"
if [[ -z $(grep 'besman-init.sh' "$besman_zshrc") ]]; then
    echo -e "\n$besman_init_snippet" >> "$besman_zshrc"
    echo "Updated existing ${besman_zshrc}"
fi

echo -e "\n\n\nAll done!\n\n"

echo "Please open a new terminal, or run the following in the existing one:"
echo ""
echo "    source \"${BESMAN_DIR}/bin/besman-init.sh\""

echo "    "
echo "Then issue the following command:"
echo ""
echo "    bes help"
echo ""

echo "${SCRIPT_NAME} Completed !!!"
