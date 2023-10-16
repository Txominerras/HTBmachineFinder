#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"



#Global variables
main_url="https://htbmachines.github.io/bundle.js" 

function ctrl_c(){
	echo -e "\n${redColour}[!] Exit ${endColour}\n"
	tput cnorm && exit 1
}

#Ctrl_C

trap ctrl_c INT


function helpPanel(){
	echo -e "\n ${yellowColour}[+] Help Panel: ${endColour}\n"
	echo -e "\t ${purpleColour}u)${endColour} ${grayColour}Download or update all neccesary files ${endColour}"
	echo -e "\t ${purpleColour}m)${endColour} ${grayColour}Search machines by name${endColour}"
	echo -e "\t ${purpleColour}i)${endColour} ${grayColour}Search machines by IP address${endColour}"
    echo -e "\t ${purpleColour}y)${endColour} ${grayColour}Get the youtube link for the machine solution giving the machines name as parameter${endColour}"
    echo -e "\t ${purpleColour}d)${endColour} ${grayColour}Search machines by difficulty${endColour} ${blueColour}(Possible values: Easy, Medium, Hard or Insane)${endColour}"
    echo -e "\t ${purpleColour}s)${endColour} ${grayColour}Search machines by skills${endColour}"
    echo -e "\t ${purpleColour}o)${endColour} ${grayColour}Search machines by operative system${endColour} ${blueColour}(Possible values: Linux or Windows)${endColour}"
    echo -e "\t ${purpleColour}h)${endColour} ${grayColour}Show this panel${endColour} \n"

}

function searchMachineByName(){
	machineName=$1
	
	machineName_checker=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/dificultad/difficulty /')
	if [ "$machineName_checker" ]; then
		echo -e "\n${yellowColour}[+]${endColour} ${grayColour}listing features of the ${redColour}$machineName${endColour} ${grayColour}machine: ${endColour} \n"
		echo -e "${grayColour}$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/dificultad/difficulty /'| sed 's/^/\t/')${endColour}\n"
	else
		echo -e "\n ${redColour}[!] That machine is not in the database ${endColour}\n"
	fi
}

function updateFiles(){
	if [ ! -f bundle.js ]; then
		tput civis
		echo -e "\n ${blueColour} Starting to download ... ${endColour} \n"
		curl -s $main_url > bundle.js
		js-beautify bundle.js | sponge bundle.js
		#The source code is in Spanish so this part is to translate it to English
		sed -i 's/Fácil/Easy/g' bundle.js
		sed -i 's/Media/Medium/g' bundle.js
		sed -i 's/Difícil/Hard/g' bundle.js
		sed -i 's/so/os/g' bundle.js

		echo -e "${blueColour} Completed! ${endColour}\n"
		tput cnorm
	else
		tput civis
		echo -e "${blueColour}Checking for updates...\n${endColour}"
		curl -s $main_url > bundle_tmp.js
		js-beautify bundle_tmp.js | sponge bundle_tmp.js
		#The source code is in Spanish so this part is to translate it to English
		sed -i 's/Fácil/Easy/g' bundle_tmp.js
        sed -i 's/Media/Medium/g' bundle_tmp.js
        sed -i 's/Difícil/Hard/g' bundle_tmp.js
        sed -i 's/so/os/g' bundle_tmp.js

		md5_tmp=$(md5sum bundle_tmp.js | awk '{print $1}')
		md5_original=$(md5sum bundle.js | awk '{print $1}')
		if [ $md5_tmp == $md5_original ]; then
			echo -e "${blueColour}Files are up to date\n${endColour}"
			rm bundle_tmp.js
		else
			mv bundle_tmp.js bundle.js
			echo -e "${blueColour}Files have been updated sucessfully\n${endColour}"
		fi
		tput cnorm
	fi
}

