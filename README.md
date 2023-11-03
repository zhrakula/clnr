# clnr.sh

Tool for remove "needless" (docs, cache, backgrounds, etc) files in system.

```
clnr.sh: [options] <rootdir>
  -b <file.tar>        make backup file
  -c <config.conf>     use config file
  -l                   list files
  -p <plugins>         comma separated plugins list
  -r                   remove files
  -u <file.tar>        restore from backup file
  -s                   print size of files
```

## List files and size for all plugins

```
./clnr.sh -ls -p * /
```

## List docs files

```
./clnr.sh -l -p docs /
```
