# sysfs

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Development - Guide for contributing to the module](#development)

## Overview

A module for managing sysfs settings.

## Usage

```
include sysfs

sysfs::setting { 'class/block/sdb/queue/read_ahead_kb':
  value => 8
}
```

Settings can also be defined in hiera under the `sysfs::settings` hash, e.g.

```
sysfs::settings:
  'class/block/sdb/queue/rotational':
    value: 0
  'class/block/sdb/queue/read_ahead_kb':
    value: 8
```


## Development

Pull requests gratefully recieved.

