#!/bin/bash

# Color Definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function to check internet connectivity
check_internet() {
    echo -e "${CYAN}[*] Verifying internet connectivity...${NC}"
    if ! ping -c 1 8.8.8.8 &>/dev/null; then
        echo -e "${RED}[!] Internet connection not detected. Exiting...${NC}"
        exit 1
    fi
    echo -e "${GREEN}[+] Internet connectivity confirmed.${NC}"
}

# Function to display usage
usage() {
    echo -e "${WHITE}Usage: $0 -u <url> [-c <collaborator_url>]${NC}"
    exit 1
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Parse command-line arguments
url=""
collaborator=""

while getopts ":u:c:" opt; do
    case $opt in
        u) url="$OPTARG"
        ;;
        c) collaborator="$OPTARG"
        ;;
        *) usage
        ;;
    esac
done

# Check if URL is provided
if [ -z "$url" ]; then
    usage
fi

# Function to extract base URL


banner(){
  printf "   _  __\n"                     
  printf "  | |/ /____  ____  ________\n" 
  printf "  |   // __ \/ __ \/ ___/ _ \ \n"
  printf " /   |/ /_/ / /_/ (__  )  __/\n"
  printf "/_/|_/ .___/\____/____/\___/ \n"
  printf "    /_/                      \n"
  printf "\n=============================\n"
}


get_base_url() {
    echo "$1" | awk -F/ '{print $1"//"$3}'
}

