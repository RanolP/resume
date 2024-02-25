#import "components.typ": icon

#let solved-ac-tier-colors = (
  "Master": color.rgb("#b491ff").darken(10%),
  "Ruby": color.rgb("#ff3071"),
  "Diamond": color.rgb("#2bbfff").darken(15%),
  "Platinum": color.rgb("#51fdbd").darken(30%),
  "Gold": color.rgb("#ffb028").darken(20%),
  "Silver": color.rgb("#4e6a86"),
  "Bronze": color.rgb("#c67739"),
  "Unrated": color.rgb("#2d2d2d"),
)

#let solved-ac-tier-map = (
  "Unrated",
  ..("Bronze", "Silver", "Gold", "Platinum", "Diamond", "Ruby")
  .map((tier) => range(5, 0, step: -1).map(num => tier))
  .fold((), (acc, curr) => (..acc, ..curr)),
  "Master",
)

#let solved-ac-profile(handle) = {
  [#metadata(handle) <solved-ac-user>]
  let user-db = json("../assets/.automatic/solved/user.json")
  if user-db.at(handle, default: none) != none {
    let user = user-db.at(handle)
    let tier-color = solved-ac-tier-colors.at(solved-ac-tier-map.at(user.solveTier))
    [
      #text(fill: tier-color, weight: 700)[
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
        #handle
        (\##{ user.rank }, top #{ calc.round(user.topPercent, digits: 2) }%)
      ]
    ]
  } else {
    text(fill: color.rgb("#ff0000"))[\#NO_SOLVED_USER_DATA\#]
  }
}
