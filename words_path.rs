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

fn get_siblings(from : &String, words : &mut HashSet<String>) -> Vec<String> {
  let mut siblings = Vec::new();

  for i in 0..from.len() {
    for c in ('a' as u8)..('z' as u8) {
      let mut alter : Vec<u8> = from.bytes().collect();
      alter[i] = c;
      let w = String::from_utf8(alter).unwrap();
      if words.remove(&w) {
        siblings.push(w);
      }
    }
  }
  siblings
}

fn bfs(from : &String, to : &String, words : &mut HashSet<String>) -> Vec<String> {
  let mut parent = HashMap::new();
  let mut queue = VecDeque::new();
  queue.push_back(from.clone());

  while queue.len() > 0 && !parent.contains_key(to) {
    let node = queue.pop_front().unwrap();
    let siblings = get_siblings(&node, words);
    for sibling in siblings {
      parent.insert(sibling.clone(), node.clone());
      queue.push_back(sibling.clone());
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
  let mut words = load_dict("/usr/share/dict/words", from.len());
  println!("{:?} -> {:?}", from, to);
  let path = bfs(&from, &to, &mut words);
  println!("{}", path.join(" -> "));
}