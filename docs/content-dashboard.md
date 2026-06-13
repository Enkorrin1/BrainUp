# BrainUp Content Dashboard

## Summary

| Metric | Value |
| --- | ---: |
| Total puzzles | 216 |
| Visual puzzles | 200 |
| Visual coverage | 93% |
| Quality gate passes | true |
| Blocking issues | false |

## Coverage By Age

| Name | Count |
| --- | ---: |
| age4to5 | 130 |
| age6 | 201 |
| age7to8 | 158 |

## Coverage By Skill

| Name | Count |
| --- | ---: |
| attention | 24 |
| memory | 30 |
| pattern | 23 |
| classification | 29 |
| arithmetic | 37 |
| spatial | 31 |
| reasoning | 42 |

## Coverage By Type

| Name | Count |
| --- | ---: |
| oddOneOut | 15 |
| sequenceComplete | 24 |
| pairMatch | 2 |
| categorySort | 14 |
| pathPuzzle | 14 |
| countBridge | 17 |
| visualCompare | 24 |
| analogy | 9 |
| memoryGrid | 28 |
| codeBreaker | 9 |
| spatialRotation | 14 |
| attentionScan | 23 |
| rebus | 9 |
| mixedBoss | 14 |

## Coverage By Difficulty

| Name | Count |
| --- | ---: |
| easy | 72 |
| normal | 71 |
| hard | 58 |
| boss | 15 |

## Placement Rules

| Placement | Min | Default | Max |
| --- | ---: | ---: | ---: |
| mainRoute | 5 | 5 | 5 |
| dailyChallenge | 1 | 1 | 1 |
| adaptiveReview | 3 | 5 | 5 |
| bossNode | 6 | 7 | 8 |
| mistakeRepeat | 1 | 2 | 3 |
| parentAnalytics | 0 | 0 | 0 |
| rewardCollection | 1 | 1 | 1 |
| ageTrack | 5 | 5 | 5 |
| weakSkillRecommendation | 3 | 4 | 5 |

## Coverage Issues

- Skill gaps: 0 (OK)
- Low type coverage: 0 (OK)
- Puzzles without assets: 16 (Needs review)
- Puzzles without hints: 0 (OK)

## Repeated Families

| Family | Count | Examples |
| --- | ---: | --- |
| analogy.link | 9 | analogy.link.easy.001, analogy.link.easy.002, analogy.link.normal.003, analogy.link.normal.004 |
| category.groups | 9 | category.groups.easy.001, category.groups.easy.002, category.groups.normal.003, category.groups.normal.004 |
| compare.weight | 9 | compare.weight.easy.001, compare.weight.easy.002, compare.weight.normal.003, compare.weight.normal.004 |
| focus.details | 9 | focus.details.easy.001, focus.details.easy.002, focus.details.normal.003, focus.details.normal.004 |
| focus.tracker | 9 | focus.tracker.easy.001, focus.tracker.easy.002, focus.tracker.normal.003, focus.tracker.normal.004 |
| logic.code | 9 | logic.code.easy.001, logic.code.easy.002, logic.code.normal.003, logic.code.normal.004 |
| math.bridge | 9 | math.bridge.easy.001, math.bridge.easy.002, math.bridge.normal.003, math.bridge.normal.004 |
| memory.order | 9 | memory.order.easy.001, memory.order.easy.002, memory.order.normal.003, memory.order.normal.004 |
| memory.pairs | 9 | memory.pairs.easy.001, memory.pairs.easy.002, memory.pairs.normal.003, memory.pairs.normal.004 |
| mixed.boss | 9 | mixed.boss.easy.001, mixed.boss.easy.002, mixed.boss.normal.003, mixed.boss.normal.004 |
| pattern.trail | 9 | pattern.trail.easy.001, pattern.trail.easy.002, pattern.trail.normal.003, pattern.trail.normal.004 |
| rebus.picture | 9 | rebus.picture.easy.001, rebus.picture.easy.002, rebus.picture.normal.003, rebus.picture.normal.004 |
| route.path | 9 | route.path.easy.001, route.path.easy.002, route.path.normal.003, route.path.normal.004 |
| sort.odd | 9 | sort.odd.easy.001, sort.odd.easy.002, sort.odd.normal.003, sort.odd.normal.004 |
| space.turn | 9 | space.turn.easy.001, space.turn.easy.002, space.turn.normal.003, space.turn.normal.004 |
| curated.group-compare | 5 | curated.group-compare.001, curated.group-compare.002, curated.group-compare.003, curated.group-compare.004 |
| curated.logic-scales | 5 | curated.logic-scales.001, curated.logic-scales.002, curated.logic-scales.003, curated.logic-scales.004 |
| curated.memory-order | 5 | curated.memory-order.001, curated.memory-order.002, curated.memory-order.003, curated.memory-order.004 |
| curated.mixed-boss | 5 | curated.mixed-boss.001, curated.mixed-boss.002, curated.mixed-boss.003, curated.mixed-boss.004 |
| curated.object-count | 5 | curated.object-count.001, curated.object-count.002, curated.object-count.003, curated.object-count.004 |
| curated.object-sort | 5 | curated.object-sort.001, curated.object-sort.002, curated.object-sort.003, curated.object-sort.004 |
| curated.odd-one-out | 5 | curated.odd-one-out.001, curated.odd-one-out.002, curated.odd-one-out.003, curated.odd-one-out.004 |
| curated.pair-match | 5 | curated.pair-match.001, curated.pair-match.002, curated.pair-match.003, curated.pair-match.004 |
| curated.route-build | 5 | curated.route-build.001, curated.route-build.002, curated.route-build.003, curated.route-build.004 |
| curated.rule-detect | 5 | curated.rule-detect.001, curated.rule-detect.002, curated.rule-detect.003, curated.rule-detect.004 |
| curated.sequence-complete | 5 | curated.sequence-complete.001, curated.sequence-complete.002, curated.sequence-complete.003, curated.sequence-complete.004 |
| curated.shadow-match | 5 | curated.shadow-match.001, curated.shadow-match.002, curated.shadow-match.003, curated.shadow-match.004 |
| curated.shape-rotation | 5 | curated.shape-rotation.001, curated.shape-rotation.002, curated.shape-rotation.003, curated.shape-rotation.004 |

## Next QA Focus

- Add visual metadata to puzzles listed without assets.
- Keep type coverage above the minimum before adding new routes.
- Split repeated families when the dashboard shows saturation.