function searchByOS(){
	os=$1
	os_checker=$(cat bundle.js | grep "os: \"$operativeSystem\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)
	if [ "$os_checker" ]; then
		if [ "$os" == "Linux" ]; then
			echo -e "\n${grayColour} These are the machines with the operative system${endColour} ${greenColour}$os${endColour}\n"
			echo -e "${greenColour}$(cat bundle.js | grep "os: \"$os\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)${endColour}\n"
		else
			echo -e "\n${grayColour} These are the machines with the operative system${endColour} ${blueColour}$os${endColour}\n"
			echo -e "${blueColour}$(cat bundle.js | grep "os: \"$os\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)${endColour}\n"
		fi
	else
		echo -e "\n ${redColour}[!] That is not a valid operative system ${endColour}\n"
	fi
}

function searchByDifficulty(){
	difficulty=$1
	results_checker=$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)
	if [ "$results_checker" ]; then
		if [ "$difficulty" == "Easy" ]; then
			echo -e "\n${grayColour}These are the machines with difficulty${endColour} ${greenColour}$difficulty${endColour}\n"
			echo -e "${greenColour}$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)${endColour}\n"
		elif [ "$difficulty" == "Medium" ]; then
			echo -e "\n${grayColour}These are the machines with difficulty${endColour} ${yellowColour}$difficulty${endColour}\n"
            echo -e "${yellowColour}$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)${endColour}\n"
		elif [ "$difficulty" == "Hard" ]; then
            echo -e "\n${grayColour}These are the machines with difficulty${endColour} ${redColour}$difficulty${endColour}\n"
            echo -e "${redColour}$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)${endColour}\n"

		else
			echo -e "\n${grayColour}These are the machines with difficulty${endColour} ${purpleColour}$difficulty${endColour}\n"
            echo -e "${purpleColour}$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)${endColour}\n"
		fi

	else
		echo -e "\n ${redColour}[!] Thats not a valid difficulty ${endColour}\n"
	fi
}


function searchMachineByIp(){
	ipAddress="$1"
	machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
	if [ "$machineName" ]; then
		echo -e "\n${grayColour} The IP address $ipAddress belongs to the ${endColour} ${redColour}$machineName${endColour} ${grayColour} machine${endColour} \n"
    else
        echo -e "\n ${redColour}[!] That machine is not in the database ${endColour}\n"
    fi
}

function getYouTubeLink(){
	machineName=$1
	machineName_checker=$(cat bundle.js | grep $machineName)
	if [ "$machineName_checker" ]; then
		echo -e "\n ${grayColour}The youtube link is: ${endColour}${blueColour}$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/dificultad/difficulty /' | grep youtube | awk 'NF{print $NF}')${endColour}\n"
	else
		echo -e "\n ${redColour}[!] That machine is not in the database ${endColour}\n"
	fi
}

function filterDifficultyAndOS(){
	os=$1
	difficulty=$2
	checker=$(cat bundle.js | grep "os: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')
	if [ "$checker" ]; then
		echo -e "\n ${grayColour}These are the machines with difficulty${endColour} ${blueColour}$difficulty${endColour} ${grayColour}and operative system ${endColour}${blueColour}$os${endColour}\n"
		echo -e "${blueColour}$(cat bundle.js | grep "os: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)${endColour}\n"
	else
		echo -e "\n${redColour} [!] That machine is not in our database\n"
	fi
}

function searchBySkill(){
	skill=$1
	checker="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
	if [ "$checker" ]; then
		echo -e "${grayColour} These are the machines that have the skill${endColour}${blueColour} $skill ${endColour}\n"
		echo -e "${blueColour}$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)${endColour}\n"
	else
		echo -e "\n${redColour} [!] Not machines found with that skill ${endColour}\n"
	fi
}

#Indicators
declare -i parameter_counter=0

#Flags
declare -i os_flag=0
declare -i difficulty_flag=0


while getopts "m:ui:y:d:o:s:h" arg; do
	case $arg in
		m) machineName=$OPTARG; let parameter_counter+=1;;
		u) let parameter_counter+=2;;
		i) ipAddress=$OPTARG; let parameter_counter+=3;;
		y) machineName=$OPTARG; let parameter_counter+=4;;
		d) difficulty=$OPTARG; difficulty_flag=1; let parameter_counter+=5;;
		o) os=$OPTARG; os_flag=1; let parameter_counter+=6;;
		s) skill=$OPTARG; let parameter_counter+=7;;
		h) ;;
	esac
done

if [ $parameter_counter -eq 1 ]; then
	searchMachineByName $machineName
elif [ $parameter_counter -eq 2 ]; then
	updateFiles
elif [ $parameter_counter -eq 3 ]; then
	searchMachineByIp $ipAddress
elif [ $parameter_counter -eq 4 ]; then
	getYouTubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
	searchByDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
	searchByOS $os
elif [ $parameter_counter -eq 7 ]; then
	searchBySkill "$skill"
elif [ $os_flag -eq 1 ] && [ $difficulty_flag -eq 1 ]; then
	filterDifficultyAndOS $os $difficulty 
else
	helpPanel
fi
