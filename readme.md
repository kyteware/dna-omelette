# DNA Omlette

This repository of the work we did in observing the kmers in reads of DNA and using them to estimate how accurate they are.

## Kmer-tool

`kmer-tool` is a CLI tool for getting the kmers of a file and writing a csv for them. 

```
Usage: kmer-tool [OPTIONS] <INPUT> <OUTPUT>

Arguments:
  <INPUT>   The file to read from
  <OUTPUT>  The file to write to

Options:
  -f, --force-k  This tool usually doesn't allow for k sizes large than 16, but this flag will allow it
  -k <K>         The size of the kmer to be counted [default: 1]
  -h, --help     Print help
  -V, --version  Print version
```

To build it, clone the repository and run

```bash
cd kmer-tool
cargo build --release
```

Your executable will be in `.target/release`.

## Accuracy estimation

...
