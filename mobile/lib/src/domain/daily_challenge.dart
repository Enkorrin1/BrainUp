import 'family_profile.dart';

import 'learning_foundation.dart';

class DailyChallenge {
  const DailyChallenge({
    required this.id,
    required this.title,
    required this.prompt,
    required this.question,
    required this.skill,
    required this.goal,
    required this.minutes,
    required this.choices,
    required this.correctChoiceId,
    required this.hint,
    required this.explanation,
    this.interaction,
    this.skillTag,
    this.puzzleType,
    this.difficulty,
    this.worldId,
    this.characterId,
    this.feedbackStyle,
    this.miniGameConfig,
  });

  final String id;
  final String title;
  final String prompt;
  final String question;
  final String skill;
  final LearningGoal goal;
  final int minutes;
  final List<ChallengeChoice> choices;
  final String correctChoiceId;
  final String hint;
  final String explanation;
  final ChallengeInteractionSpec? interaction;
  final SkillTag? skillTag;
  final PuzzleType? puzzleType;
  final PuzzleDifficulty? difficulty;
  final String? worldId;
  final String? characterId;
  final PuzzleFeedbackStyle? feedbackStyle;
  final MiniGameContentConfig? miniGameConfig;

  bool isCorrectChoice(String choiceId) {
    return choiceId == correctChoiceId;
  }

  ChallengeChoice get correctChoice {
    return choices.firstWhere((choice) => choice.id == correctChoiceId);
  }

  DailyChallenge withPuzzleContext(PuzzleDefinition puzzle) {
    final metadata = puzzle.visualMetadata;
    final coach = FoundationCatalog.coachForPuzzle(puzzle);
    final generated = _GeneratedPuzzleData(
      prompt: prompt,
      question: question,
      correctChoiceId: correctChoiceId,
      hint: hint,
      explanation: explanation,
      choices: choices,
    );

    return DailyChallenge(
      id: id,
      title: title,
      prompt: prompt,
      question: question,
      skill: skill,
      goal: goal,
      minutes: minutes,
      choices: choices,
      correctChoiceId: correctChoiceId,
      hint: hint,
      explanation: explanation,
      interaction: interaction ?? _interactionForPuzzle(puzzle, generated),
      skillTag: puzzle.skillTag,
      puzzleType: puzzle.type,
      difficulty: puzzle.difficulty,
      worldId: metadata?.worldId,
      characterId: coach.id,
      feedbackStyle: metadata?.feedbackStyle ?? PuzzleFeedbackStyle.standard,
      miniGameConfig: metadata?.miniGameConfig,
    );
  }
}

class ChallengeInteractionSpec {
  const ChallengeInteractionSpec({
    required this.type,
    required this.instruction,
    this.items = const [],
    this.targets = const [],
    this.correctOrder = const [],
    this.correctMatches = const {},
  });

  final PuzzleInteractionType type;
  final String instruction;
  final List<ChallengeInteractionItem> items;
  final List<ChallengeInteractionTarget> targets;
  final List<String> correctOrder;
  final Map<String, String> correctMatches;

  bool isCorrectOrder(List<String> order) {
    return _sameOrderedStrings(order, correctOrder);
  }

