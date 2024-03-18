#import "components.typ": icon
#import "./util.typ": format-thousand

#let solve-tier-colors = (
  Unrated: color.rgb("#2d2d2d"),
  Bronze5: color.rgb("#9d4900"),
  Bronze4: color.rgb("#a54f00"),
  Bronze3: color.rgb("#ad5600"),
  Bronze2: color.rgb("#b55d0a"),
  Bronze1: color.rgb("#c67739"),
  Silver5: color.rgb("#38546e"),
  Silver4: color.rgb("#3d5a74"),
  Silver3: color.rgb("#435f7a"),
  Silver2: color.rgb("#496580"),
  Silver1: color.rgb("#4e6a86"),
  Gold5: color.rgb("#d28500"),
  Gold4: color.rgb("#df8f00"),
  Gold3: color.rgb("#ec9a00"),
  Gold2: color.rgb("#f9a518"),
  Gold1: color.rgb("#ffb028"),
  Platinum5: color.rgb("#00c78b"),
  Platinum4: color.rgb("#00d497"),
  Platinum3: color.rgb("#27e2a4"),
  Platinum2: color.rgb("#3ef0b1"),
  Platinum1: color.rgb("#51fdbd"),
  Diamond5: color.rgb("#009ee5"),
  Diamond4: color.rgb("#00a9f0"),
  Diamond3: color.rgb("#00b4fc"),
  Diamond2: color.rgb("#2bbfff"),
  Diamond1: color.rgb("#41caff"),
  Ruby5: color.rgb("#e0004c"),
  Ruby4: color.rgb("#ea0053"),
  Ruby3: color.rgb("#f5005a"),
  Ruby2: color.rgb("#ff0062"),
  Ruby1: color.rgb("#ff3071"),
  Master: color.rgb("#b491ff"),
)

#let solved-ac-tier-map = (
  "Unrated",
  ..("Bronze", "Silver", "Gold", "Platinum", "Diamond", "Ruby")
  .map((tier) => range(5, 0, step: -1).map(num => tier + str(num)))
  .fold((), (acc, curr) => (..acc, ..curr)),
  "Master",
)

#let solved-ac-profile(handle) = {
  [#metadata(handle) <solved-ac-user>]
  let user-db = json("../assets/.automatic/solved/user.json")
  if user-db.at(handle, default: none) != none {
    let user = user-db.at(handle)
    let tier-color = solve-tier-colors.at(solved-ac-tier-map.at(user.solveTier))
    [
      #icon(
        "solved-ac/arena-tier-" + str(user.arenaTier),
        height: 0.7em,
        width: auto,
        bottom: 0em,
      ) /
      #icon(
        "solved-ac/solve-tier-" + str(user.solveTier),
        width: auto,
        bottom: -1em / 4,
      )
      #text(
        fill: tier-color,
        weight: 700,
      )[
        #handle#super[\##{ user.rank }, top #{ calc.round(user.topPercent, digits: 2) }%]
      ]
      #text(
        fill: tier-color.darken(40%),
        size: 0.75em,
      )[(#format-thousand(user.solvedCount) solve)]
    ]
  } else {
    text(fill: color.rgb("#ff0000"))[\#NO_SOLVED_USER_DATA\#]
  }
}

#let solved-ac-profile-short(handle) = {
  [#metadata(handle) <solved-ac-user>]
  let user-db = json("../assets/.automatic/solved/user.json")
  if user-db.at(handle, default: none) != none {
    let user = user-db.at(handle)
    let tier-color = solve-tier-colors.at(solved-ac-tier-map.at(user.solveTier))
    [
      #handle#super[
        #icon(
          "solved-ac/solve-tier-" + str(user.solveTier),
          width: auto,
          bottom: -1em / 4,
        ) #sym.and
        #icon(
          "solved-ac/arena-tier-" + str(user.arenaTier),
          height: 0.7em,
          width: auto,
          bottom: 0em,
        )
      ]
    ]
  } else {
    text(fill: color.rgb("#ff0000"))[\#NO_SOLVED_USER_DATA\#]
  }
}
