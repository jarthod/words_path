use std::env;
use std::fs::File;
use std::io::BufRead;
use std::io::BufReader;
use std::collections::HashSet;
use std::collections::HashMap;
use std::collections::VecDeque;

fn load_dict(path : &str, length : usize) -> HashSet<String> {
  let mut words = HashSet::new();
  let f = File::open(path).unwrap();
  let file = BufReader::new(f);
  for line in file.lines() {
    let l = line.unwrap();
    if l.len() == length {
      words.insert(l.to_lowercase());
    }
  }
  words
}

fn get_siblings(from : &String, words : &HashSet<String>) -> Vec<String> {
  let mut siblings = Vec::new();

  for i in 0..from.len() {
    for c in ('a' as u8)..('z' as u8) {
      let mut alter : Vec<u8> = from.bytes().collect();
      alter[i] = c;
      let w = String::from_utf8(alter).unwrap();
      if c != from.as_bytes()[i] && words.contains(&w) {
        siblings.push(w);
      }
    }
  }
  siblings
}

fn bfs(from : &String, to : &String, words : &HashSet<String>) -> Vec<String> {
  let mut dist = HashMap::new();
  let mut parent = HashMap::new();
  let mut queue = VecDeque::new();
  dist.insert(from.clone(), 0);
  queue.push_back(from.clone());

  while queue.len() > 0 && !dist.contains_key(to) {
    let node = queue.pop_front().unwrap();
    let siblings = get_siblings(&node, words);
    for sibling in siblings {
      if !dist.contains_key(&sibling) {
        let new_dist = dist[&node] + 1;
        dist.insert(sibling.clone(), new_dist);
        parent.insert(sibling.clone(), node.clone());
        queue.push_back(sibling.clone());
      }
    }
  }

  let mut path = Vec::new();
  let mut position = to.to_string();
  path.push(position.clone());
  while parent.contains_key(&position) {
    path.push(parent[&position].clone());
    position = parent[&position].clone();
  }
  path.reverse();
  path
}


fn main() {
  let from = env::args().nth(1).expect("Missing from argument");
  let to = env::args().nth(2).expect("Missing to argument");
  let words = load_dict("/usr/share/dict/words", from.len());
  println!("{:?} -> {:?}", from, to);
  let path = bfs(&from, &to, &words);
  println!("{}", path.join(" -> "));
}