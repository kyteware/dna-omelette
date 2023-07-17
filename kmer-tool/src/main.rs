use std::{fs::File, io::BufReader, path::PathBuf, process::exit};

use clap::Parser;
use csv::Writer;

use kmer_tool::get_kmers;

#[derive(Debug, Parser)]
#[clap(author, version)]
struct Cli {
    /// This tool usually doesn't allow for k sizes large than 16, but this flag will allow it.
    #[clap(short, long)]
    force_k: bool,
    /// The size of the kmer to be counted.
    #[clap(short, default_value = "1")]
    k: usize,
    /// If this option is set, instead of ignoring illegal characters, kmers containing them will 
    /// be removed (this prevents strings that were not actually in the file from showing up in 
    /// the csv).
    #[clap(short, long)]
    hard_skip: bool,
    /// The file to read from.
    #[clap()]
    input: PathBuf,
    /// The file to write to.
    #[clap()]
    output: PathBuf
}

fn main() {
    let cli = Cli::parse();

    let k = cli.k;
    if k > 8 && !cli.force_k {
        eprintln!("K mut be less than or equal to 16. Use the -f flag to ignore this rule");
        exit(1);
    }

    let mut input = BufReader::new(File::open(cli.input).unwrap());
    let kmers = get_kmers(k, &mut input, cli.hard_skip).unwrap();

    let mut output = File::create(cli.output).unwrap();
    let mut writer = Writer::from_writer(&mut output);
    writer.write_record(["item", "count"]).unwrap();
    for (kmer, count) in kmers {
        writer.write_record(&[kmer.iter().collect::<String>(), count.to_string()]).unwrap();
    }
    writer.flush().unwrap();
}
