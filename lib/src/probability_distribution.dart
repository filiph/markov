library markov.probability_distribution;

import 'dart:math';

class ProbabilityDistribution<T> {
  final Map<T, int> _records = new Map();
  int total = 0;

  T pick(Random random) {
    int randomNumber = random.nextInt(total);
    int currentIndex = 0;
    for (T key in _records.keys) {
      int currentCount = _records[key];
      if (randomNumber < currentIndex + currentCount) {
        return key;
      }
      currentIndex += currentCount;
    }
    throw new StateError("Total doesn't add up. Make sure to only add new "
        "records through record().");
  }

  void record(T word) {
    _records.putIfAbsent(word, () => 0);
    _records[word] += 1;
    total += 1;
  }
}
