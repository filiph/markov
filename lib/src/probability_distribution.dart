library markov.probability_distribution;

import 'dart:math';

/// A probability distribution of instances of type [T].
class ProbabilityDistribution<T> {
  final _records = <T, int>{};

  int _total = 0;

  /// Total number of instances of type [T] that have been recorded
  /// via [record].
  int get total => _total;

  /// Picks a random instance of type [T] according to the probability
  /// distribution.
  T pick(Random random) {
    final randomNumber = random.nextInt(_total);
    var currentIndex = 0;
    for (final key in _records.keys) {
      final currentCount = _records[key];
      if (randomNumber < currentIndex + currentCount) {
        return key;
      }
      currentIndex += currentCount;
    }
    throw new StateError("Total doesn't add up. Make sure to only add new "
        'records through record().');
  }

  /// Add an instance of type [T].
  void record(T word, {int count: 1}) {
    _records.putIfAbsent(word, () => 0);
    _records[word] += count;
    _total += count;
  }
}
