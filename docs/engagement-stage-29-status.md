# Stage 29 Status: Collection And Customization

Stage 29 turns rewards into a real product system instead of a static sticker
album.

## Delivered

- Added `FoundationCatalog.collectionRewards` with 25 rewards across stickers,
  helper outfits, room decor, and puzzle badges.
- Added reward metadata for unlock stars, rarity, world, character, accent
  color, visual key, and equip behavior.
- Exported `collectionRewards` into `docs/content-manifest.json`.
- Added persistent child customization fields:
  - `selectedCharacterId`;
  - `selectedOutfitRewardId`;
  - `selectedDecorationRewardId`;
  - `selectedBadgeRewardId`.
- Added `AppController.equipCollectionReward`, guarded by unlock state.
- Added a dedicated Collection tab in the child shell.
- Rebuilt the collection screen as a collection room with:
  - overall progress and next reward;
  - equipped helper preview;
  - outfit, decor, badge, and sticker sections;
  - locked, collected, equip, and equipped states;
  - animated reward cards.

## Verification Coverage

- Profile serialization preserves customization selections.
- Old saved profiles migrate to default customization safely.
- Controller ignores locked rewards and saves unlocked equipped rewards.
- Content manifest exports collection reward metadata.
- Widget test opens the collection tab and equips an unlocked outfit.

## Next Recommended Stage

Stage 30 should build weekly events on top of the same reward foundation:
limited-time themes, event filters, event progress, and event-specific rewards.
