# Tinder Swipe UI

![Swift](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![iOS 16+](https://img.shields.io/badge/iOS-16%2B-000000?logo=apple&logoColor=white)
![UIKit](https://img.shields.io/badge/UIKit-Gestures%20%26%20Animation-blue)

![Demo](docs/assets/demo2.gif)

> Tinder-style card swipe UI where a `UIPanGestureRecognizer` drives real-time card rotation via `CGAffineTransform` and commits or cancels the swipe with a threshold-gated `UIView` linear animation.

## Features

- **Proportional rotation:** As the card is dragged, `CGAffineTransform(rotationAngle: translation.x / 180)` applies a rotation in radians proportional to horizontal displacement — the card tilts naturally as it moves across the screen.
- **Horizontal-only translation:** The card's center is updated only on the X axis (`cardInitialCenter.x + translation.x`) while Y stays fixed, constraining movement to a lateral swipe trajectory.
- **Threshold-gated commit:** On pan `.ended`, a ±80pt threshold decides the outcome — past the threshold the card animates off-screen to ±1000pt in 0.3s; inside the threshold it snaps back to `cardInitialCenter` and resets `transform` to `.identity`.
- **Profile detail segue:** Tapping the card triggers `performSegue(withIdentifier: "passSegue")`, navigating to `ProfileViewController` which displays a full-screen `UIImageView` of the matched profile.
- **Storyboard-driven navigation:** Both view controllers are wired via storyboard segues; `CardsViewController` manages gesture state while `ProfileViewController` is a pure display layer.
- **Original center tracking:** `cardInitialCenter` is captured in `viewDidLoad` so the snap-back target is always the layout-defined resting position, regardless of where the gesture started.

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 6.0 |
| UI | UIKit, UIImageView |
| Gesture | UIPanGestureRecognizer, UITapGestureRecognizer |
| Transform | CGAffineTransform (rotation), CGPoint center manipulation |
| Animation | UIView linear animations (0.3s off-screen commit) |
| Navigation | UIStoryboardSegue |

## Architecture

Two view controllers in a storyboard: `CardsViewController` owns the swipeable card and all gesture logic, and `ProfileViewController` is a detail screen reached via the tap segue. State is minimal — `cardInitialCenter: CGPoint` is the only instance property needed to compute snap-back. Gesture handling lives entirely in a single `@IBAction`, keeping the controller focused and easy to extend with additional cards.

## Key Implementation

**Rotation-translation coupling:** `CGAffineTransform(rotationAngle:)` is applied directly to `sender.view?.transform` on every `.changed` event alongside center update. The rotation angle scales with `translation.x / 180` — at 180pt of drag the card has rotated exactly one radian (~57°), producing a physically grounded tilt without needing a separate animation.

**Off-screen commit:** The swipe-away animation targets `x: ±1000`, which is well outside any iPhone screen width, so the card exits cleanly without the user seeing it stop at the edge. The 0.3s linear duration matches the speed of a real physical flick.

**Identity reset on snap-back:** When the drag falls inside the ±80pt threshold, both `center` and `transform` are reset — restoring center alone would leave residual rotation on the card.

## Setup

```bash
git clone https://github.com/gerardrecinto/tinder-swipe-ui.git
open tinder-swipe-ui/Tinder.xcodeproj
```

Build and run on the iOS Simulator (Xcode 16+). No dependencies or API keys required.
