#include <algorithm>
#include <iterator>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <set>
#include <map>
#include <queue>

using namespace std;

set<string> load_dict(const char *path, const int length)
{
  set<string> words;
  ifstream    file;
  string      word;

  file.open(path);
  while (file >> word) {
    if (word.length() == length) {
      transform(word.begin(), word.end(), word.begin(), ::tolower);
      words.insert(word);
    }
  }
  return words;
}

vector<string> get_siblings(const string &from, set<string> &words)
{
  vector<string> siblings;

  for (int i = 0; i < from.length(); i++) {
    string alter = from;
    for (char c = 'a'; c <= 'z'; c++) {
      alter[i] = c;
      if (c != from[i] && words.erase(alter) >= 1) {
        siblings.push_back(alter);
      }
    }
  }
  return siblings;
}

vector<string> bfs(const string &from, const string &to, set<string> &words)
{
  map<string, string> parent;
  queue<string> queue;
  queue.push(from);

  while (queue.size() > 0 && parent.count(to) == 0) {
    string node = queue.front();
    vector<string> siblings = get_siblings(node, words);
    queue.pop();
    for(int i = 0; i < siblings.size(); i++) {
      parent[siblings[i]] = node;
      queue.push(siblings[i]);
    }
  }

  vector<string> path;
  string position = to;
  path.push_back(position);
  while (parent.count(position) > 0) {
    path.insert(path.begin(), parent[position]);
    position = parent[position];
  }
  return path;
}

int main(int ac, char **av)
{
  if (ac < 3) {
    cerr << "Usage: ./words_path jina pray" << endl;
    return 1;
  }
  string from = av[1];
  string to = av[2];
  set<string> words = load_dict("/usr/share/dict/words", from.length());
  vector<string> path = bfs(from, to, words);
  for(int i = 0; i < path.size(); i++) {
    if (i > 0) {
      cout << " -> ";
    }
    cout << path[i];
  }
  cout << endl;
  return 0;
}