# Function to crawl the URL and find other URLs on the same host
crawl_urls() {
    echo -e "${CYAN}[*] Initiating URL crawl for: $url...${NC}"

    # Fetch HTML content
    curl --socks5-hostname localhost:9050 -s "$url" > page.html

    # Extract the base URL
    base_url=$(get_base_url "$url")

    # Extract all href and src attributes, then format them as full URLs
    grep -Eo '(href|src)="[^"]+"' page.html | grep -Eo '"[^"]+"' | tr -d '"' | while read -r link; do
        if [[ "$link" == /* ]]; then
            echo "$base_url$link"
        elif [[ "$link" =~ ^http ]]; then
            echo "$link"
        fi
    done | sort -u > urls.txt
    echo "$url" >> urls.txt

    echo -e "${GREEN}[+] Found URLs:${NC}"
    cat urls.txt

    echo -e "\n ============================= DETAILED BUFFER =============================\n" > results.txt
    
    rm page.html
}

# Function to perform the curl requests on each URL
perform_curl() {
    echo -e "${CYAN}[-] [CRAWLING] Performing curl requests on the found URLs...${NC}"

    # Define common image and video extensions to skip
    skip_extensions="jpg|jpeg|png|gif|bmp|webp|mp4|avi|mkv|mov|wmv|flv|ogg|webm"

    while read -r found_url; do
        if [[ "$found_url" =~ \.($skip_extensions)$ ]]; then
            echo -e "${YELLOW}[!] Skipping image/video URL: $found_url${NC}"
            continue
        fi

        echo -e "\n=============================\n${CYAN}[+] Processing ${RED} $found_url...${NC}\n"

        if [ -n "$collaborator" ]; then
            echo -e "${RED}[+] [INFO] ${CYAN}Sending request with custom HTTP Headers, Check interaction in your collaborator...${NC}"

            echo -e "\n ---------- Checking Blind Interaction at : $found_url ----------\n" >> results.txt
            curl --socks5-hostname localhost:9050 -i -s -k -X GET \
                -H "Host: $collaborator" \
                -H "Cache-Control: max-age=0" \
                -H "Upgrade-Insecure-Requests: 1" \
                -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36" \
                -H "x-host: $collaborator" \
                -H "x-forwarded-for: $collaborator" \
                -H "Connection: close" \
                "$found_url" >> results.txt
        fi

        echo -e "${RED}[+] [INFO] ${CYAN}Sending request with downgraded HTTP protocol (HTTP/1.0)...${NC}"
        echo -e "\n ---------- Checking Downgraded Protocol at : $found_url ----------\n" >> results.txt
        curl --socks5-hostname localhost:9050 -i -s -k --http1.0 "$found_url" >> results.txt

        echo -e "${RED}[+] [INFO] ${CYAN}Sending request without Host Header...${NC}"
        echo -e "\n ---------- Checking Without Host Header at : $found_url ----------\n" >> results.txt

        curl --socks5-hostname localhost:9050 -i -s -k -X GET \
            -H "Host: " \
            -H "Cache-Control: max-age=0" \
            -H "Upgrade-Insecure-Requests: 1" \
            -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36" \
            -H "Connection: close" \
            "$found_url" >> results.txt

        echo -e "${RED}[+] [INFO] ${CYAN}Sending request to check redirects...${NC}"

        echo -e "\n ---------- Checking Redirects at : $found_url ----------\n" >> results.txt
        curl --socks5-hostname localhost:9050 -i -s -k -X GET \
            -H "Host: $found_url" \
            -H "Cache-Control: max-age=0" \
            -H "Upgrade-Insecure-Requests: 1" \
            -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36" \
            -H "Connection: close" \
            "$found_url" >> results.txt

        echo -e "${RED}[+] [INFO] ${CYAN}Sending request to check length overflow...${NC}"
        echo -e "\n ---------- Checking Lenght Overflow at : $found_url ----------\n" >> results.txt
        curl --socks5-hostname localhost:9050 -i -s -k -X POST \
            -H "Host: $found_url" \
            -H "Cache-Control: max-age=0" \
            -H "Upgrade-Insecure-Requests: 1" \
            -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36" \
            -H "Connection: close" \
            --data-binary 'content=testdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdata' \
            "$found_url" >> results.txt

    done < urls.txt
}

# Function to search for interesting things
search_interesting() {
    echo -e "\n================================================="
    echo -e "\n${CYAN}[-] [SEARCHING] Searching for interesting information in the results...${NC}"

    sed -i 's/\r//g' results.txt # For removing carriage return (^M)

    # Search for email addresses
    echo -e "\n${RED}[-]${WHITE} Email addresses found:${NC}"
    grep -E -o "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}" results.txt | sort -u

    # Search for IP addresses
    echo -e "\n${RED}[-]${WHITE} IP addresses found:${NC}"
    grep -E -o "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" results.txt | sort -u

    # Search for generic API keys or access tokens
    echo -e "\n${RED}[-]${WHITE} API keys or Access tokens found:${NC}"
    grep -E -o "(Api[_-]?Key|ApiKey|API[_-]?KEY|api[_-]?key|api[_-]?Key|access[_-]?key|accesskey|API[_-]?KEY)[=:\"' ]+[a-zA-Z0-9_-]{10,}" results.txt | sort -u 
    grep -E -o "(Access[_-]?Token|AccessToken|ACCESS[_-]?TOKEN|access[_-]?token|accesskey|ACCESS[_-]?KEY)[=:\"' ]+eyJ[^\s\"]*" results.txt | sort -u
    grep -E -o "(Access[_-]?Token|AccessToken|ACCESS[_-]?TOKEN|access[_-]?token|accesskey|ACCESS[_-]?KEY)[=:\"' ]+ghp_[^\s\"]*" results.txt | sort -u

    # Search for AWS Access Key ID
    echo -e "\n${RED}[-]${WHITE} AWS Access Key IDs found:${NC}"
    grep -E -o "(A3T[A-Z0-9]|AKIA|AGPA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}" results.txt | sort -u
    grep -E -o "([a-zA-Z0-9+/]{40})" results.txt | sort -u

    echo -e "\n${RED}[-]${WHITE} ETag Header Information:${NC}"
    grep -i -E "^E[-]?Tag:[ \t]*W?/\"?[^\"]+\"?$" results.txt | sort -u

    echo -e "\n${RED}[-]${WHITE}Server Details:${NC}"
    grep -i -E "^Server:[ \t]*.+$" results.txt | sort -u
}

# Main execution

banner
check_internet
crawl_urls
perform_curl
search_interesting

echo -e "\n${GREEN}[+] Results saved in results.txt${NC}\n\n"
