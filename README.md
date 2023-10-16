# HTB Machine Search

## Overview

The HTB Machine Search is a Bash script that allows you to search and retrieve information about machines available on the Hack The Box platform. It provides various search options and information retrieval features to help you find and explore machines of interest.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Usage](#usage)
   - [Update Files](#update-files)
   - [Search Machines by Name](#search-machines-by-name)
   - [Search Machines by IP Address](#search-machines-by-ip-address)
   - [Get YouTube Link](#get-youtube-link)
   - [Search Machines by Difficulty](#search-machines-by-difficulty)
   - [Search Machines by Operating System](#search-machines-by-operating-system)
   - [Search Machines by Skill](#search-machines-by-skill)
   - [Help Panel](#help-panel)

## Prerequisites

Before using this script, ensure that you have the following prerequisites:

- Bash shell
- curl
- js-beautify (for code formatting)

## Usage

You can use the script with various options to search and retrieve information about Hack The Box machines. Here are the available options:

### Update Files

This option updates the local machine database file (bundle.js) with the latest data from the https://htbmachines.github.io/ website.

```bash
./htb_machine_search.sh -u
```

### Search Machines by Name

You can search for machines by their name using this option. Provide the machine name as an argument.

```bash
./htb_machine_search.sh -m <machine_name>
```
### Search Machines by IP Address

Search for machines by their IP address using this option. Provide the IP address as an argument.

```bash
./htb_machine_search.sh -i <ip_address>
```

### Get YouTube Link

Retrieve the YouTube link for a machine's solution by providing the machine name as an argument.

```bash
./htb_machine_search.sh -i <ip_address>
```

### Search Machines by IP Address

Search for machines by their IP address using this option. Provide the IP address as an argument.

```bash
./htb_machine_search.sh -y <machine_name>
```

### Search Machines by Difficulty

Search for machines by difficulty level. Valid difficulty levels are "Easy," "Medium," "Hard," or "Insane."

```bash
./htb_machine_search.sh -d <difficulty>
```

### Search Machines by Operating System

Search for machines by their operating system. Valid options are "Linux" or "Windows."

```bash
./htb_machine_search.sh -o <operating_system>
```

#### Note: Difficulty and Operative System

Difficulty and operating system can be combined to filter machines by both their difficulty level and operating system.

```bash
./htb_machine_search.sh -o <operating_system> -d <difficulty>
```

### Search Machines by Skill

Search for machines that require a specific skill. Provide the skill as an argument.

```bash
./htb_machine_search.sh -s <skill>
```

### Help Panel

To display a help panel with all the available options, simply run the script without any arguments.

```bash
./htb_machine_search.sh
```

