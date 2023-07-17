use std::{io::{Read, BufReader}, collections::HashMap};

use utf8_chars::BufReadCharsExt;

const ILLEGAL_CHARS: [char; 1] = ['\n'];

type Kmers = HashMap<Vec<char>, u32>;

pub fn get_kmers<R: Read>(k: usize, seq: &mut BufReader<R>) -> Result<Kmers, KmerError> {
    let mut kmers: Kmers = HashMap::new();
    let mut kmer: Vec<char> = Vec::with_capacity(k);
    let mut chars = seq.chars().map(|c| c.unwrap());

    // make the first element of kmer empty to allow being slid left
    kmer.push(' ');
    // fill kmer with first k chars
    kmer.append(&mut chars.by_ref().take(k-1).collect());
    if kmer.len() < k {
        return Err(KmerError::NotEnoughChars);
    }

    // iterate over the rest of the chars
    'outer: for c in chars {
        kmer.rotate_left(1);
        kmer[k-1] = c;
        for temp in &kmer {
            if ILLEGAL_CHARS.contains(temp) {
                continue 'outer;
            }
        }
        let count = kmers.entry(kmer.clone()).or_insert(0);
        *count += 1;
    }

    if kmers.len() == 0 {
        return Err(KmerError::NotEnoughChars);
    }

    Ok(kmers)
}

#[derive(Debug)]
pub enum KmerError {
    NotEnoughChars,
}