  bool isCorrectMatches(Map<String, String> matches) {
    if (matches.length != correctMatches.length) {
      return false;
    }

    for (final entry in correctMatches.entries) {
      if (matches[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }
}

class ChallengeInteractionItem {
  const ChallengeInteractionItem({
    required this.id,
    required this.label,
    this.assetId,
  });

  final String id;
  final String label;
  final String? assetId;
}

class ChallengeInteractionTarget {
  const ChallengeInteractionTarget({
    required this.id,
    required this.label,
    this.assetId,
  });

  final String id;
  final String label;
  final String? assetId;
}

class ChallengeChoice {
  const ChallengeChoice({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

DailyChallenge dailyChallengeForDate(
  ChildAge age,
  DateTime date, {
  LearningGoal? goal,
}) {
  final challenges = dailyChallengesForAge(age, goal: goal);
  final day = DateTime.utc(date.year, date.month, date.day);
  final firstContentDay = DateTime.utc(2026, 1, 1);
  final daysSinceStart = day.difference(firstContentDay).inDays;

  return challenges[daysSinceStart % challenges.length];
}

List<DailyChallenge> dailyChallengesForAge(
  ChildAge age, {
  LearningGoal? goal,
}) {
  final challenges = _allChallengesForAge(age);
  if (goal == null) {
    return challenges;
  }

  final focusedChallenges = challenges
      .where((challenge) => challenge.goal == goal)
      .toList(growable: false);
  return focusedChallenges.isEmpty ? challenges : focusedChallenges;
}

DailyChallenge dailyChallengeById(String id, {required ChildAge age}) {
  final match = dailyChallengeByIdOrNull(id, age: age);
  if (match != null) {
    return match;
  }

  return _allChallengesForAge(age).first;
}

DailyChallenge? dailyChallengeByIdOrNull(String id, {required ChildAge age}) {
  final ageChallenges = _allChallengesForAge(age);
  final ageMatch = ageChallenges.where((challenge) => challenge.id == id);
  if (ageMatch.isNotEmpty) {
    return ageMatch.first;
  }

  for (final candidateAge in ChildAge.values) {
    final match = _allChallengesForAge(candidateAge)
        .where((challenge) => challenge.id == id);
    if (match.isNotEmpty) {
      return match.first;
    }
  }

  return null;
}

DailyChallenge dailyChallengeForPuzzle(
  PuzzleDefinition puzzle,
  ChildAge age,
) {
  final manualChallenge = dailyChallengeByIdOrNull(puzzle.payloadRef, age: age);
  if (manualChallenge != null) {
    return manualChallenge.withPuzzleContext(puzzle);
  }

  final skill = _skillTitleForPuzzle(puzzle.skillTag);
  final typeTitle = _titleForPuzzleType(puzzle.type);
  final difficulty = _difficultyTitle(puzzle.difficulty);
  final generated = _generatedPuzzleData(puzzle);

  return DailyChallenge(
    id: puzzle.payloadRef,
    title: '$typeTitle: $difficulty',
    prompt: generated.prompt,
    question: generated.question,
    skill: skill,
    goal: _goalForSkill(puzzle.skillTag),
    minutes: _minutesForDifficulty(puzzle.difficulty),
    correctChoiceId: generated.correctChoiceId,
    hint: generated.hint,
    explanation: generated.explanation,
    choices: generated.choices,
    interaction: _interactionForPuzzle(puzzle, generated),
    skillTag: puzzle.skillTag,
    puzzleType: puzzle.type,
    difficulty: puzzle.difficulty,
    worldId: puzzle.visualMetadata?.worldId,
    characterId: FoundationCatalog.coachForPuzzle(puzzle).id,
    feedbackStyle:
        puzzle.visualMetadata?.feedbackStyle ?? PuzzleFeedbackStyle.standard,
    miniGameConfig: puzzle.visualMetadata?.miniGameConfig,
  );
}

List<DailyChallenge> dailyChallengesByIds(
  List<String> ids, {
  required ChildAge age,
}) {
  return [
    for (final id in ids) dailyChallengeById(id, age: age),
  ];
}

String _skillTitleForPuzzle(SkillTag skillTag) {
  return switch (skillTag) {
    SkillTag.attention => 'Focus',
    SkillTag.memory => 'Working memory',
    SkillTag.pattern => 'Patterns',
    SkillTag.classification => 'Classification',
    SkillTag.arithmetic => 'Math thinking',
    SkillTag.spatial => 'Spatial thinking',
    SkillTag.reasoning => 'Logic and deduction',
  };
}

String _titleForPuzzleType(PuzzleType type) {
  return switch (type) {
    PuzzleType.oddOneOut => 'Odd one out',
    PuzzleType.sequenceComplete => 'Pattern trail',
    PuzzleType.pairMatch => 'Pair match',
    PuzzleType.categorySort => 'Sorting',
    PuzzleType.pathPuzzle => 'Route puzzle',
    PuzzleType.countBridge => 'Number bridge',
    PuzzleType.visualCompare => 'Visual compare',
    PuzzleType.analogy => 'Analogy',
    PuzzleType.memoryGrid => 'Memory grid',
    PuzzleType.codeBreaker => 'Code breaker',
    PuzzleType.spatialRotation => 'Shape turn',
    PuzzleType.attentionScan => 'Detail scan',
    PuzzleType.rebus => 'Rebus',
    PuzzleType.mixedBoss => 'Boss puzzle',
  };
}

String _difficultyTitle(PuzzleDifficulty difficulty) {
  return switch (difficulty) {
    PuzzleDifficulty.easy => 'warm-up',
    PuzzleDifficulty.normal => 'level',
    PuzzleDifficulty.hard => 'challenge',
    PuzzleDifficulty.boss => 'final',
  };
}

LearningGoal _goalForSkill(SkillTag skillTag) {
  return switch (skillTag) {
    SkillTag.arithmetic => LearningGoal.math,
    SkillTag.attention || SkillTag.memory => LearningGoal.attention,
    _ => LearningGoal.logic,
  };
}

int _minutesForDifficulty(PuzzleDifficulty difficulty) {
  return switch (difficulty) {
    PuzzleDifficulty.easy => 3,
    PuzzleDifficulty.normal => 4,
    PuzzleDifficulty.hard => 5,
    PuzzleDifficulty.boss => 6,
  };
}

_GeneratedPuzzleData _generatedPuzzleData(PuzzleDefinition puzzle) {
  final variant = _payloadVariant(puzzle.payloadRef);
  return switch (puzzle.type) {
    PuzzleType.sequenceComplete => _patternTrailData(variant),
    PuzzleType.memoryGrid => puzzle.payloadRef.startsWith('memory.order.')
        ? _memoryOrderData(variant)
        : _memoryGridData(variant),
    PuzzleType.countBridge => _mathBridgeData(variant),
    PuzzleType.attentionScan => _focusDetailsData(variant),
    PuzzleType.codeBreaker => _logicCodeData(variant),
    PuzzleType.spatialRotation => _spaceTurnData(variant),
    PuzzleType.oddOneOut => _sortOddData(variant),
    PuzzleType.categorySort => _categoryGroupData(variant),
    PuzzleType.pathPuzzle => _routePathData(variant),
    PuzzleType.analogy => _analogyLinkData(variant),
    PuzzleType.rebus => _rebusPictureData(variant),
    PuzzleType.visualCompare => puzzle.payloadRef.startsWith('compare.weight.')
        ? _compareWeightData(variant)
        : _fallbackPuzzleData(puzzle),
    PuzzleType.mixedBoss => _mixedBossData(variant),
    _ => _fallbackPuzzleData(puzzle),
  };
}

ChallengeInteractionSpec? _interactionForPuzzle(
  PuzzleDefinition puzzle,
  _GeneratedPuzzleData generated,
) {
  final metadata = puzzle.visualMetadata;
  if (metadata == null) {
    return null;
  }
  if (metadata.interactionType == PuzzleInteractionType.tapChoice &&
      metadata.miniGameConfig == null) {
    return null;
  }

  final items = _interactionItemsFor(generated, metadata);
  return switch (metadata.interactionType) {
    PuzzleInteractionType.tapChoice => ChallengeInteractionSpec(
        type: PuzzleInteractionType.tapChoice,
        instruction: 'Choose the answer directly on the scene.',
        items: items,
        correctMatches: {
          'tap.answer': generated.correctChoiceId,
        },
      ),
    PuzzleInteractionType.dragToTarget => ChallengeInteractionSpec(
        type: PuzzleInteractionType.dragToTarget,
        instruction: 'Drag the best answer into the active spot.',
        items: items,
        targets: const [
          ChallengeInteractionTarget(
            id: 'target.answer',
            label: 'Answer spot',
          ),
        ],
        correctMatches: {
          generated.correctChoiceId: 'target.answer',
        },
      ),
    PuzzleInteractionType.reorderCards => ChallengeInteractionSpec(
        type: PuzzleInteractionType.reorderCards,
        instruction: 'Place the cards in the correct order.',
        items: items,
        correctOrder: items.map((item) => item.id).toList(growable: false),
      ),
    PuzzleInteractionType.matchPairs => ChallengeInteractionSpec(
        type: PuzzleInteractionType.matchPairs,
        instruction: 'Connect the clue with its matching answer.',
        items: [
          ChallengeInteractionItem(
            id: 'clue.${puzzle.payloadRef}',
            label: _clueLabelForQuestion(generated.question),
            assetId: metadata.sceneAsset,
          ),
          ...items,
        ],
        correctMatches: {
          'clue.${puzzle.payloadRef}': generated.correctChoiceId,
        },
      ),
    PuzzleInteractionType.memoryReveal => ChallengeInteractionSpec(
        type: PuzzleInteractionType.memoryReveal,
        instruction: 'Reveal the cards, remember the order, then answer.',
        items: items,
        correctOrder: items.map((item) => item.id).toList(growable: false),
        correctMatches: {
          'memory.answer': generated.correctChoiceId,
        },
      ),
    PuzzleInteractionType.tracePath => ChallengeInteractionSpec(
        type: PuzzleInteractionType.tracePath,
        instruction: 'Trace the route and land on the correct endpoint.',
        items: items,
        targets: const [
          ChallengeInteractionTarget(
            id: 'target.endpoint',
            label: 'Endpoint',
          ),
        ],
        correctMatches: {
          generated.correctChoiceId: 'target.endpoint',
        },
      ),
    PuzzleInteractionType.rotateObject => ChallengeInteractionSpec(
        type: PuzzleInteractionType.rotateObject,
        instruction: 'Rotate the object in your head before choosing.',
        items: items,
        correctMatches: {
          'rotation.answer': generated.correctChoiceId,
        },
      ),
    PuzzleInteractionType.sortObjects => ChallengeInteractionSpec(
        type: PuzzleInteractionType.sortObjects,
        instruction: 'Move the item into the matching basket.',
        items: items,
        targets: const [
          ChallengeInteractionTarget(
            id: 'target.match',
            label: 'Fits',
          ),
          ChallengeInteractionTarget(
            id: 'target.other',
            label: 'Does not fit',
          ),
        ],
        correctMatches: {
          generated.correctChoiceId: 'target.match',
        },
      ),
    PuzzleInteractionType.multiStepBoss => ChallengeInteractionSpec(
        type: PuzzleInteractionType.multiStepBoss,
        instruction: 'Solve each clue, then submit the boss answer.',
        items: items,
        correctMatches: {
          'boss.answer': generated.correctChoiceId,
        },
      ),
  };
}

List<ChallengeInteractionItem> _interactionItemsFor(
  _GeneratedPuzzleData generated,
  VisualPuzzleMetadata metadata,
) {
  return [
    for (var index = 0; index < generated.choices.length; index += 1)
      ChallengeInteractionItem(
        id: generated.choices[index].id,
        label: generated.choices[index].label,
        assetId: _choiceAssetForChoiceId(generated.choices[index].id) ??
            _choiceAssetAt(metadata.choiceAssets, index),
      ),
  ];
}

String? _choiceAssetForChoiceId(String choiceId) {
  final key = choiceId.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  if (key.contains('apple')) return 'object.apple';
  if (key.contains('pear')) return 'object.pear';
  if (key.contains('banana')) return 'object.banana';
  if (key.contains('ball')) return 'object.ball';
  if (key.contains('rocket')) return 'object.rocket';
  if (key.contains('planet')) return 'object.planet';
  if (key.contains('star')) return 'object.star';
  if (key.contains('moon')) return 'object.moon';
  if (key.contains('sun')) return 'object.sun';
  if (key.contains('rain') || key.contains('water')) return 'object.rain';
  if (key.contains('flower')) return 'object.flower';
  if (key.contains('fish')) return 'object.fish';
  if (key.contains('foot')) return 'object.foot';
  if (key.contains('leaf') || key.contains('carrot')) return 'object.leaf';
  if (key.contains('lock')) return 'object.lock';
  if (key.contains('key')) return 'object.key';
  if (key.contains('shoe')) return 'object.shoe';
  if (key.contains('cloud')) return 'object.cloud';
  if (key.contains('circle')) return 'object.circle';
  if (key.contains('square')) return 'object.square';
  if (key.contains('triangle')) return 'object.triangle';
  if (key.contains('cube') || key.contains('block')) return 'object.cube';
  return null;
}

String? _choiceAssetAt(List<String> assets, int index) {
  if (assets.isEmpty) {
    return null;
  }

  return assets[index % assets.length];
}

String _clueLabelForQuestion(String question) {
  final pairCue = question.indexOf(' goes with');
  if (pairCue > 0) {
    return question.substring(0, pairCue);
  }

  final ellipsisCue = question.indexOf('...');
  if (ellipsisCue > 0) {
    return question.substring(0, ellipsisCue).trim();
  }

  return 'Clue';
}

int _payloadVariant(String payloadRef) {
  final parts = payloadRef.split('.');
  return int.tryParse(parts.last) ?? 1;
}

_GeneratedPuzzleData _patternTrailData(int variant) {
  final options = [
    ('moon, star, moon, star, ?', 'moon', ['moon', 'star', 'rocket']),
    ('red, blue, red, blue, ?', 'red', ['green', 'red', 'blue']),
    ('2, 4, 2, 4, ?', '2', ['2', '4', '6']),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Find the repeating rule.',
    question: '${data.$1} What comes next?',
    correctChoiceId: data.$2,
    hint: 'Look for the smallest group that repeats.',
    explanation: 'The answer keeps the same repeating pattern.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _memoryGridData(int variant) {
  final options = [
    ('Key goes with...', 'lock', ['lock', 'cloud', 'shoe']),
    ('Rain goes with...', 'cloud', ['shoe', 'cloud', 'key']),
    ('Foot goes with...', 'shoe', ['lock', 'shoe', 'star']),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Remember the matching pair.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Think about which two objects are used together.',
    explanation: 'The correct pair has a real connection.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _mathBridgeData(int variant) {
  final options = [
    ('Make 8 using two parts.', '5+3', ['5+3', '4+1', '6+1']),
    ('Make 9 using two parts.', '4+5', ['3+4', '4+5', '2+6']),
    ('Make 10 using two parts.', '7+3', ['7+3', '5+2', '6+2']),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Build the target number.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Add both parts and compare with the target.',
    explanation: 'Only the correct pair reaches the target number.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _focusDetailsData(int variant) {
  final options = [
    (
      '3 red circles, 2 blue squares, 1 green star. Most?',
      'red circles',
      ['blue squares', 'red circles', 'green star']
    ),
    (
      '2 rockets, 4 planets, 3 stars. Most?',
      'planets',
      ['rockets', 'stars', 'planets']
    ),
    (
      '5 small dots, 3 big dots, 4 lines. Most?',
      'small dots',
      ['big dots', 'small dots', 'lines']
    ),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Scan the details carefully.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Compare the counts one group at a time.',
    explanation: 'The correct group has the largest count.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _logicCodeData(int variant) {
  final options = [
    ('2 -> 4, 3 -> 6, 5 -> ?', '10', ['8', '10', '12']),
    ('1 -> 3, 2 -> 4, 6 -> ?', '8', ['7', '8', '9']),
    ('9 -> 6, 7 -> 4, 5 -> ?', '2', ['2', '3', '4']),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Break the number code.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Find what changes from left to right.',
    explanation: 'The same rule is applied to every number.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _spaceTurnData(int variant) {
  final options = [
    (
      'A triangle turns right. What stays true?',
      'same shape',
      ['same shape', 'circle', 'square']
    ),
    (
      'A rocket turns upside down. What is it still?',
      'rocket',
      ['planet', 'rocket', 'star']
    ),
    (
      'A square spins once. What changes?',
      'direction only',
      ['size', 'direction only', 'shape type']
    ),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Imagine the object turning.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'A turn changes direction, not the object identity.',
    explanation: 'The object keeps its shape after rotation.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _sortOddData(int variant) {
  final options = [
    ('apple, pear, banana, rocket', 'rocket', ['apple', 'rocket', 'pear']),
    ('circle, square, triangle, shoe', 'shoe', ['shoe', 'circle', 'square']),
    ('lock, key, door, banana', 'banana', ['key', 'banana', 'lock']),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Find what does not belong.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Three items share one idea. One does not.',
    explanation: 'The odd item breaks the group rule.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _categoryGroupData(int variant) {
  final options = [
    (
      'Carrot, apple, pear. Which group fits?',
      'food',
      ['food', 'toys', 'space']
    ),
    (
      'Circle, square, triangle. Which group fits?',
      'shapes',
      ['animals', 'shapes', 'numbers']
    ),
    (
      'Rocket, planet, star. Which group fits?',
      'space',
      ['clothes', 'food', 'space']
    ),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Sort by the shared idea.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Find what all three items have in common.',
    explanation: 'The correct group names the shared category.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _routePathData(int variant) {
  final options = [
    (
      'Follow: right, right, up. Which endpoint do you reach?',
      'star',
      ['moon', 'star', 'cloud']
    ),
    (
      'The safe route avoids lava and crosses water. Which tile helps?',
      'bridge',
      ['bridge', 'rock', 'lava']
    ),
    (
      'A robot moves 2 forward and 1 left. What marker is at the end?',
      'flag',
      ['flag', 'tree', 'door']
    ),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Trace the route in your head.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Move one step at a time and keep your place.',
    explanation: 'The right answer is where the full route ends.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _analogyLinkData(int variant) {
  final options = [
    ('Bird is to sky as fish is to...', 'water', ['water', 'tree', 'sand']),
    ('Day is to sun as night is to...', 'moon', ['cloud', 'moon', 'rain']),
    ('Hand is to glove as foot is to...', 'shoe', ['shoe', 'hat', 'key']),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Complete the relationship.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Say how the first pair is connected, then reuse that idea.',
    explanation: 'The correct answer keeps the same relationship.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _rebusPictureData(int variant) {
  final options = [
    (
      'Sun + flower makes...',
      'sunflower',
      ['sunflower', 'rainbow', 'starfish']
    ),
    ('Rain + bow makes...', 'rainbow', ['moonlight', 'rainbow', 'sunflower']),
    ('Star + fish makes...', 'starfish', ['starfish', 'sunflower', 'snowball']),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Combine two picture clues into one word.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Join the two clue words together.',
    explanation: 'The answer is made by combining both clues.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _compareWeightData(int variant) {
  final options = [
    (
      'Two apples balance one pear. Which is heavier?',
      'pear',
      ['apple', 'pear', 'same']
    ),
    (
      'Left has 3 stars, right has 2 stars. Which side wins?',
      'left',
      ['left', 'right', 'same']
    ),
    (
      'One big cube equals how many small cubes?',
      '3 small cubes',
      ['2 small cubes', '3 small cubes', '4 small cubes']
    ),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Compare both sides carefully.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Look at the amount or balance on each side.',
    explanation: 'The correct choice matches the comparison rule.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _memoryOrderData(int variant) {
  final options = [
    (
      'Remember: rocket, star, planet. What was second?',
      'star',
      ['rocket', 'star', 'planet']
    ),
    (
      'Remember: red, blue, green. What was first?',
      'red',
      ['green', 'red', 'blue']
    ),
    (
      'Remember: key, cloud, shoe. What was third?',
      'shoe',
      ['key', 'shoe', 'cloud']
    ),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Hold the order in memory.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Repeat the list once, then point to the requested place.',
    explanation: 'The answer is the item in the requested position.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _mixedBossData(int variant) {
  final options = [
    ('Pattern + math: 2, 4, 6, ? and target is even.', '8', ['7', '8', '9']),
    (
      'Memory + logic: key pairs with lock, shoe pairs with ?',
      'foot',
      ['cloud', 'foot', 'planet']
    ),
    (
      'Focus + sorting: 4 stars, 2 stars, 3 circles. Choose most stars.',
      '4 stars',
      ['2 stars', '3 circles', '4 stars']
    ),
  ];
  final data = options[(variant - 1) % options.length];
  return _GeneratedPuzzleData(
    prompt: 'Boss puzzle: combine two rules.',
    question: data.$1,
    correctChoiceId: data.$2,
    hint: 'Solve the first rule, then check the second clue.',
    explanation: 'Boss puzzles ask you to combine skills, not guess.',
    choices: _choices(data.$3),
  );
}

_GeneratedPuzzleData _fallbackPuzzleData(PuzzleDefinition puzzle) {
  return _GeneratedPuzzleData(
    prompt: 'Solve a short BrainUp puzzle.',
    question:
        'Choose the best answer for ${_skillTitleForPuzzle(puzzle.skillTag)}.',
    correctChoiceId: puzzle.correctAnswerKey,
    hint: 'Find the rule before choosing.',
    explanation: 'The correct answer follows the puzzle rule.',
    choices: _choices([puzzle.correctAnswerKey, 'almost', 'different']),
  );
}

List<ChallengeChoice> _choices(List<String> orderedIds) {
  return [
    for (final id in orderedIds)
      ChallengeChoice(id: id, label: _choiceText(id)),
  ];
}

String _choiceText(String id) {
  return id
      .split(RegExp(r'[-_]'))
      .map((part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

bool _sameOrderedStrings(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
}

class _GeneratedPuzzleData {
  const _GeneratedPuzzleData({
    required this.prompt,
    required this.question,
    required this.correctChoiceId,
    required this.hint,
    required this.explanation,
    required this.choices,
  });

  final String prompt;
  final String question;
  final String correctChoiceId;
  final String hint;
  final String explanation;
  final List<ChallengeChoice> choices;
}

List<DailyChallenge> _allChallengesForAge(ChildAge age) {
  switch (age) {
    case ChildAge.four:
    case ChildAge.five:
      return const [
        DailyChallenge(
          id: 'shape-path',
          title: 'Дорожка фигур',
          prompt: 'Посмотри на ряд и найди, что должно идти дальше.',
          question: 'Круг, квадрат, круг, квадрат. Что дальше?',
          skill: 'Закономерности',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'circle',
          hint: 'Фигуры чередуются: одна, потом другая, потом снова первая.',
          explanation:
              'После квадрата снова идет круг, потому что ряд повторяется через одну фигуру.',
          choices: [
            ChallengeChoice(id: 'triangle', label: 'Треугольник'),
            ChallengeChoice(id: 'circle', label: 'Круг'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
          ],
        ),
        DailyChallenge(
          id: 'toy-count',
          title: 'Сколько игрушек',
          prompt: 'Посчитай предметы и выбери точный ответ.',
          question: 'На полке 2 кубика и 1 мяч. Сколько игрушек всего?',
          skill: 'Счет до пяти',
          goal: LearningGoal.math,
          minutes: 3,
          correctChoiceId: '3',
          hint: 'Сначала посчитай кубики, потом добавь мяч.',
          explanation: '2 кубика и 1 мяч дают 3 игрушки всего.',
          choices: [
            ChallengeChoice(id: '2', label: '2'),
            ChallengeChoice(id: '3', label: '3'),
            ChallengeChoice(id: '4', label: '4'),
          ],
        ),
        DailyChallenge(
          id: 'odd-card',
          title: 'Лишняя карточка',
          prompt: 'Найди предмет, который отличается от остальных.',
          question: 'Яблоко, груша, мяч, банан. Что лишнее?',
          skill: 'Сравнение',
          goal: LearningGoal.attention,
          minutes: 3,
          correctChoiceId: 'ball',
          hint: 'Три предмета можно съесть, а один нужен для игры.',
          explanation: 'Мяч лишний: яблоко, груша и банан - это фрукты.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Яблоко'),
            ChallengeChoice(id: 'ball', label: 'Мяч'),
            ChallengeChoice(id: 'banana', label: 'Банан'),
          ],
        ),
        DailyChallenge(
          id: 'fruit-pattern',
          title: 'Fruit row',
          prompt: 'Continue the fruit pattern.',
          question: 'Apple, banana, apple, banana. What comes next?',
          skill: 'Р—Р°РєРѕРЅРѕРјРµСЂРЅРѕСЃС‚Рё',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'apple',
          hint: 'The fruits repeat one by one: apple, then banana.',
          explanation:
              'After banana comes apple again, because the pattern repeats.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Apple'),
            ChallengeChoice(id: 'banana', label: 'Banana'),
            ChallengeChoice(id: 'pear', label: 'Pear'),
          ],
        ),
        DailyChallenge(
          id: 'shadow-match',
          title: 'Подбери тень',
          prompt: 'Найди предмет, который подходит к тени.',
          question: 'У тени высокий корпус и два маленьких крыла. Что это?',
          skill: 'Пространственное мышление',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'rocket',
          hint: 'Смотри на общий контур предмета.',
          explanation:
              'Ракета подходит к тени: у нее высокий корпус и два боковых крыла.',
          choices: [
            ChallengeChoice(id: 'rocket', label: 'Ракета'),
            ChallengeChoice(id: 'planet', label: 'Планета'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
          ],
        ),
      ];
    case ChildAge.six:
      return const [
        DailyChallenge(
          id: 'logic-train',
          title: 'Логический поезд',
          prompt: 'Расставь вагоны по правилу.',
          question:
              'Красный, синий, синий, красный, синий, синий. Какой следующий?',
          skill: 'Последовательности',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'red',
          hint: 'Правило повторяется тройками: один красный и два синих.',
          explanation:
              'Следующий вагон красный: после двух синих начинается новая тройка.',
          choices: [
            ChallengeChoice(id: 'blue', label: 'Синий'),
            ChallengeChoice(id: 'red', label: 'Красный'),
            ChallengeChoice(id: 'green', label: 'Зеленый'),
          ],
        ),
        DailyChallenge(
          id: 'sticker-sum',
          title: 'Наклейки в альбоме',
          prompt: 'Сложи две маленькие группы предметов.',
          question: 'У Ники было 3 наклейки, потом дали еще 2. Сколько стало?',
          skill: 'Сложение до десяти',
          goal: LearningGoal.math,
          minutes: 4,
          correctChoiceId: '5',
          hint: 'Начни с трех и досчитай еще два шага.',
          explanation: '3 + 2 = 5, значит стало пять наклеек.',
          choices: [
            ChallengeChoice(id: '4', label: '4'),
            ChallengeChoice(id: '5', label: '5'),
            ChallengeChoice(id: '6', label: '6'),
          ],
        ),
        DailyChallenge(
          id: 'memory-pairs',
          title: 'Пары по памяти',
          prompt: 'Вспомни пару для каждого предмета.',
          question: 'Что подходит к ключу?',
          skill: 'Рабочая память',
          goal: LearningGoal.attention,
          minutes: 4,
          correctChoiceId: 'lock',
          hint: 'Ключ нужен, чтобы что-то открыть.',
          explanation:
              'К ключу подходит замок: вместе они образуют смысловую пару.',
          choices: [
            ChallengeChoice(id: 'lock', label: 'Замок'),
            ChallengeChoice(id: 'shoe', label: 'Ботинок'),
            ChallengeChoice(id: 'cloud', label: 'Облако'),
          ],
        ),
        DailyChallenge(
          id: 'lock-key',
          title: 'Magic pair',
          prompt: 'Choose the object that makes a pair.',
          question: 'A key opens something. What does it go with?',
          skill: 'Р Р°Р±РѕС‡Р°СЏ РїР°РјСЏС‚СЊ',
          goal: LearningGoal.attention,
          minutes: 4,
          correctChoiceId: 'lock',
          hint: 'Think about what a key is used for.',
          explanation: 'A key and a lock work together, so they form the pair.',
          choices: [
            ChallengeChoice(id: 'lock', label: 'Lock'),
            ChallengeChoice(id: 'shoe', label: 'Shoe'),
            ChallengeChoice(id: 'cloud', label: 'Cloud'),
          ],
        ),
        DailyChallenge(
          id: 'balance-scale',
          title: 'Весы',
          prompt: 'Сравни стороны и выбери, чего не хватает.',
          question: 'Слева 2 яблока. Справа 1 яблоко и ?. Что добавить?',
          skill: 'Сравнение',
          goal: LearningGoal.math,
          minutes: 5,
          correctChoiceId: 'apple',
          hint: 'На обеих сторонах должно быть одинаковое количество яблок.',
          explanation:
              'Еще одно яблоко делает правую сторону равной левой: 2 и 2.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Яблоко'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
            ChallengeChoice(id: 'ball', label: 'Мяч'),
          ],
        ),
      ];
    case ChildAge.seven:
    case ChildAge.eight:
      return const [
        DailyChallenge(
          id: 'code-grid',
          title: 'Кодовая сетка',
          prompt: 'Разгадай правило и выбери правильную клетку.',
          question:
              'В первой строке 2, 4, 6. Во второй 3, 5, ?. Какое число пропущено?',
          skill: 'Логика и дедукция',
          goal: LearningGoal.logic,
          minutes: 6,
          correctChoiceId: '7',
          hint: 'Во второй строке числа тоже растут на 2.',
          explanation:
              'После 3 и 5 идет 7: каждый шаг увеличивает число на два.',
          choices: [
            ChallengeChoice(id: '6', label: '6'),
            ChallengeChoice(id: '7', label: '7'),
            ChallengeChoice(id: '8', label: '8'),
          ],
        ),
        DailyChallenge(
          id: 'number-bridge',
          title: 'Числовой мост',
          prompt: 'Соедини числа так, чтобы получить нужный маршрут.',
          question: 'У тебя есть 4, 2 и 1. Как получить 7?',
          skill: 'Математическое мышление',
          goal: LearningGoal.math,
          minutes: 5,
          correctChoiceId: '4+2+1',
          hint: 'Попробуй использовать все числа один раз.',
          explanation:
              '4 + 2 + 1 = 7, значит все три числа вместе дают нужный результат.',
          choices: [
            ChallengeChoice(id: '4+2+1', label: '4 + 2 + 1'),
            ChallengeChoice(id: '4+1', label: '4 + 1'),
            ChallengeChoice(id: '2+1', label: '2 + 1'),
          ],
        ),
        DailyChallenge(
          id: 'detail-count',
          title: 'Карта деталей',
          prompt: 'Удержи в голове несколько деталей и сравни их.',
          question:
              'Есть 3 красных круга, 2 синих квадрата и 1 зеленая звезда. Чего больше всего?',
          skill: 'Сравнение деталей',
          goal: LearningGoal.attention,
          minutes: 5,
          correctChoiceId: 'red-circles',
          hint: 'Сравни количества: 3, 2 и 1.',
          explanation: 'Больше всего красных кругов: их три.',
          choices: [
            ChallengeChoice(id: 'blue-squares', label: 'Синих квадратов'),
            ChallengeChoice(id: 'red-circles', label: 'Красных кругов'),
            ChallengeChoice(id: 'green-stars', label: 'Зеленых звезд'),
          ],
        ),
        DailyChallenge(
          id: 'shape-rotation',
          title: 'Поворот фигуры',
          prompt: 'Представь, как фигура поворачивается.',
          question:
              'Треугольник повернули вправо. Какая карточка показывает ту же фигуру?',
          skill: 'Пространственное мышление',
          goal: LearningGoal.logic,
          minutes: 6,
          correctChoiceId: 'same',
          hint: 'Поворот меняет направление, но не саму фигуру.',
          explanation:
              'Это тот же треугольник: он повернулся, но не стал другой фигурой.',
          choices: [
            ChallengeChoice(id: 'same', label: 'Тот же треугольник'),
            ChallengeChoice(id: 'circle', label: 'Круг'),
            ChallengeChoice(id: 'square', label: 'Квадрат'),
          ],
        ),
        DailyChallenge(
          id: 'space-sequence',
          title: 'Space route',
          prompt: 'Find the next space object.',
          question: 'Rocket, planet, rocket, planet. What comes next?',
          skill: 'РџРѕСЃР»РµРґРѕРІР°С‚РµР»СЊРЅРѕСЃС‚Рё',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'rocket',
          hint: 'The route repeats: rocket, then planet.',
          explanation: 'After the planet comes a rocket again.',
          choices: [
            ChallengeChoice(id: 'rocket', label: 'Rocket'),
            ChallengeChoice(id: 'planet', label: 'Planet'),
            ChallengeChoice(id: 'star', label: 'Star'),
          ],
        ),
        DailyChallenge(
          id: 'shape-stack',
          title: 'Shape tower',
          prompt: 'Continue the tower rule.',
          question: 'Square, circle, square, circle. Which shape is next?',
          skill: 'РџСЂРѕСЃС‚СЂР°РЅСЃС‚РІРµРЅРЅРѕРµ РјС‹С€Р»РµРЅРёРµ',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'square',
          hint: 'The tower alternates between two shapes.',
          explanation: 'After a circle comes a square again.',
          choices: [
            ChallengeChoice(id: 'square', label: 'Square'),
            ChallengeChoice(id: 'circle', label: 'Circle'),
            ChallengeChoice(id: 'triangle', label: 'Triangle'),
          ],
        ),
      ];
  }
}
