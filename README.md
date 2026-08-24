# Log Archive Tool

A simple CLI tool to archive logs by compressing them into a timestamped `.tar.gz` file. Built as part of the [roadmap.sh DevOps projects](https://roadmap.sh/projects/log-archive-tool).

## Features

- Compresses any given log directory into a `.tar.gz` archive
- Names archives with a timestamp (e.g. `logs_archive_20260824_153012.tar.gz`)
- Stores archives in a dedicated `archives/` directory
- Logs the date and time of every archive operation to `archive.log`

## Usage

```bash
log-archive <log-directory>
```

Example:

```bash
log-archive /var/log
```

## Installation

```bash
git clone https://github.com/<your-username>/log-archive-tool.git
cd log-archive-tool
chmod +x log-archive.sh
sudo cp log-archive.sh /usr/local/bin/log-archive
```

## Example Output

```
Success: logs archived to archives/logs_archive_20260824_153012.tar.gz
```

## Requirements

- Bash
- `tar`
