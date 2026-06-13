import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';
import 'package:brain_up/src/l10n/generated/app_localizations_en.dart';
import 'package:brain_up/src/l10n/generated/app_localizations_ru.dart';
import 'package:brain_up/src/l10n/localized_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('localizes generated puzzle content in Russian and English', () {
    final puzzle =
        FoundationCatalog.puzzlesFor(skillTag: SkillTag.pattern).firstWhere(
      (puzzle) => puzzle.payloadRef.startsWith('pattern.trail.easy.'),
    );
    final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.six);
    final russian = AppLocalizationsRu();
    final english = AppLocalizationsEn();

    expect(russian.titleForChallenge(challenge), 'Маршрут закономерности');
    expect(
      russian.questionForChallenge(challenge),
      'Луна, звезда, луна, звезда, ? Что дальше?',
    );
    expect(
      russian.choiceLabelFor(challenge, challenge.correctChoice),
      'Луна',
    );
    expect(russian.localizedSkill(challenge.skill), 'Закономерности');

    expect(english.titleForChallenge(challenge), 'Pattern trail');
    expect(
      english.questionForChallenge(challenge),
      'Moon, star, moon, star, ? What comes next?',
    );
  });
}
